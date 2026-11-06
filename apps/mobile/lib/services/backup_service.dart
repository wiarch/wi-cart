import 'dart:convert';

import 'package:drift/drift.dart';

import '../data/database.dart';
import '../data/outbox.dart';
import '../data/repository.dart';

const backupFormat = 'wicart-backup';
const backupVersion = 1;

/// Pretty JSON bytes. Runs in a background isolate via [compute].
Uint8List encodeBackupJson(Map<String, dynamic> doc) {
  return Uint8List.fromList(
    utf8.encode(const JsonEncoder.withIndent('  ').convert(doc)),
  );
}

/// Parses a backup file. Runs in a background isolate via [compute].
Map<String, dynamic> decodeBackupJson(Uint8List bytes) {
  final decoded = jsonDecode(utf8.decode(bytes));
  if (decoded is! Map) {
    throw const FormatException('JSON inválido');
  }
  return Map<String, dynamic>.from(
    decoded.map((key, value) => MapEntry(key.toString(), value)),
  );
}

/// Plain-text dump of the lists in [doc].
Uint8List encodeBackupText(Map<String, dynamic> doc) {
  final lists = _indexById(_asMaps(doc['shopping_lists']));
  final buf = StringBuffer()..writeln('wi-cart');
  final byList = <String, List<Map<String, dynamic>>>{};
  for (final item in _asMaps(doc['list_items'])) {
    final listId = item['shopping_list_id']?.toString() ?? '';
    byList.putIfAbsent(listId, () => []).add(item);
  }
  final seen = <String>{};
  for (final entry in byList.entries) {
    seen.add(entry.key);
    final name = lists[entry.key]?['name']?.toString() ?? 'Lista';
    buf.writeln('# $name');
    for (final item in entry.value) {
      buf.writeln(
        '- ${item['name'] ?? ''} | ${item['qty_planned'] ?? 1} | '
        '${item['unit_abbr'] ?? ''} | ${item['unit_price'] ?? ''} | '
        '${item['status'] ?? 'pending'}',
      );
    }
  }
  for (final list in lists.values) {
    final id = list['id']?.toString() ?? '';
    if (seen.contains(id)) continue;
    buf.writeln('# ${list['name'] ?? 'Lista'}');
  }
  return Uint8List.fromList(utf8.encode(buf.toString()));
}

/// SpreadsheetML that Excel opens. No extra package.
Uint8List encodeBackupExcel(Map<String, dynamic> doc) {
  final lists = _indexById(_asMaps(doc['shopping_lists']));
  final buf = StringBuffer()
    ..writeln('<?xml version="1.0"?>')
    ..writeln('<?mso-application progid="Excel.Sheet"?>')
    ..writeln(
      '<Workbook xmlns="urn:schemas-microsoft-com:office:spreadsheet" '
      'xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet">',
    )
    ..writeln('<Worksheet ss:Name="Listas"><Table>');
  void row(List<String> cells) {
    buf.write('<Row>');
    for (final cell in cells) {
      buf.write('<Cell><Data ss:Type="String">${_xml(cell)}</Data></Cell>');
    }
    buf.writeln('</Row>');
  }

  row(['Lista', 'Producto', 'Cantidad', 'Unidad', 'Precio', 'Estado']);
  for (final item in _asMaps(doc['list_items'])) {
    final listId = item['shopping_list_id']?.toString() ?? '';
    row([
      lists[listId]?['name']?.toString() ?? 'Lista',
      item['name']?.toString() ?? '',
      '${item['qty_planned'] ?? 1}',
      item['unit_abbr']?.toString() ?? '',
      '${item['unit_price'] ?? ''}',
      item['status']?.toString() ?? 'pending',
    ]);
  }
  buf.writeln('</Table></Worksheet></Workbook>');
  return Uint8List.fromList(utf8.encode(buf.toString()));
}

/// Lists parsed from the text export. Runs in an isolate.
List<Map<String, dynamic>> decodeBackupText(Uint8List bytes) {
  final lists = <Map<String, dynamic>>[];
  Map<String, dynamic>? current;
  for (final raw in utf8.decode(bytes).split('\n')) {
    final line = raw.trim();
    if (line.startsWith('# ')) {
      current = {'name': line.substring(2).trim(), 'items': <Map<String, dynamic>>[]};
      if ((current['name'] as String).isEmpty) current['name'] = 'Lista';
      lists.add(current);
    } else if (line.startsWith('- ') && current != null) {
      final parts = line.substring(2).split('|').map((s) => s.trim()).toList();
      (current['items'] as List<Map<String, dynamic>>).add({
        'name': parts.isNotEmpty ? parts[0] : '',
        'qty': parts.length > 1 ? parts[1] : '1',
        'abbr': parts.length > 2 ? parts[2] : '',
        'price': parts.length > 3 ? parts[3] : '',
        'status': parts.length > 4 ? parts[4] : 'pending',
      });
    }
  }
  return lists;
}

