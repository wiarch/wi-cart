import 'package:drift/drift.dart';

mixin SyncColumns on Table {
  TextColumn get id => text()();
  TextColumn get userId => text().named('user_id').nullable()();
  TextColumn get deviceId => text().named('device_id').nullable()();
  DateTimeColumn get clientUpdatedAt =>
      dateTime().named('client_updated_at')();
  DateTimeColumn get updatedAt => dateTime().named('updated_at')();
  DateTimeColumn get createdAt => dateTime().named('created_at')();
  DateTimeColumn get deletedAt => dateTime().named('deleted_at').nullable()();
}

class Categories extends Table with SyncColumns {
  TextColumn get name => text()();
  TextColumn get icon => text().nullable()();
  TextColumn get color => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class Units extends Table with SyncColumns {
  TextColumn get name => text()();
  TextColumn get abbreviation => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class Products extends Table with SyncColumns {
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  TextColumn get categoryId => text().named('category_id').nullable()();
  TextColumn get unitId => text().named('unit_id').nullable()();
  RealColumn get basePrice => real().named('base_price').nullable()();
  TextColumn get imagePath => text().named('image_path').nullable()();
  TextColumn get localImagePath =>
      text().named('local_image_path').nullable()();
  BoolColumn get imagePending =>
      boolean().named('image_pending').withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

class Stores extends Table with SyncColumns {
  TextColumn get name => text()();
  TextColumn get location => text().nullable()();
  TextColumn get icon => text().nullable()();
  TextColumn get notes => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class ShoppingLists extends Table with SyncColumns {
  TextColumn get name => text()();
  TextColumn get status => text().withDefault(const Constant('active'))();
  TextColumn get notes => text().nullable()();
  TextColumn get icon => text().nullable()();
  TextColumn get storeId => text().named('store_id').nullable()();
  TextColumn get storeLocation =>
      text().named('store_location').nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class ListItems extends Table with SyncColumns {
  TextColumn get shoppingListId => text().named('shopping_list_id')();
  TextColumn get productId => text().named('product_id').nullable()();
  TextColumn get unitId => text().named('unit_id').nullable()();
  TextColumn get unitAbbr => text().named('unit_abbr').nullable()();
  TextColumn get name => text()();
  RealColumn get qtyPlanned =>
      real().named('qty_planned').withDefault(const Constant(1.0))();
  RealColumn get qtyBought => real().named('qty_bought').nullable()();
  RealColumn get unitPrice => real().named('unit_price').nullable()();
  TextColumn get status => text().withDefault(const Constant('pending'))();
  TextColumn get notes => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class PurchaseHistories extends Table with SyncColumns {
  TextColumn get shoppingListId =>
      text().named('shopping_list_id').nullable()();
  TextColumn get storeLocation =>
      text().named('store_location').nullable()();
  DateTimeColumn get purchasedAt => dateTime().named('purchased_at')();
  RealColumn get total => real().withDefault(const Constant(0.0))();

  @override
  Set<Column> get primaryKey => {id};
}

class PurchaseHistoryItems extends Table with SyncColumns {
  TextColumn get purchaseHistoryId => text().named('purchase_history_id')();
  TextColumn get productId => text().named('product_id').nullable()();
  TextColumn get name => text()();
  TextColumn get unitAbbr => text().named('unit_abbr').nullable()();
  RealColumn get quantity => real().withDefault(const Constant(1.0))();
  RealColumn get unitPrice => real().named('unit_price').nullable()();
  RealColumn get lineTotal => real().named('line_total').nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Local outbox / sync_queue — pending mutations until push succeeds.
class SyncOutbox extends Table {
  @override
  String get tableName => 'sync_queue';

  TextColumn get id => text()();
  TextColumn get entity => text()();
  TextColumn get entityId => text().named('entity_id')();
  /// Wire ops: create | update | delete (server also accepts upsert).
  TextColumn get op => text()();
  TextColumn get payloadJson => text().named('payload_json')();
  DateTimeColumn get clientUpdatedAt =>
      dateTime().named('client_updated_at')();
  DateTimeColumn get createdAt => dateTime().named('created_at')();
  IntColumn get attempts => integer().withDefault(const Constant(0))();
  TextColumn get lastError => text().named('last_error').nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class SyncMeta extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column> get primaryKey => {key};
}
