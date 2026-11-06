import 'dart:async';
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:drift/drift.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../data/database.dart';
import '../data/outbox.dart';
import '../services/api_client.dart';

/// Offline-first sync engine:
/// 1. UI mutates SQLite + enqueues `sync_queue`
/// 2. On connectivity → POST /api/sync (push batch + pull delta)
/// 3. Merge by `client_updated_at` LWW; soft deletes via `deleted_at`
class SyncEngine {
  SyncEngine({
    required this.db,
    required this.api,
    required this.outbox,
  });

  final AppDatabase db;
  final ApiClient api;
  final OutboxWriter outbox;

  final _status = StreamController<SyncStatus>.broadcast();
  StreamSubscription? _connSub;
  Timer? _retry;
  bool _running = false;
  String? _deviceId;

  Stream<SyncStatus> get status$ => _status.stream;

  Future<void> start() async {
    await api.restoreToken();
    final prefs = await SharedPreferences.getInstance();
    _deviceId = prefs.getString('device_id');
    if (_deviceId == null) {
      _deviceId = const Uuid().v4();
      await prefs.setString('device_id', _deviceId!);
    }

    _connSub = Connectivity()
        .onConnectivityChanged
        .listen((_) => unawaited(syncNow()));
    // Local DB is already readable. Merge with the cloud without blocking startup.
    unawaited(syncNow());
  }

  void dispose() {
    _connSub?.cancel();
    _retry?.cancel();
    _status.close();
  }

  Future<void> syncNow() async {
    if (_running) return;
    final token = await api.getToken();
    if (token == null) {
      _emit(online: await _isOnline(), pending: await outbox.pendingCount());
      return;
    }

    final online = await _isOnline();
    if (!online) {
      _emit(online: false, pending: await outbox.pendingCount());
      return;
    }

    _running = true;
    _emit(online: true, pending: await outbox.pendingCount(), syncing: true);
    try {
      await _pushPull();
      await _uploadPendingImages();
      _emit(online: true, pending: await outbox.pendingCount(), syncing: false);
    } catch (e) {
      _emit(
        online: true,
        pending: await outbox.pendingCount(),
        syncing: false,
        error: e.toString(),
      );
      _scheduleRetry(const Duration(seconds: 12));
    } finally {
      _running = false;
    }
  }

  void _scheduleRetry(Duration delay) {
    _retry?.cancel();
    _retry = Timer(delay, () => unawaited(syncNow()));
  }

  Future<void> _pushPull() async {
    final sinceRow = await (db.select(db.syncMeta)
          ..where((t) => t.key.equals('last_pull_at')))
        .getSingleOrNull();
    final since = sinceRow?.value;

    final pending = await outbox.pending();
    const batchSize = 100;

    if (pending.isEmpty) {
      final res = await api.sync(
        deviceId: _deviceId!,
        mutations: const [],
        since: since,
      );
      await _applyPull(res);
      return;
    }

    var allOk = true;
    for (var i = 0; i < pending.length; i += batchSize) {
      final batch = pending.skip(i).take(batchSize).toList();
      final isLast = i + batchSize >= pending.length;
      try {
        final res = await api.sync(
          deviceId: _deviceId!,
          mutations: batch.map(_wire).toList(),
          // Pull cursor only on the last batch, to avoid skipping writes.
          since: isLast ? since : null,
        );
        await outbox.removeAll(batch.map((r) => r.id));
        if (isLast) await _applyPull(res);
      } catch (e) {
        // One bad row fails the whole request. Retry row by row so the
        // healthy rows still sync and the bad ones keep their error.
        allOk = false;
        await _pushEach(batch);
      }
    }
    if (!allOk) throw StateError('Sincronización parcial: hay filas con error');
  }

  Map<String, dynamic> _wire(SyncOutboxData row) => {
        'entity': row.entity,
        'id': row.entityId,
        'op': row.op,
        'client_updated_at': row.clientUpdatedAt.toUtc().toIso8601String(),
        'payload': jsonDecode(row.payloadJson),
      };

  Future<void> _pushEach(List<SyncOutboxData> batch) async {
    var failed = 0;
    for (final row in batch) {
      try {
        await api.sync(
          deviceId: _deviceId!,
          mutations: [_wire(row)],
        );
        await outbox.remove(row.id);
      } catch (e) {
        failed++;
        await outbox.bumpAttempt(row.id, _describe(e));
      }
    }
    if (failed > 0) {
      // Back off gently; next connectivity / timer will retry pending rows.
      _scheduleRetry(Duration(seconds: (8 + failed * 2).clamp(8, 45)));
    }
  }