/// Lists parsed from the Excel export.
List<Map<String, dynamic>> decodeBackupExcel(Uint8List bytes) {
  final xml = utf8.decode(bytes);
  final rowRe = RegExp(r'<Row\b[^>]*>(.*?)</Row>', dotAll: true);
  final cellRe = RegExp(r'<Data\b[^>]*>(.*?)</Data>', dotAll: true);
  final grouped = <String, List<Map<String, dynamic>>>{};
  var header = true;
  for (final row in rowRe.allMatches(xml)) {
    final cells = [
      for (final cell in cellRe.allMatches(row.group(1)!))
        cell.group(1)!.replaceAll('&lt;', '<').replaceAll('&gt;', '>').replaceAll('&amp;', '&'),
    ];
    if (cells.isEmpty) continue;
    if (header) {
      header = false;
      continue;
    }
    final listName = cells[0].trim().isEmpty ? 'Lista' : cells[0].trim();
    final name = cells.length > 1 ? cells[1].trim() : '';
    if (name.isEmpty) continue;
    grouped.putIfAbsent(listName, () => []).add({
      'name': name,
      'qty': cells.length > 2 ? cells[2] : '1',
      'abbr': cells.length > 3 ? cells[3] : '',
      'price': cells.length > 4 ? cells[4] : '',
      'status': cells.length > 5 ? cells[5] : 'pending',
    });
  }
  return [
    for (final entry in grouped.entries) {'name': entry.key, 'items': entry.value},
  ];
}

Map<String, Map<String, dynamic>> _indexById(List<Map<String, dynamic>> rows) {
  return {for (final row in rows) row['id']?.toString() ?? '': row};
}

List<Map<String, dynamic>> _asMaps(Object? raw) {
  if (raw is! List) return const [];
  return [
    for (final row in raw)
      if (row is Map) Map<String, dynamic>.from(row),
  ];
}

