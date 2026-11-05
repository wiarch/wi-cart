import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'tables.dart';

part 'database.g.dart';

@DriftDatabase(tables: [
  Categories,
  Units,
  Products,
  Stores,
  ShoppingLists,
  ListItems,
  PurchaseHistories,
  PurchaseHistoryItems,
  SyncOutbox,
  SyncMeta,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_open());

  AppDatabase.forTesting(super.e);

  @override
  int get schemaVersion => 7;

  /// Idempotent repair on every open: creates `stores` and the list columns
  /// added in v4/v5 if a previous upgrade did not apply them.
  Future<void> _ensureStoreSchema() async {
    final m = createMigrator();
    final tables = await customSelect(
      "SELECT name FROM sqlite_master WHERE type='table' AND name='stores'",
    ).get();
    if (tables.isEmpty) await m.createTable(stores);

    final cols = await customSelect('PRAGMA table_info(shopping_lists)').get();
    final names = cols.map((r) => r.read<String>('name')).toSet();
    if (!names.contains('icon')) {
      await m.addColumn(shoppingLists, shoppingLists.icon);
    }
    if (!names.contains('store_id')) {
      await m.addColumn(shoppingLists, shoppingLists.storeId);
    }

    final storeCols = await customSelect('PRAGMA table_info(stores)').get();
    final storeNames = storeCols.map((r) => r.read<String>('name')).toSet();
    if (!storeNames.contains('location')) {
      await m.addColumn(stores, stores.location);
    }
  }

  @override
  MigrationStrategy get migration => MigrationStrategy(
        beforeOpen: (details) => _ensureStoreSchema(),
        onCreate: (m) => m.createAll(),
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.addColumn(categories, categories.icon);
            await m.addColumn(categories, categories.color);
            await m.addColumn(shoppingLists, shoppingLists.storeLocation);
            await m.addColumn(listItems, listItems.unitId);
            await m.addColumn(listItems, listItems.unitAbbr);
            await m.addColumn(purchaseHistories, purchaseHistories.storeLocation);
            await m.addColumn(purchaseHistoryItems, purchaseHistoryItems.unitAbbr);
          }
          if (from < 4) {
            await m.addColumn(shoppingLists, shoppingLists.icon);
          }
          if (from < 5) {
            await m.createTable(stores);
            await m.addColumn(shoppingLists, shoppingLists.storeId);
          }
          if (from < 6) {
            await m.addColumn(stores, stores.location);
          }
          if (from < 7) {
            await m.addColumn(listItems, listItems.notes);
          }
          if (from < 3) {
            // Rename legacy outbox → sync_queue (idempotent).
            await customStatement('''
              CREATE TABLE IF NOT EXISTS sync_queue (
                id TEXT NOT NULL PRIMARY KEY,
                entity TEXT NOT NULL,
                entity_id TEXT NOT NULL,
                op TEXT NOT NULL,
                payload_json TEXT NOT NULL,
                client_updated_at INTEGER NOT NULL,
                created_at INTEGER NOT NULL,
                attempts INTEGER NOT NULL DEFAULT 0,
                last_error TEXT
              )
            ''');
            final legacy = await customSelect(
              "SELECT name FROM sqlite_master WHERE type='table' AND name='sync_outbox'",
            ).get();
            if (legacy.isNotEmpty) {
              await customStatement('''
                INSERT OR IGNORE INTO sync_queue
                SELECT id, entity, entity_id, op, payload_json,
                       client_updated_at, created_at, attempts, last_error
                FROM sync_outbox
              ''');
              await customStatement('DROP TABLE IF EXISTS sync_outbox');
            }
          }
        },
      );

  Future<void> wipeAllUserData() async {
    await transaction(() async {
      await delete(syncOutbox).go();
      await delete(syncMeta).go();
      await delete(purchaseHistoryItems).go();
      await delete(purchaseHistories).go();
      await delete(listItems).go();
      await delete(shoppingLists).go();
      await delete(stores).go();
      await delete(products).go();
      await delete(units).go();
      await delete(categories).go();
    });
  }
}

QueryExecutor _open() {
  // Keep filenames in sync with web/ assets (version bump busts CF cache).
  const assetVer = String.fromEnvironment('WEB_ASSET_VER', defaultValue: 'd6d7ee1');
  return driftDatabase(
    name: 'wicart',
    web: DriftWebOptions(
      sqlite3Wasm: Uri.parse('sqlite3.$assetVer.wasm'),
      driftWorker: Uri.parse('drift_worker.$assetVer.js'),
    ),
  );
}