  static String _describe(Object e) {
    if (e is DioException) {
      final code = e.response?.statusCode;
      final body = e.response?.data;
      final msg = body is Map ? (body['message'] ?? body['error']) : null;
      return [
        if (code != null) 'HTTP $code',
        if (msg != null) msg.toString(),
        if (msg == null) e.message ?? 'error de red',
      ].join(': ');
    }
    return e.toString();
  }

  Future<void> _applyPull(Map<String, dynamic> res) async {
    final changes = (res['changes'] as Map<String, dynamic>?) ?? {};

    await db.transaction(() async {
      await _mergeEntity('categories', changes['categories'], _upsertCategory);
      await _mergeEntity('units', changes['units'], _upsertUnit);
      await _mergeEntity('products', changes['products'], _upsertProduct);
      await _mergeEntity('stores', changes['stores'], _upsertStore);
      await _mergeEntity(
          'shopping_lists', changes['shopping_lists'], _upsertShoppingList);
      await _mergeEntity('list_items', changes['list_items'], _upsertListItem);
      await _mergeEntity('purchase_histories', changes['purchase_histories'],
          _upsertPurchaseHistory);
      await _mergeEntity(
          'purchase_history_items',
          changes['purchase_history_items'],
          _upsertPurchaseHistoryItem);

      final serverTime = res['server_time'] as String?;
      if (serverTime != null) {
        await db.into(db.syncMeta).insertOnConflictUpdate(
              SyncMetaCompanion.insert(key: 'last_pull_at', value: serverTime),
            );
      }
    });
  }

  Future<void> _uploadPendingImages() async {
    final pending = await (db.select(db.products)
          ..where((t) =>
              t.imagePending.equals(true) &
              t.localImagePath.isNotNull() &
              t.deletedAt.isNull()))
        .get();
    for (final p in pending) {
      final local = p.localImagePath;
      if (local == null) continue;
      try {
        final res = await api.uploadProductImage(
          productId: p.id,
          filePath: local,
          clientUpdatedAt: p.clientUpdatedAt,
        );
        final product = res['product'] as Map<String, dynamic>?;
        await (db.update(db.products)..where((t) => t.id.equals(p.id))).write(
          ProductsCompanion(
            imagePath: Value(product?['image_path'] as String?),
            imagePending: const Value(false),
            updatedAt: Value(DateTime.now().toUtc()),
          ),
        );
      } catch (_) {
        // retry next sync
      }
    }
  }

  Future<void> _mergeEntity(
    String entity,
    dynamic rows,
    Future<void> Function(Map<String, dynamic>) upsert,
  ) async {
    if (rows is! List) return;
    for (final raw in rows) {
      if (raw is! Map) continue;
      final map = Map<String, dynamic>.from(raw);
      final id = map['id']?.toString();
      if (id == null) continue;
      final incoming = _parseDt(map['client_updated_at']);
      final local = await _localClientUpdatedAt(entity, id);
      if (local != null && incoming != null && local.isAfter(incoming)) {
        continue; // keep local newer
      }
      await upsert(map);
    }
  }

  Future<DateTime?> _localClientUpdatedAt(String entity, String id) async {
    switch (entity) {
      case 'categories':
        return (await (db.select(db.categories)..where((t) => t.id.equals(id)))
                .getSingleOrNull())
            ?.clientUpdatedAt;
      case 'units':
        return (await (db.select(db.units)..where((t) => t.id.equals(id)))
                .getSingleOrNull())
            ?.clientUpdatedAt;
      case 'products':
        return (await (db.select(db.products)..where((t) => t.id.equals(id)))
                .getSingleOrNull())
            ?.clientUpdatedAt;
      case 'stores':
        return (await (db.select(db.stores)..where((t) => t.id.equals(id)))
                .getSingleOrNull())
            ?.clientUpdatedAt;
      case 'shopping_lists':
        return (await (db.select(db.shoppingLists)
                  ..where((t) => t.id.equals(id)))
                .getSingleOrNull())
            ?.clientUpdatedAt;
      case 'list_items':
        return (await (db.select(db.listItems)..where((t) => t.id.equals(id)))
                .getSingleOrNull())
            ?.clientUpdatedAt;
      case 'purchase_histories':
        return (await (db.select(db.purchaseHistories)
                  ..where((t) => t.id.equals(id)))
                .getSingleOrNull())
            ?.clientUpdatedAt;
      case 'purchase_history_items':
        return (await (db.select(db.purchaseHistoryItems)
                  ..where((t) => t.id.equals(id)))
                .getSingleOrNull())
            ?.clientUpdatedAt;
      default:
        return null;
    }
  }

