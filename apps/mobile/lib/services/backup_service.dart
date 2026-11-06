import 'package:drift/drift.dart';

import '../data/database.dart';
import '../data/outbox.dart';
import '../data/repository.dart';

const backupFormat = 'wicart-backup';
const backupVersion = 1;

/// Local JSON backup. Selection is a union:
/// one store (its lists and the products on them), extra lists,
/// every product, and/or every category.
class BackupService {
  BackupService(this.repo);

  final CartRepository repo;

  Future<Map<String, dynamic>> build({
    String? storeId,
    Set<String> listIds = const {},
    bool allProducts = false,
    bool allCategories = false,
  }) async {
    if (storeId == null && listIds.isEmpty && !allProducts && !allCategories) {
      throw ArgumentError('Nada seleccionado');
    }
    final db = repo.db;
    final stores = await (db.select(db.stores)
          ..where((t) => t.deletedAt.isNull()))
        .get();
    final lists = await (db.select(db.shoppingLists)
          ..where((t) => t.deletedAt.isNull()))
        .get();
    final items = await (db.select(db.listItems)
          ..where((t) => t.deletedAt.isNull()))
        .get();
    final products = await repo.getProducts();
    final categories = await repo.getCategories();
    final units = await repo.getUnits();

    final wantedLists = lists.where((l) {
      if (listIds.contains(l.id)) return true;
      return storeId != null && l.storeId == storeId;
    }).toList();
    final wantedListIds = wantedLists.map((l) => l.id).toSet();
    final wantedItems =
        items.where((i) => wantedListIds.contains(i.shoppingListId)).toList();

    final productIds = <String>{
      if (allProducts) ...products.map((p) => p.id),
      for (final i in wantedItems)
        if (i.productId != null) i.productId!,
    };
    final wantedProducts =
        products.where((p) => productIds.contains(p.id)).toList();

    final categoryIds = <String>{
      if (allCategories) ...categories.map((c) => c.id),
      for (final p in wantedProducts)
        if (p.categoryId != null) p.categoryId!,
    };
    final unitIds = <String>{
      for (final p in wantedProducts)
        if (p.unitId != null) p.unitId!,
      for (final i in wantedItems)
        if (i.unitId != null) i.unitId!,
    };
    final storeIds = <String>{
      if (storeId != null) storeId,
      for (final l in wantedLists)
        if (l.storeId != null) l.storeId!,
    };

    return {
      'format': backupFormat,
      'version': backupVersion,
      'exported_at': DateTime.now().toUtc().toIso8601String(),
      'stores': [
        for (final s in stores)
          if (storeIds.contains(s.id))
            {
              'id': s.id,
              'name': s.name,
              'location': s.location,
              'icon': s.icon,
              'notes': s.notes,
            },
      ],
      'categories': [
        for (final c in categories)
          if (categoryIds.contains(c.id))
            {
              'id': c.id,
              'name': c.name,
              'icon': c.icon,
              'color': c.color,
            },
      ],
      'units': [
        for (final u in units)
          if (unitIds.contains(u.id))
            {
              'id': u.id,
              'name': u.name,
              'abbreviation': u.abbreviation,
            },
      ],
      'products': [
        for (final p in wantedProducts)
          {
            'id': p.id,
            'name': p.name,
            'description': p.description,
            'category_id': p.categoryId,
            'unit_id': p.unitId,
            'base_price': p.basePrice,
            'image_path': p.imagePath,
          },
      ],
      'shopping_lists': [
        for (final l in wantedLists)
          {
            'id': l.id,
            'name': l.name,
            'status': l.status,
            'notes': l.notes,
            'icon': l.icon,
            'store_id': l.storeId,
            'store_location': l.storeLocation,
          },
      ],
      'list_items': [
        for (final i in wantedItems)
          {
            'id': i.id,
            'shopping_list_id': i.shoppingListId,
            'product_id': i.productId,
            'unit_id': i.unitId,
            'unit_abbr': i.unitAbbr,
            'name': i.name,
            'qty_planned': i.qtyPlanned,
            'qty_bought': i.qtyBought,
            'unit_price': i.unitPrice,
            'status': i.status,
            'notes': i.notes,
          },
      ],
    };
  }