String _xml(String value) => value
    .replaceAll('&', '&amp;')
    .replaceAll('<', '&lt;')
    .replaceAll('>', '&gt;');

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
    bool full = false,
  }) async {
    if (!full &&
        storeId == null &&
        listIds.isEmpty &&
        !allProducts &&
        !allCategories) {
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

    final wantedLists = full
        ? lists
        : lists.where((l) {
            if (listIds.contains(l.id)) return true;
            return storeId != null && l.storeId == storeId;
          }).toList();
    final wantedListIds = wantedLists.map((l) => l.id).toSet();
    final wantedItems =
        items.where((i) => wantedListIds.contains(i.shoppingListId)).toList();

    final productIds = <String>{
      if (full || allProducts) ...products.map((p) => p.id),
      for (final i in wantedItems)
        if (i.productId != null) i.productId!,
    };
    final wantedProducts =
        products.where((p) => productIds.contains(p.id)).toList();

    final categoryIds = <String>{
      if (full || allCategories) ...categories.map((c) => c.id),
      for (final p in wantedProducts)
        if (p.categoryId != null) p.categoryId!,
    };
    final unitIds = <String>{
      if (full) ...units.map((u) => u.id),
      for (final p in wantedProducts)
        if (p.unitId != null) p.unitId!,
      for (final i in wantedItems)
        if (i.unitId != null) i.unitId!,
    };
    final storeIds = <String>{
      if (full) ...stores.map((s) => s.id),
      if (storeId != null) storeId,
      for (final l in wantedLists)
        if (l.storeId != null) l.storeId!,
    };

    final doc = <String, dynamic>{
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
            'local_image_path': p.localImagePath,
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
    if (!full) return doc;
    final histories = await (db.select(db.purchaseHistories)
          ..where((t) => t.deletedAt.isNull()))
        .get();
    final historyItems = await (db.select(db.purchaseHistoryItems)
          ..where((t) => t.deletedAt.isNull()))
        .get();
    final movements = await db.select(db.budgetMovements).get();
    doc['purchase_histories'] = [
      for (final h in histories)
        {
          'id': h.id,
          'shopping_list_id': h.shoppingListId,
          'store_location': h.storeLocation,
          'purchased_at': h.purchasedAt.toUtc().toIso8601String(),
          'total': h.total,
        },
    ];
    doc['purchase_history_items'] = [
      for (final i in historyItems)
        {
          'id': i.id,
          'purchase_history_id': i.purchaseHistoryId,
          'product_id': i.productId,
          'name': i.name,
          'unit_abbr': i.unitAbbr,
          'quantity': i.quantity,
          'unit_price': i.unitPrice,
          'line_total': i.lineTotal,
        },
    ];
    doc['budget_movements'] = [
      for (final m in movements)
        {
          'id': m.id,
          'label': m.label,
          'amount_usd': m.amountUsd,
          'occurred_at': m.occurredAt.toUtc().toIso8601String(),
        },
    ];
    return doc;
  }

  /// Creates lists from a text or Excel export.
  Future<int> importPlain(List<Map<String, dynamic>> lists) async {
    var n = 0;
    for (final list in lists) {
      final name = list['name']?.toString().trim() ?? '';
      if (name.isEmpty) continue;
      final created = await repo.createList(name);
      n++;
      await Future<void>.delayed(Duration.zero);
      final rawItems = list['items'];
      if (rawItems is! List) continue;
      for (final raw in rawItems) {
        if (raw is! Map) continue;
        final itemName = raw['name']?.toString().trim() ?? '';
        if (itemName.isEmpty) continue;
        final price = double.tryParse(
          raw['price']?.toString().replaceAll(',', '.') ?? '',
        );
        final item = await repo.addItem(
          listId: created.id,
          name: itemName,
          unitAbbr: raw['abbr']?.toString(),
          qtyPlanned: double.tryParse(
                raw['qty']?.toString().replaceAll(',', '.') ?? '',
              ) ??
              1,
          unitPrice: price,
        );
        if (raw['status']?.toString() == 'in_cart') {
          await repo.setItemStatus(item, 'in_cart');
        }
        n++;
        if (n % 20 == 0) await Future<void>.delayed(Duration.zero);
      }
    }
    return n;
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
    await Future<void>.delayed(Duration.zero);
    n += await _restoreUnits(db, outbox, _rows(doc, 'units'));
    await Future<void>.delayed(Duration.zero);
    n += await _restoreStores(db, outbox, _rows(doc, 'stores'));
    await Future<void>.delayed(Duration.zero);
    n += await _restoreProducts(db, outbox, _rows(doc, 'products'));
    await Future<void>.delayed(Duration.zero);
    n += await _restoreLists(db, outbox, _rows(doc, 'shopping_lists'));
    await Future<void>.delayed(Duration.zero);
    n += await _restoreItems(db, outbox, _rows(doc, 'list_items'));
    await Future<void>.delayed(Duration.zero);
    n += await _restoreHistories(db, outbox, _rows(doc, 'purchase_histories'));
    await Future<void>.delayed(Duration.zero);
    n += await _restoreHistoryItems(
      db,
      outbox,
      _rows(doc, 'purchase_history_items'),
    );
    await Future<void>.delayed(Duration.zero);
    n += await _restoreBudget(db, _rows(doc, 'budget_movements'));
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
  var step = 0;
  for (final row in rows) {
    if (step++ % 50 == 0) await Future<void>.delayed(Duration.zero);
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
  var step = 0;
  for (final row in rows) {
    if (step++ % 50 == 0) await Future<void>.delayed(Duration.zero);
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
  var step = 0;
  for (final row in rows) {
    if (step++ % 50 == 0) await Future<void>.delayed(Duration.zero);
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
  var step = 0;
  for (final row in rows) {
    if (step++ % 50 == 0) await Future<void>.delayed(Duration.zero);
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
          localImagePath: Value(row['local_image_path']?.toString()),
          imagePending: Value(row['local_image_path'] != null),
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
  var step = 0;
  for (final row in rows) {
    if (step++ % 50 == 0) await Future<void>.delayed(Duration.zero);
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
  var step = 0;
  for (final row in rows) {
    if (step++ % 50 == 0) await Future<void>.delayed(Duration.zero);
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

Future<int> _restoreHistories(
  AppDatabase db,
  OutboxWriter outbox,
  List<Map<String, dynamic>> rows,
) async {
  var n = 0;
  var step = 0;
  for (final row in rows) {
    if (step++ % 50 == 0) await Future<void>.delayed(Duration.zero);
    final id = row['id']?.toString();
    if (id == null || id.isEmpty) continue;
    final now = DateTime.now().toUtc();
    final purchased = _date(row['purchased_at']) ?? now;
    final existing = await (db.select(db.purchaseHistories)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    await db.into(db.purchaseHistories).insertOnConflictUpdate(
          PurchaseHistoriesCompanion(
            id: Value(id),
            shoppingListId: Value(row['shopping_list_id']?.toString()),
            storeLocation: Value(row['store_location']?.toString()),
            purchasedAt: Value(purchased),
            total: Value(_num(row['total']) ?? 0),
            clientUpdatedAt: Value(now),
            updatedAt: Value(now),
            createdAt: Value(existing?.createdAt ?? now),
            deletedAt: const Value(null),
          ),
        );
    await outbox.enqueue(
      entity: 'purchase_histories',
      entityId: id,
      op: existing == null ? SyncOp.create : SyncOp.update,
      clientUpdatedAt: now,
      payload: {
        'shopping_list_id': row['shopping_list_id'],
        'store_location': row['store_location'],
        'purchased_at': purchased.toIso8601String(),
        'total': _num(row['total']) ?? 0,
      },
    );
    n++;
  }
  return n;
}

Future<int> _restoreHistoryItems(
  AppDatabase db,
  OutboxWriter outbox,
  List<Map<String, dynamic>> rows,
) async {
  var n = 0;
  var step = 0;
  for (final row in rows) {
    if (step++ % 50 == 0) await Future<void>.delayed(Duration.zero);
    final id = row['id']?.toString();
    final historyId = row['purchase_history_id']?.toString();
    final name = row['name']?.toString();
    if (id == null || historyId == null || name == null || name.isEmpty) {
      continue;
    }
    final now = DateTime.now().toUtc();
    final existing = await (db.select(db.purchaseHistoryItems)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    await db.into(db.purchaseHistoryItems).insertOnConflictUpdate(
          PurchaseHistoryItemsCompanion(
            id: Value(id),
            purchaseHistoryId: Value(historyId),
            productId: Value(row['product_id']?.toString()),
            name: Value(name),
            unitAbbr: Value(row['unit_abbr']?.toString()),
            quantity: Value(_num(row['quantity']) ?? 0),
            unitPrice: Value(_num(row['unit_price']) ?? 0),
            lineTotal: Value(_num(row['line_total']) ?? 0),
            clientUpdatedAt: Value(now),
            updatedAt: Value(now),
            createdAt: Value(existing?.createdAt ?? now),
            deletedAt: const Value(null),
          ),
        );
    await outbox.enqueue(
      entity: 'purchase_history_items',
      entityId: id,
      op: existing == null ? SyncOp.create : SyncOp.update,
      clientUpdatedAt: now,
      payload: {
        'purchase_history_id': historyId,
        'product_id': row['product_id'],
        'name': name,
        'unit_abbr': row['unit_abbr'],
        'quantity': _num(row['quantity']) ?? 0,
        'unit_price': _num(row['unit_price']) ?? 0,
        'line_total': _num(row['line_total']) ?? 0,
      },
    );
    n++;
  }
  return n;
}

Future<int> _restoreBudget(
  AppDatabase db,
  List<Map<String, dynamic>> rows,
) async {
  var n = 0;
  for (final row in rows) {
    final id = row['id']?.toString();
    final label = row['label']?.toString();
    if (id == null || label == null || label.isEmpty) continue;
    final now = DateTime.now().toUtc();
    final existing = await (db.select(db.budgetMovements)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    await db.into(db.budgetMovements).insertOnConflictUpdate(
          BudgetMovementsCompanion(
            id: Value(id),
            label: Value(label),
            amountUsd: Value(_num(row['amount_usd']) ?? 0),
            occurredAt: Value(_date(row['occurred_at']) ?? now),
            createdAt: Value(existing?.createdAt ?? now),
            updatedAt: Value(now),
          ),
        );
    n++;
  }
  return n;
}

DateTime? _date(Object? v) => DateTime.tryParse(v?.toString() ?? '')?.toUtc();

double? _num(Object? v) {
  if (v == null) return null;
  if (v is num) return v.toDouble();
  return double.tryParse(v.toString());
}