  Future<void> _upsertCategory(Map<String, dynamic> m) async {
    await db.into(db.categories).insertOnConflictUpdate(CategoriesCompanion(
          id: Value(m['id'].toString()),
          userId: Value(m['user_id']?.toString()),
          deviceId: Value(m['device_id']?.toString()),
          name: Value(m['name']?.toString() ?? ''),
          icon: Value(m['icon']?.toString()),
          color: Value(m['color']?.toString()),
          clientUpdatedAt: Value(
              _parseDt(m['client_updated_at']) ?? DateTime.now().toUtc()),
          updatedAt:
              Value(_parseDt(m['updated_at']) ?? DateTime.now().toUtc()),
          createdAt:
              Value(_parseDt(m['created_at']) ?? DateTime.now().toUtc()),
          deletedAt: Value(_parseDt(m['deleted_at'])),
        ));
  }

  Future<void> _upsertUnit(Map<String, dynamic> m) async {
    await db.into(db.units).insertOnConflictUpdate(UnitsCompanion(
          id: Value(m['id'].toString()),
          userId: Value(m['user_id']?.toString()),
          deviceId: Value(m['device_id']?.toString()),
          name: Value(m['name']?.toString() ?? ''),
          abbreviation: Value(m['abbreviation']?.toString()),
          clientUpdatedAt: Value(
              _parseDt(m['client_updated_at']) ?? DateTime.now().toUtc()),
          updatedAt:
              Value(_parseDt(m['updated_at']) ?? DateTime.now().toUtc()),
          createdAt:
              Value(_parseDt(m['created_at']) ?? DateTime.now().toUtc()),
          deletedAt: Value(_parseDt(m['deleted_at'])),
        ));
  }

  Future<void> _upsertProduct(Map<String, dynamic> m) async {
    await db.into(db.products).insertOnConflictUpdate(ProductsCompanion(
          id: Value(m['id'].toString()),
          userId: Value(m['user_id']?.toString()),
          deviceId: Value(m['device_id']?.toString()),
          name: Value(m['name']?.toString() ?? ''),
          description: Value(m['description']?.toString()),
          categoryId: Value(m['category_id']?.toString()),
          unitId: Value(m['unit_id']?.toString()),
          basePrice: Value(_toDouble(m['base_price'])),
          imagePath: Value(m['image_path']?.toString()),
          imagePending:
              Value(m['image_pending'] == true || m['image_pending'] == 1),
          clientUpdatedAt: Value(
              _parseDt(m['client_updated_at']) ?? DateTime.now().toUtc()),
          updatedAt:
              Value(_parseDt(m['updated_at']) ?? DateTime.now().toUtc()),
          createdAt:
              Value(_parseDt(m['created_at']) ?? DateTime.now().toUtc()),
          deletedAt: Value(_parseDt(m['deleted_at'])),
        ));
  }

  Future<void> _upsertStore(Map<String, dynamic> m) async {
    await db.into(db.stores).insertOnConflictUpdate(StoresCompanion(
          id: Value(m['id'].toString()),
          userId: Value(m['user_id']?.toString()),
          deviceId: Value(m['device_id']?.toString()),
          name: Value(m['name']?.toString() ?? ''),
          location: Value(m['location']?.toString()),
          icon: Value(m['icon']?.toString()),
          notes: Value(m['notes']?.toString()),
          clientUpdatedAt: Value(
              _parseDt(m['client_updated_at']) ?? DateTime.now().toUtc()),
          updatedAt:
              Value(_parseDt(m['updated_at']) ?? DateTime.now().toUtc()),
          createdAt:
              Value(_parseDt(m['created_at']) ?? DateTime.now().toUtc()),
          deletedAt: Value(_parseDt(m['deleted_at'])),
        ));
  }

  Future<void> _upsertShoppingList(Map<String, dynamic> m) async {
    await db.into(db.shoppingLists).insertOnConflictUpdate(
          ShoppingListsCompanion(
            id: Value(m['id'].toString()),
            userId: Value(m['user_id']?.toString()),
            deviceId: Value(m['device_id']?.toString()),
            name: Value(m['name']?.toString() ?? ''),
            status: Value(m['status']?.toString() ?? 'active'),
            notes: Value(m['notes']?.toString()),
            icon: Value(m['icon']?.toString()),
            storeId: Value(m['store_id']?.toString()),
            storeLocation: Value(m['store_location']?.toString()),
            clientUpdatedAt: Value(
                _parseDt(m['client_updated_at']) ?? DateTime.now().toUtc()),
            updatedAt:
                Value(_parseDt(m['updated_at']) ?? DateTime.now().toUtc()),
            createdAt:
                Value(_parseDt(m['created_at']) ?? DateTime.now().toUtc()),
            deletedAt: Value(_parseDt(m['deleted_at'])),
          ),
        );
  }