  /// Insert or update rows from [build]. Same ids, so a second restore
  /// does not duplicate. Enqueues sync.
  Future<int> restore(Map<String, dynamic> doc) async {
    if (doc['format'] != backupFormat) {
      throw FormatException('Archivo de respaldo no reconocido');
    }
    final db = repo.db;
    final outbox = repo.outbox;
    var n = 0;
    n += await _restoreCategories(db, outbox, _rows(doc, 'categories'));
    n += await _restoreUnits(db, outbox, _rows(doc, 'units'));
    n += await _restoreStores(db, outbox, _rows(doc, 'stores'));
    n += await _restoreProducts(db, outbox, _rows(doc, 'products'));
    n += await _restoreLists(db, outbox, _rows(doc, 'shopping_lists'));
    n += await _restoreItems(db, outbox, _rows(doc, 'list_items'));
    return n;
  }

  List<Map<String, dynamic>> _rows(Map<String, dynamic> doc, String key) {
    final raw = doc[key];
    if (raw is! List) return const [];
    return [
      for (final row in raw)
        if (row is Map) Map<String, dynamic>.from(row),
    ];
  }
}

Future<int> _restoreCategories(
  AppDatabase db,
  OutboxWriter outbox,
  List<Map<String, dynamic>> rows,
) async {
  var n = 0;
  for (final row in rows) {
    final id = row['id']?.toString();
    final name = row['name']?.toString();
    if (id == null || name == null || name.isEmpty) continue;
    final now = DateTime.now().toUtc();
    final existing = await (db.select(db.categories)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    await db.into(db.categories).insertOnConflictUpdate(CategoriesCompanion(
          id: Value(id),
          name: Value(name),
          icon: Value(row['icon']?.toString()),
          color: Value(row['color']?.toString()),
          clientUpdatedAt: Value(now),
          updatedAt: Value(now),
          createdAt: Value(existing?.createdAt ?? now),
          deletedAt: const Value(null),
        ));
    await outbox.enqueue(
      entity: 'categories',
      entityId: id,
      op: existing == null ? SyncOp.create : SyncOp.update,
      clientUpdatedAt: now,
      payload: {
        'name': name,
        'icon': row['icon'],
        'color': row['color'],
      },
    );
    n++;
  }
  return n;
}

Future<int> _restoreUnits(
  AppDatabase db,
  OutboxWriter outbox,
  List<Map<String, dynamic>> rows,
) async {
  var n = 0;
  for (final row in rows) {
    final id = row['id']?.toString();
    final name = row['name']?.toString();
    if (id == null || name == null || name.isEmpty) continue;
    final now = DateTime.now().toUtc();
    final existing = await (db.select(db.units)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    await db.into(db.units).insertOnConflictUpdate(UnitsCompanion(
          id: Value(id),
          name: Value(name),
          abbreviation: Value(row['abbreviation']?.toString()),
          clientUpdatedAt: Value(now),
          updatedAt: Value(now),
          createdAt: Value(existing?.createdAt ?? now),
          deletedAt: const Value(null),
        ));
    await outbox.enqueue(
      entity: 'units',
      entityId: id,
      op: existing == null ? SyncOp.create : SyncOp.update,
      clientUpdatedAt: now,
      payload: {
        'name': name,
        'abbreviation': row['abbreviation'],
      },
    );
    n++;
  }
  return n;
}

Future<int> _restoreStores(
  AppDatabase db,
  OutboxWriter outbox,
  List<Map<String, dynamic>> rows,
) async {
  var n = 0;
  for (final row in rows) {
    final id = row['id']?.toString();
    final name = row['name']?.toString();
    if (id == null || name == null || name.isEmpty) continue;
    final now = DateTime.now().toUtc();
    final existing = await (db.select(db.stores)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    await db.into(db.stores).insertOnConflictUpdate(StoresCompanion(
          id: Value(id),
          name: Value(name),
          location: Value(row['location']?.toString()),
          icon: Value(row['icon']?.toString()),
          notes: Value(row['notes']?.toString()),
          clientUpdatedAt: Value(now),
          updatedAt: Value(now),
          createdAt: Value(existing?.createdAt ?? now),
          deletedAt: const Value(null),
        ));
    await outbox.enqueue(
      entity: 'stores',
      entityId: id,
      op: existing == null ? SyncOp.create : SyncOp.update,
      clientUpdatedAt: now,
      payload: {
        'name': name,
        'location': row['location'],
        'icon': row['icon'],
        'notes': row['notes'],
      },
    );
    n++;
  }
  return n;
}

Future<int> _restoreProducts(
  AppDatabase db,
  OutboxWriter outbox,
  List<Map<String, dynamic>> rows,
) async {
  var n = 0;
  for (final row in rows) {
    final id = row['id']?.toString();
    final name = row['name']?.toString();
    if (id == null || name == null || name.isEmpty) continue;
    final now = DateTime.now().toUtc();
    final existing = await (db.select(db.products)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    await db.into(db.products).insertOnConflictUpdate(ProductsCompanion(
          id: Value(id),
          name: Value(name),
          description: Value(row['description']?.toString()),
          categoryId: Value(row['category_id']?.toString()),
          unitId: Value(row['unit_id']?.toString()),
          basePrice: Value(_num(row['base_price'])),
          imagePath: Value(row['image_path']?.toString()),
          imagePending: const Value(false),
          clientUpdatedAt: Value(now),
          updatedAt: Value(now),
          createdAt: Value(existing?.createdAt ?? now),
          deletedAt: const Value(null),
        ));
    await outbox.enqueue(
      entity: 'products',
      entityId: id,
      op: existing == null ? SyncOp.create : SyncOp.update,
      clientUpdatedAt: now,
      payload: {
        'name': name,
        'description': row['description'],
        'category_id': row['category_id'],
        'unit_id': row['unit_id'],
        'base_price': _num(row['base_price']),
        'image_path': row['image_path'],
        'image_pending': false,
      },
    );
    n++;
  }
  return n;
}

Future<int> _restoreLists(
  AppDatabase db,
  OutboxWriter outbox,
  List<Map<String, dynamic>> rows,
) async {
  var n = 0;
  for (final row in rows) {
    final id = row['id']?.toString();
    final name = row['name']?.toString();
    if (id == null || name == null || name.isEmpty) continue;
    final now = DateTime.now().toUtc();
    final existing = await (db.select(db.shoppingLists)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    final status = row['status']?.toString() ?? 'active';
    await db.into(db.shoppingLists).insertOnConflictUpdate(ShoppingListsCompanion(
          id: Value(id),
          name: Value(name),
          status: Value(status),
          notes: Value(row['notes']?.toString()),
          icon: Value(row['icon']?.toString()),
          storeId: Value(row['store_id']?.toString()),
          storeLocation: Value(row['store_location']?.toString()),
          clientUpdatedAt: Value(now),
          updatedAt: Value(now),
          createdAt: Value(existing?.createdAt ?? now),
          deletedAt: const Value(null),
        ));
    await outbox.enqueue(
      entity: 'shopping_lists',
      entityId: id,
      op: existing == null ? SyncOp.create : SyncOp.update,
      clientUpdatedAt: now,
      payload: {
        'name': name,
        'status': status,
        'notes': row['notes'],
        'icon': row['icon'],
        'store_id': row['store_id'],
        'store_location': row['store_location'],
      },
    );
    n++;
  }
  return n;
}

Future<int> _restoreItems(
  AppDatabase db,
  OutboxWriter outbox,
  List<Map<String, dynamic>> rows,
) async {
  var n = 0;
  for (final row in rows) {
    final id = row['id']?.toString();
    final listId = row['shopping_list_id']?.toString();
    final name = row['name']?.toString();
    if (id == null || listId == null || name == null || name.isEmpty) continue;
    final now = DateTime.now().toUtc();
    final existing = await (db.select(db.listItems)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    final status = row['status']?.toString() ?? 'pending';
    final qty = _num(row['qty_planned']) ?? 1;
    await db.into(db.listItems).insertOnConflictUpdate(ListItemsCompanion(
          id: Value(id),
          shoppingListId: Value(listId),
          productId: Value(row['product_id']?.toString()),
          unitId: Value(row['unit_id']?.toString()),
          unitAbbr: Value(row['unit_abbr']?.toString()),
          name: Value(name),
          qtyPlanned: Value(qty),
          qtyBought: Value(_num(row['qty_bought'])),
          unitPrice: Value(_num(row['unit_price'])),
          status: Value(status),
          notes: Value(row['notes']?.toString()),
          clientUpdatedAt: Value(now),
          updatedAt: Value(now),
          createdAt: Value(existing?.createdAt ?? now),
          deletedAt: const Value(null),
        ));
    await outbox.enqueue(
      entity: 'list_items',
      entityId: id,
      op: existing == null ? SyncOp.create : SyncOp.update,
      clientUpdatedAt: now,
      payload: {
        'shopping_list_id': listId,
        'product_id': row['product_id'],
        'unit_id': row['unit_id'],
        'unit_abbr': row['unit_abbr'],
        'name': name,
        'qty_planned': qty,
        'qty_bought': _num(row['qty_bought']),
        'unit_price': _num(row['unit_price']),
        'status': status,
        'notes': row['notes'],
      },
    );
    n++;
  }
  return n;
}

double? _num(Object? v) {
  if (v == null) return null;
  if (v is num) return v.toDouble();
  return double.tryParse(v.toString());
}