  Future<void> _upsertListItem(Map<String, dynamic> m) async {
    await db.into(db.listItems).insertOnConflictUpdate(ListItemsCompanion(
          id: Value(m['id'].toString()),
          userId: Value(m['user_id']?.toString()),
          deviceId: Value(m['device_id']?.toString()),
          shoppingListId: Value(m['shopping_list_id']?.toString() ?? ''),
          productId: Value(m['product_id']?.toString()),
          unitId: Value(m['unit_id']?.toString()),
          unitAbbr: Value(m['unit_abbr']?.toString()),
          name: Value(m['name']?.toString() ?? ''),
          qtyPlanned: Value(_toDouble(m['qty_planned']) ?? 1),
          qtyBought: Value(_toDouble(m['qty_bought'])),
          unitPrice: Value(_toDouble(m['unit_price'])),
          status: Value(m['status']?.toString() ?? 'pending'),
          clientUpdatedAt: Value(
              _parseDt(m['client_updated_at']) ?? DateTime.now().toUtc()),
          updatedAt:
              Value(_parseDt(m['updated_at']) ?? DateTime.now().toUtc()),
          createdAt:
              Value(_parseDt(m['created_at']) ?? DateTime.now().toUtc()),
          deletedAt: Value(_parseDt(m['deleted_at'])),
        ));
  }

  Future<void> _upsertPurchaseHistory(Map<String, dynamic> m) async {
    await db.into(db.purchaseHistories).insertOnConflictUpdate(
          PurchaseHistoriesCompanion(
            id: Value(m['id'].toString()),
            userId: Value(m['user_id']?.toString()),
            deviceId: Value(m['device_id']?.toString()),
            shoppingListId: Value(m['shopping_list_id']?.toString()),
            storeLocation: Value(m['store_location']?.toString()),
            purchasedAt:
                Value(_parseDt(m['purchased_at']) ?? DateTime.now().toUtc()),
            total: Value(_toDouble(m['total']) ?? 0),
            clientUpdatedAt: Value(
                _parseDt(m['client_updated_at']) ?? DateTime.now().toUtc()),
            updatedAt:
                Value(_parseDt(m['updated_at']) ?? DateTime.now().toUtc()),
            createdAt:
                Value(_parseDt(m['created_at']) ?? DateTime.now().toUtc()),
            deletedAt: Value(_parseDt(m['deleted_at'])),
          ),
        );
  }

  Future<void> _upsertPurchaseHistoryItem(Map<String, dynamic> m) async {
    await db.into(db.purchaseHistoryItems).insertOnConflictUpdate(
          PurchaseHistoryItemsCompanion(
            id: Value(m['id'].toString()),
            userId: Value(m['user_id']?.toString()),
            deviceId: Value(m['device_id']?.toString()),
            purchaseHistoryId:
                Value(m['purchase_history_id']?.toString() ?? ''),
            productId: Value(m['product_id']?.toString()),
            name: Value(m['name']?.toString() ?? ''),
            unitAbbr: Value(m['unit_abbr']?.toString()),
            quantity: Value(_toDouble(m['quantity']) ?? 1),
            unitPrice: Value(_toDouble(m['unit_price'])),
            lineTotal: Value(_toDouble(m['line_total'])),
            clientUpdatedAt: Value(
                _parseDt(m['client_updated_at']) ?? DateTime.now().toUtc()),
            updatedAt:
                Value(_parseDt(m['updated_at']) ?? DateTime.now().toUtc()),
            createdAt:
                Value(_parseDt(m['created_at']) ?? DateTime.now().toUtc()),
            deletedAt: Value(_parseDt(m['deleted_at'])),
          ),
        );
  }

  DateTime? _parseDt(dynamic v) {
    if (v == null) return null;
    return DateTime.tryParse(v.toString())?.toUtc();
  }

  double? _toDouble(dynamic v) {
    if (v == null) return null;
    if (v is num) return v.toDouble();
    return double.tryParse(v.toString());
  }

  Future<bool> _isOnline() async {
    final result = await Connectivity().checkConnectivity();
    return result.any((r) => r != ConnectivityResult.none);
  }

  Future<void> _emit({
    required bool online,
    required int pending,
    bool syncing = false,
    String? error,
  }) async {
    _status.add(SyncStatus(
      online: online,
      pending: pending,
      syncing: syncing,
      error: error,
    ));
  }
}

class SyncStatus {
  SyncStatus({
    required this.online,
    required this.pending,
    this.syncing = false,
    this.error,
  });

  final bool online;
  final int pending;
  final bool syncing;
  final String? error;
}
