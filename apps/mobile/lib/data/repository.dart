import 'package:drift/drift.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../utils/quantity_math.dart';
import 'database.dart';
import 'outbox.dart';

class CartRepository {
  CartRepository(this.db, this.outbox);

  final AppDatabase db;
  final OutboxWriter outbox;
  final _uuid = const Uuid();

  DateTime get _now => DateTime.now().toUtc();

  static const defaultUnits = [
    ('Unidad', 'un'),
    ('Kilogramo', 'kg'),
    ('Gramo', 'g'),
    ('Litros', 'lts'),
    ('Mililitros', 'ml'),
    ('Paquete', 'paquete'),
    ('Libra', 'lb'),
  ];

  static const defaultCategories = [
    ('Huevos, fruta y verdura', 'eco', '#2E7D32'),
    ('Comestibles', 'grocery', '#F9A825'),
    ('Lácteos', 'dairy', '#1565C0'),
    ('Limpieza', 'clean', '#6A1B9A'),
  ];

  // --- Categories ---

  Stream<List<Category>> watchCategories() {
    return (db.select(db.categories)
          ..where((t) => t.deletedAt.isNull())
          ..orderBy([(t) => OrderingTerm.asc(t.name)]))
        .watch();
  }

  Future<List<Category>> getCategories() {
    return (db.select(db.categories)
          ..where((t) => t.deletedAt.isNull())
          ..orderBy([(t) => OrderingTerm.asc(t.name)]))
        .get();
  }

  Future<Category> upsertCategory({
    String? id,
    required String name,
    String? icon,
    String? color,
  }) async {
    final now = _now;
    final isCreate = id == null;
    final catId = id ?? _uuid.v4();
    await db.into(db.categories).insertOnConflictUpdate(CategoriesCompanion(
          id: Value(catId),
          name: Value(name),
          icon: Value(icon),
          color: Value(color),
          clientUpdatedAt: Value(now),
          updatedAt: Value(now),
          createdAt: Value(now),
          deletedAt: const Value(null),
        ));
    await outbox.enqueue(
      entity: 'categories',
      entityId: catId,
      op: isCreate ? SyncOp.create : SyncOp.update,
      clientUpdatedAt: now,
      payload: {'name': name, 'icon': icon, 'color': color},
    );
    return (await (db.select(db.categories)..where((t) => t.id.equals(catId)))
        .getSingle());
  }

  Future<void> deleteCategory(String id) async {
    final now = _now;
    await (db.update(db.categories)..where((t) => t.id.equals(id))).write(
      CategoriesCompanion(
        deletedAt: Value(now),
        clientUpdatedAt: Value(now),
        updatedAt: Value(now),
      ),
    );
    await outbox.enqueue(
      entity: 'categories',
      entityId: id,
      op: SyncOp.delete,
      clientUpdatedAt: now,
    );
  }

  // --- Units ---

  Stream<List<Unit>> watchUnits() {
    return (db.select(db.units)
          ..where((t) => t.deletedAt.isNull())
          ..orderBy([(t) => OrderingTerm.asc(t.name)]))
        .watch();
  }

  Future<List<Unit>> getUnits() {
    return (db.select(db.units)..where((t) => t.deletedAt.isNull())).get();
  }

  // --- Products ---

  Stream<List<Product>> watchProducts() {
    return (db.select(db.products)
          ..where((t) => t.deletedAt.isNull())
          ..orderBy([(t) => OrderingTerm.asc(t.name)]))
        .watch();
  }

  Future<Product?> getProduct(String id) {
    return (db.select(db.products)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
  }

  Future<List<Product>> getProducts() {
    return (db.select(db.products)
          ..where((t) => t.deletedAt.isNull())
          ..orderBy([(t) => OrderingTerm.asc(t.name)]))
        .get();
  }

  /// Offline predictive search: contains / prefix / fuzzy.
  Future<List<Product>> searchProducts(String query, {int limit = 12}) async {
    final q = _normalize(query);
    if (q.isEmpty) return [];
    final all = await getProducts();
    final scored = <({Product p, int score})>[];
    for (final p in all) {
      final score = _nameScore(_normalize(p.name), q);
      if (score > 0) scored.add((p: p, score: score));
    }
    scored.sort((a, b) => b.score.compareTo(a.score));
    return scored.take(limit).map((e) => e.p).toList();
  }

  Future<Product?> findProductByName(String name) async {
    final n = _normalize(name);
    if (n.isEmpty) return null;
    final all = await getProducts();
    for (final p in all) {
      if (_normalize(p.name) == n) return p;
    }
    return null;
  }

  static String _normalize(String s) =>
      s.trim().toLowerCase().replaceAll(RegExp(r'\s+'), ' ');

  static int _nameScore(String name, String q) {
    if (name == q) return 1000;
    if (name.startsWith(q)) return 800 - (name.length - q.length).clamp(0, 100);
    if (name.contains(q)) return 500 - name.indexOf(q);
    // token overlap
    final nTokens = name.split(' ');
    final qTokens = q.split(' ');
    var hits = 0;
    for (final qt in qTokens) {
      if (qt.length < 2) continue;
      if (nTokens.any((t) => t.startsWith(qt) || t.contains(qt))) hits++;
    }
    if (hits > 0) return 200 + hits * 50;
    // simple edit distance for short queries
    if (q.length >= 3 && name.length <= 24) {
      final d = _levenshtein(name, q);
      if (d <= 2) return 150 - d * 20;
    }
    return 0;
  }

  static int _levenshtein(String s, String t) {
    final m = s.length;
    final n = t.length;
    if (m == 0) return n;
    if (n == 0) return m;
    var v0 = List<int>.generate(n + 1, (i) => i);
    var v1 = List<int>.filled(n + 1, 0);
    for (var i = 0; i < m; i++) {
      v1[0] = i + 1;
      for (var j = 0; j < n; j++) {
        final cost = s[i] == t[j] ? 0 : 1;
        final del = v0[j + 1] + 1;
        final ins = v1[j] + 1;
        final sub = v0[j] + cost;
        v1[j + 1] = del < ins
            ? (del < sub ? del : sub)
            : (ins < sub ? ins : sub);
      }
      final tmp = v0;
      v0 = v1;
      v1 = tmp;
    }
    return v0[n];
  }

  static const lastListKey = 'last_active_list_id';

  Future<void> rememberLastList(String? listId) async {
    final prefs = await SharedPreferences.getInstance();
    if (listId == null) {
      await prefs.remove(lastListKey);
    } else {
      await prefs.setString(lastListKey, listId);
    }
  }

  Future<String?> getLastListId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(lastListKey);
  }

  Future<ShoppingList?> getLastActiveList() async {
    final id = await getLastListId();
    if (id == null) return null;
    final list = await getList(id);
    if (list == null || list.deletedAt != null || list.status != 'active') {
      await rememberLastList(null);
      return null;
    }
    return list;
  }

  Future<Product> upsertProduct({
    String? id,
    required String name,
    String? description,
    String? categoryId,
    String? unitId,
    double? basePrice,
    String? localImagePath,
    bool imagePending = false,
  }) async {
    final now = _now;
    final isCreate = id == null;
    final productId = id ?? _uuid.v4();
    final existing = id == null
        ? null
        : await (db.select(db.products)..where((t) => t.id.equals(productId)))
            .getSingleOrNull();
    final companion = ProductsCompanion(
      id: Value(productId),
      name: Value(name),
      description: Value(description),
      categoryId: Value(categoryId),
      unitId: Value(unitId),
      basePrice: Value(basePrice),
      localImagePath: Value(localImagePath ?? existing?.localImagePath),
      imagePath: Value(existing?.imagePath),
      imagePending: Value(imagePending),
      clientUpdatedAt: Value(now),
      updatedAt: Value(now),
      createdAt: Value(existing?.createdAt ?? now),
      deletedAt: const Value(null),
    );
    await db.into(db.products).insertOnConflictUpdate(companion);
    await outbox.enqueue(
      entity: 'products',
      entityId: productId,
      op: isCreate ? SyncOp.create : SyncOp.update,
      clientUpdatedAt: now,
      payload: {
        'name': name,
        'description': description,
        'category_id': categoryId,
        'unit_id': unitId,
        'base_price': basePrice,
        'image_pending': imagePending,
        if (existing?.imagePath != null) 'image_path': existing!.imagePath,
      },
    );
    return (await (db.select(db.products)..where((t) => t.id.equals(productId)))
        .getSingle());
  }

  Future<void> deleteProduct(String id) async {
    final now = _now;
    await (db.update(db.products)..where((t) => t.id.equals(id))).write(
      ProductsCompanion(
        deletedAt: Value(now),
        clientUpdatedAt: Value(now),
        updatedAt: Value(now),
      ),
    );
    await outbox.enqueue(
      entity: 'products',
      entityId: id,
      op: SyncOp.delete,
      clientUpdatedAt: now,
    );
  }

  // --- Lists ---

  Stream<List<ShoppingList>> watchActiveLists() {
    return (db.select(db.shoppingLists)
          ..where((t) => t.deletedAt.isNull() & t.status.equals('active'))
          ..orderBy([(t) => OrderingTerm.desc(t.updatedAt)]))
        .watch();
  }

  Future<ShoppingList?> getList(String id) {
    return (db.select(db.shoppingLists)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
  }

  // --- Stores ---

  Stream<List<Store>> watchStores() {
    return (db.select(db.stores)
          ..where((t) => t.deletedAt.isNull())
          ..orderBy([(t) => OrderingTerm.asc(t.name)]))
        .watch();
  }

  Future<Store> createStore({
    required String name,
    String? location,
    String? icon,
    String? notes,
  }) async {
    final now = _now;
    final id = _uuid.v4();
    final cleanNotes = notes?.trim();
    final cleanLocation = location?.trim();
    final loc = cleanLocation == null || cleanLocation.isEmpty ? null : cleanLocation;
    await db.into(db.stores).insert(StoresCompanion.insert(
          id: id,
          name: name.trim(),
          location: Value(loc),
          icon: Value(icon),
          notes: Value(cleanNotes == null || cleanNotes.isEmpty ? null : cleanNotes),
          clientUpdatedAt: now,
          updatedAt: now,
          createdAt: now,
        ));
    await outbox.enqueue(
      entity: 'stores',
      entityId: id,
      op: SyncOp.create,
      clientUpdatedAt: now,
      payload: {
        'name': name.trim(),
        'location': loc,
        'icon': icon,
        'notes': cleanNotes,
      },
    );
    return (await (db.select(db.stores)..where((t) => t.id.equals(id)))
        .getSingle());
  }

  /// Soft-deletes the store and every list that belongs to it.
  /// Products stay in the inventory.
  Future<void> deleteStore(String id) async {
    final lists = await (db.select(db.shoppingLists)
          ..where((t) => t.storeId.equals(id) & t.deletedAt.isNull()))
        .get();
    for (final list in lists) {
      await deleteList(list.id);
    }
    final now = _now;
    await (db.update(db.stores)..where((t) => t.id.equals(id))).write(
      StoresCompanion(
        deletedAt: Value(now),
        clientUpdatedAt: Value(now),
        updatedAt: Value(now),
      ),
    );
    await outbox.enqueue(
      entity: 'stores',
      entityId: id,
      op: SyncOp.delete,
      clientUpdatedAt: now,
    );
  }

  Future<void> renameStore(String id, String name) async {
    final now = _now;
    await (db.update(db.stores)..where((t) => t.id.equals(id))).write(
      StoresCompanion(
        name: Value(name.trim()),
        clientUpdatedAt: Value(now),
        updatedAt: Value(now),
      ),
    );
    final s = await (db.select(db.stores)..where((t) => t.id.equals(id)))
        .getSingle();
    await outbox.enqueue(
      entity: 'stores',
      entityId: id,
      op: SyncOp.update,
      clientUpdatedAt: now,
      payload: {
        'name': s.name,
        'location': s.location,
        'icon': s.icon,
        'notes': s.notes,
      },
    );
  }

  Future<ShoppingList> createList(
    String name, {
    String? icon,
    String? storeId,
  }) async {
    final now = _now;
    final id = _uuid.v4();
    await db.into(db.shoppingLists).insert(ShoppingListsCompanion.insert(
          id: id,
          name: name,
          status: const Value('active'),
          icon: Value(icon),
          storeId: Value(storeId),
          clientUpdatedAt: now,
          updatedAt: now,
          createdAt: now,
        ));
    await outbox.enqueue(
      entity: 'shopping_lists',
      entityId: id,
      op: SyncOp.create,
      clientUpdatedAt: now,
      payload: {
        'name': name,
        'status': 'active',
        'icon': icon,
        'store_id': storeId,
      },
    );
    return (await (db.select(db.shoppingLists)..where((t) => t.id.equals(id)))
        .getSingle());
  }

  /// Soft-deletes the list and its items. Products are not deleted.
  Future<void> deleteList(String id) async {
    final items = await getItems(id);
    for (final item in items) {
      await deleteItem(item.id);
    }
    final now = _now;
    await (db.update(db.shoppingLists)..where((t) => t.id.equals(id))).write(
      ShoppingListsCompanion(
        deletedAt: Value(now),
        clientUpdatedAt: Value(now),
        updatedAt: Value(now),
      ),
    );
    await outbox.enqueue(
      entity: 'shopping_lists',
      entityId: id,
      op: SyncOp.delete,
      clientUpdatedAt: now,
    );
  }

  Future<void> renameList(String id, String name) async {
    final now = _now;
    final list = await getList(id);
    if (list == null) return;
    final trimmed = name.trim();
    if (trimmed.isEmpty) return;
    await (db.update(db.shoppingLists)..where((t) => t.id.equals(id))).write(
      ShoppingListsCompanion(
        name: Value(trimmed),
        clientUpdatedAt: Value(now),
        updatedAt: Value(now),
      ),
    );
    await outbox.enqueue(
      entity: 'shopping_lists',
      entityId: id,
      op: SyncOp.update,
      clientUpdatedAt: now,
      payload: {
        'name': trimmed,
        'status': list.status,
        'notes': list.notes,
        'icon': list.icon,
        'store_id': list.storeId,
        'store_location': list.storeLocation,
      },
    );
  }

  Future<void> setListIcon(String listId, String? icon) async {
    final now = _now;
    final list = await getList(listId);
    if (list == null) return;
    await (db.update(db.shoppingLists)..where((t) => t.id.equals(listId))).write(
      ShoppingListsCompanion(
        icon: Value(icon),
        clientUpdatedAt: Value(now),
        updatedAt: Value(now),
      ),
    );
    await outbox.enqueue(
      entity: 'shopping_lists',
      entityId: listId,
      op: SyncOp.update,
      clientUpdatedAt: now,
      payload: {
        'name': list.name,
        'status': list.status,
        'notes': list.notes,
        'icon': icon,
      },
    );
  }

  Stream<List<BudgetMovement>> watchBudgetMovements() {
    return (db.select(db.budgetMovements)
          ..orderBy([(t) => OrderingTerm.desc(t.occurredAt)]))
        .watch();
  }

  Future<void> addBudgetMovement({
    required String label,
    required double amountUsd,
  }) async {
    final now = _now;
    await db.into(db.budgetMovements).insert(BudgetMovementsCompanion.insert(
          id: _uuid.v4(),
          label: label.trim(),
          amountUsd: amountUsd,
          occurredAt: now,
          createdAt: now,
          updatedAt: now,
        ));
  }

  Future<void> updateBudgetMovement(
    String id, {
    required String label,
    required double amountUsd,
  }) async {
    await (db.update(db.budgetMovements)..where((t) => t.id.equals(id))).write(
      BudgetMovementsCompanion(
        label: Value(label.trim()),
        amountUsd: Value(amountUsd),
        updatedAt: Value(_now),
      ),
    );
  }

  Future<void> deleteBudgetMovement(String id) {
    return (db.delete(db.budgetMovements)..where((t) => t.id.equals(id))).go();
  }

  /// All non-deleted list items across lists (for summaries/charts).
  Stream<List<ListItem>> watchAllItems() {
    return (db.select(db.listItems)..where((t) => t.deletedAt.isNull())).watch();
  }

  Stream<List<ListItem>> watchItems(String listId) {
    return (db.select(db.listItems)
          ..where(
              (t) => t.shoppingListId.equals(listId) & t.deletedAt.isNull())
          ..orderBy([(t) => OrderingTerm.asc(t.name)]))
        .watch();
  }

  Future<ListItem> addItem({
    required String listId,
    required String name,
    String? productId,
    String? unitId,
    String? unitAbbr,
    double qtyPlanned = 1,
    double? unitPrice,
    String? notes,
  }) async {
    final now = _now;
    final id = _uuid.v4();
    String? resolvedUnitId = unitId;
    String? resolvedAbbr = unitAbbr;
    String? resolvedProductId = productId;

    if (productId != null) {
      final product = await getProduct(productId);
      resolvedUnitId ??= product?.unitId;
      if (resolvedAbbr == null && product?.unitId != null) {
        final unit = await (db.select(db.units)
              ..where((t) => t.id.equals(product!.unitId!)))
            .getSingleOrNull();
        resolvedAbbr = unit?.abbreviation;
      }
      unitPrice ??= product?.basePrice;
    }

    await db.into(db.listItems).insert(ListItemsCompanion.insert(
          id: id,
          shoppingListId: listId,
          name: name,
          productId: Value(resolvedProductId),
          unitId: Value(resolvedUnitId),
          unitAbbr: Value(resolvedAbbr),
          qtyPlanned: Value(qtyPlanned),
          unitPrice: Value(unitPrice),
          status: const Value('pending'),
          notes: Value(notes),
          clientUpdatedAt: now,
          updatedAt: now,
          createdAt: now,
        ));
    await outbox.enqueue(
      entity: 'list_items',
      entityId: id,
      op: SyncOp.update,
      clientUpdatedAt: now,
      payload: {
        'shopping_list_id': listId,
        'product_id': resolvedProductId,
        'unit_id': resolvedUnitId,
        'unit_abbr': resolvedAbbr,
        'name': name,
        'qty_planned': qtyPlanned,
        'unit_price': unitPrice,
        'status': 'pending',
        'notes': notes,
      },
    );
    return (await (db.select(db.listItems)..where((t) => t.id.equals(id)))
        .getSingle());
  }

  /// Add to list; if no productId and name unknown → create global product.
  Future<ListItem> addItemSmart({
    required String listId,
    required String name,
    String? productId,
    String? unitId,
    String? unitAbbr,
    String? categoryId,
    double qtyPlanned = 1,
    double? unitPrice,
    String? description,
    String? localImagePath,
    bool addToCart = false,
  }) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) throw StateError('Nombre vacío');

    Product? product =
        productId != null ? await getProduct(productId) : null;
    product ??= await findProductByName(trimmed);
    if (product == null) {
      product = await upsertProduct(
        name: trimmed,
        description: description,
        categoryId: categoryId,
        unitId: unitId,
        basePrice: unitPrice,
        localImagePath: localImagePath,
        imagePending: localImagePath != null,
      );
    } else if (description != null ||
        localImagePath != null ||
        categoryId != null) {
      product = await upsertProduct(
        id: product.id,
        name: product.name,
        description: description ?? product.description,
        categoryId: categoryId ?? product.categoryId,
        unitId: product.unitId,
        basePrice: product.basePrice,
        localImagePath: localImagePath,
        imagePending: localImagePath != null || product.imagePending,
      );
    }

    final item = await addItem(
      listId: listId,
      name: product.name,
      productId: product.id,
      unitId: unitId ?? product.unitId,
      unitAbbr: unitAbbr,
      qtyPlanned: qtyPlanned,
      unitPrice: unitPrice ?? product.basePrice,
    );
    if (addToCart) await setItemStatus(item, 'in_cart');
    return item;
  }

  Future<List<ListItem>> getItems(String listId) {
    return (db.select(db.listItems)
          ..where(
              (t) => t.shoppingListId.equals(listId) & t.deletedAt.isNull())
          ..orderBy([(t) => OrderingTerm.asc(t.name)]))
        .get();
  }

  Future<Store> cloneStore(String id) async {
    final source = await (db.select(db.stores)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    if (source == null || source.deletedAt != null) {
      throw StateError('Tienda no encontrada');
    }
    final clone = await createStore(
      name: '${source.name} (copia)',
      location: source.location,
      icon: source.icon,
      notes: source.notes,
    );
    final lists = await (db.select(db.shoppingLists)
          ..where((t) => t.storeId.equals(id) & t.deletedAt.isNull()))
        .get();
    for (final list in lists) {
      await cloneList(
        list.id,
        newName: list.name,
        storeId: clone.id,
        remember: false,
      );
    }
    return clone;
  }

  Future<ShoppingList> cloneList(
    String listId, {
    String? newName,
    String? storeId,
    bool remember = true,
  }) async {
    final source = await getList(listId);
    if (source == null) throw StateError('Lista no encontrada');
    final items = await getItems(listId);
    final clone = await createList(
      newName?.trim().isNotEmpty == true
          ? newName!.trim()
          : '${source.name} (copia)',
      icon: source.icon,
      storeId: storeId ?? source.storeId,
    );
    for (final i in items) {
      await addItem(
        listId: clone.id,
        name: i.name,
        productId: i.productId,
        unitId: i.unitId,
        unitAbbr: i.unitAbbr,
        qtyPlanned: i.qtyPlanned,
        unitPrice: i.unitPrice,
      );
    }
    if (remember) await rememberLastList(clone.id);
    return clone;
  }

  Future<void> clearCart(String listId) async {
    final items = await (db.select(db.listItems)
          ..where((t) =>
              t.shoppingListId.equals(listId) &
              t.deletedAt.isNull() &
              t.status.equals('in_cart')))
        .get();
    for (final item in items) {
      await setItemStatus(item, 'pending');
    }
  }

  Future<void> setItemStatus(ListItem item, String status) async {
    final now = _now;
    final qtyBought = status == 'in_cart'
        ? (item.qtyBought ?? item.qtyPlanned)
        : item.qtyBought;
    await (db.update(db.listItems)..where((t) => t.id.equals(item.id))).write(
      ListItemsCompanion(
        status: Value(status),
        qtyBought: Value(qtyBought),
        clientUpdatedAt: Value(now),
        updatedAt: Value(now),
      ),
    );
    await outbox.enqueue(
      entity: 'list_items',
      entityId: item.id,
      op: SyncOp.update,
      clientUpdatedAt: now,
      payload: {
        'shopping_list_id': item.shoppingListId,
        'product_id': item.productId,
        'unit_id': item.unitId,
        'unit_abbr': item.unitAbbr,
        'name': item.name,
        'qty_planned': item.qtyPlanned,
        'qty_bought': qtyBought,
        'unit_price': item.unitPrice,
        'status': status,
      },
    );
  }

  Future<void> updateItemQty({
    required ListItem item,
    double? qtyPlanned,
    double? qtyBought,
    double? unitPrice,
    String? unitId,
    String? unitAbbr,
  }) async {
    final now = _now;
    final planned = qtyPlanned ?? item.qtyPlanned;
    final bought = qtyBought ?? item.qtyBought;
    final price = unitPrice ?? item.unitPrice;
    final uid = unitId ?? item.unitId;
    final abbr = unitAbbr ?? item.unitAbbr;
    await (db.update(db.listItems)..where((t) => t.id.equals(item.id))).write(
      ListItemsCompanion(
        qtyPlanned: Value(planned),
        qtyBought: Value(bought),
        unitPrice: Value(price),
        unitId: Value(uid),
        unitAbbr: Value(abbr),
        clientUpdatedAt: Value(now),
        updatedAt: Value(now),
      ),
    );
    await outbox.enqueue(
      entity: 'list_items',
      entityId: item.id,
      op: SyncOp.update,
      clientUpdatedAt: now,
      payload: {
        'shopping_list_id': item.shoppingListId,
        'product_id': item.productId,
        'unit_id': uid,
        'unit_abbr': abbr,
        'name': item.name,
        'qty_planned': planned,
        'qty_bought': bought,
        'unit_price': price,
        'status': item.status,
      },
    );
  }

  /// Writes list-line fields and the linked catalog product.
  Future<void> updateListItem({
    required ListItem item,
    required String name,
    String? productId,
    String? unitId,
    String? unitAbbr,
    String? categoryId,
    double qty = 1,
    double? unitPrice,
    String? description,
    String? localImagePath,
    bool addToCart = false,
  }) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return;
    Product? product =
        productId != null ? await getProduct(productId) : null;
    product ??= await findProductByName(trimmed);
    final imageChanged =
        localImagePath != null && localImagePath != product?.localImagePath;
    if (product == null) {
      product = await upsertProduct(
        name: trimmed,
        description: description,
        categoryId: categoryId,
        unitId: unitId,
        basePrice: unitPrice,
        localImagePath: localImagePath,
        imagePending: localImagePath != null,
      );
    } else {
      product = await upsertProduct(
        id: product.id,
        name: trimmed,
        description: description,
        categoryId: categoryId,
        unitId: unitId ?? product.unitId,
        basePrice: unitPrice ?? product.basePrice,
        localImagePath: localImagePath,
        imagePending: imageChanged || product.imagePending,
      );
    }
    final now = _now;
    final status = addToCart ? 'in_cart' : 'pending';
    final planned = qty == 0 ? 1.0 : qty;
    final bought = status == 'in_cart' ? planned : item.qtyBought;
    final uid = unitId ?? product.unitId;
    final price = unitPrice ?? product.basePrice;
    await (db.update(db.listItems)..where((t) => t.id.equals(item.id))).write(
      ListItemsCompanion(
        name: Value(trimmed),
        productId: Value(product.id),
        unitId: Value(uid),
        unitAbbr: Value(unitAbbr),
        qtyPlanned: Value(planned),
        qtyBought: Value(bought),
        unitPrice: Value(price),
        status: Value(status),
        notes: Value(description),
        clientUpdatedAt: Value(now),
        updatedAt: Value(now),
      ),
    );
    await outbox.enqueue(
      entity: 'list_items',
      entityId: item.id,
      op: SyncOp.update,
      clientUpdatedAt: now,
      payload: {
        'shopping_list_id': item.shoppingListId,
        'product_id': product.id,
        'unit_id': uid,
        'unit_abbr': unitAbbr,
        'name': trimmed,
        'qty_planned': planned,
        'qty_bought': bought,
        'unit_price': price,
        'status': status,
        'notes': description,
      },
    );
  }

  Future<void> deleteItem(String id) async {
    final now = _now;
    await (db.update(db.listItems)..where((t) => t.id.equals(id))).write(
      ListItemsCompanion(
        deletedAt: Value(now),
        clientUpdatedAt: Value(now),
        updatedAt: Value(now),
      ),
    );
    await outbox.enqueue(
      entity: 'list_items',
      entityId: id,
      op: SyncOp.delete,
      clientUpdatedAt: now,
    );
  }

  /// Finalize purchase: list → completed + history snapshot.
  Future<PurchaseHistory> finalizePurchase(String listId) async {
    final now = _now;
    final list = await getList(listId);
    if (list == null) {
      throw StateError('Lista no encontrada');
    }

    final items = await (db.select(db.listItems)
          ..where((t) =>
              t.shoppingListId.equals(listId) &
              t.deletedAt.isNull() &
              t.status.equals('in_cart')))
        .get();

    if (items.isEmpty) {
      throw StateError('Carrito vacío');
    }

    double total = 0;
    for (final i in items) {
      final qty = i.qtyBought ?? i.qtyPlanned;
      total += lineTotal(
          qty: qty, unitAbbr: i.unitAbbr, unitPrice: i.unitPrice ?? 0);
    }

    final historyId = _uuid.v4();

    await db.transaction(() async {
      await (db.update(db.shoppingLists)..where((t) => t.id.equals(listId)))
          .write(ShoppingListsCompanion(
        status: const Value('completed'),
        clientUpdatedAt: Value(now),
        updatedAt: Value(now),
      ));
      await outbox.enqueue(
        entity: 'shopping_lists',
        entityId: listId,
        op: SyncOp.update,
        clientUpdatedAt: now,
        payload: {
          'name': list.name,
          'status': 'completed',
          'notes': list.notes,
        },
      );

      await db.into(db.purchaseHistories).insert(
            PurchaseHistoriesCompanion.insert(
              id: historyId,
              shoppingListId: Value(listId),
              purchasedAt: now,
              total: Value(total),
              clientUpdatedAt: now,
              updatedAt: now,
              createdAt: now,
            ),
          );
      await outbox.enqueue(
        entity: 'purchase_histories',
        entityId: historyId,
        op: SyncOp.update,
        clientUpdatedAt: now,
        payload: {
          'shopping_list_id': listId,
          'purchased_at': now.toIso8601String(),
          'total': total,
        },
      );

      for (final i in items) {
        final lineId = _uuid.v4();
        final qty = i.qtyBought ?? i.qtyPlanned;
        final itemTotal = lineTotal(
            qty: qty, unitAbbr: i.unitAbbr, unitPrice: i.unitPrice ?? 0);
        await db.into(db.purchaseHistoryItems).insert(
              PurchaseHistoryItemsCompanion.insert(
                id: lineId,
                purchaseHistoryId: historyId,
                productId: Value(i.productId),
                name: i.name,
                unitAbbr: Value(i.unitAbbr),
                quantity: Value(qty),
                unitPrice: Value(i.unitPrice),
                lineTotal: Value(itemTotal),
                clientUpdatedAt: now,
                updatedAt: now,
                createdAt: now,
              ),
            );
        await outbox.enqueue(
          entity: 'purchase_history_items',
          entityId: lineId,
          op: SyncOp.update,
          clientUpdatedAt: now,
          payload: {
            'purchase_history_id': historyId,
            'product_id': i.productId,
            'name': i.name,
            'unit_abbr': i.unitAbbr,
            'quantity': qty,
            'unit_price': i.unitPrice,
            'line_total': itemTotal,
          },
        );
      }
    });

    return (await (db.select(db.purchaseHistories)
          ..where((t) => t.id.equals(historyId)))
        .getSingle());
  }

  /// One history row for every in-cart item of the active lists.
  /// [storeId] limits it to that store. [includeExtras] adds this month's
  /// manual budget movements. Lists stay active.
  Future<PurchaseHistory> saveCartHistory({
    String? storeId,
    String? storeLocation,
    bool includeExtras = false,
  }) async {
    final lists = await (db.select(db.shoppingLists)
          ..where((t) => t.deletedAt.isNull() & t.status.equals('active')))
        .get();
    final listIds = lists
        .where((l) => storeId == null || l.storeId == storeId)
        .map((l) => l.id)
        .toSet();
    final cart = listIds.isEmpty
        ? <ListItem>[]
        : await (db.select(db.listItems)
              ..where((t) =>
                  t.deletedAt.isNull() &
                  t.status.equals('in_cart') &
                  t.shoppingListId.isIn(listIds)))
            .get();

    final extras = <BudgetMovement>[];
    if (includeExtras) {
      final now = DateTime.now();
      final start = DateTime(now.year, now.month);
      final end = DateTime(now.year, now.month + 1);
      final moves = await db.select(db.budgetMovements).get();
      extras.addAll(moves.where((m) {
        final d = m.occurredAt.toLocal();
        return !d.isBefore(start) && d.isBefore(end);
      }));
    }
    if (cart.isEmpty && extras.isEmpty) {
      throw StateError('Carrito vacío');
    }

    final now = _now;
    final historyId = _uuid.v4();
    var total = 0.0;
    for (final i in cart) {
      final qty = i.qtyBought ?? i.qtyPlanned;
      total += lineTotal(
          qty: qty, unitAbbr: i.unitAbbr, unitPrice: i.unitPrice ?? 0);
    }
    for (final m in extras) {
      total += m.amountUsd;
    }

    await db.transaction(() async {
      await db.into(db.purchaseHistories).insert(
            PurchaseHistoriesCompanion.insert(
              id: historyId,
              storeLocation: Value(storeLocation),
              purchasedAt: now,
              total: Value(total),
              clientUpdatedAt: now,
              updatedAt: now,
              createdAt: now,
            ),
          );
      await outbox.enqueue(
        entity: 'purchase_histories',
        entityId: historyId,
        op: SyncOp.update,
        clientUpdatedAt: now,
        payload: {
          'store_location': storeLocation,
          'purchased_at': now.toIso8601String(),
          'total': total,
        },
      );
      for (final i in cart) {
        await _historyLine(
          historyId: historyId,
          now: now,
          name: i.name,
          productId: i.productId,
          unitAbbr: i.unitAbbr,
          qty: i.qtyBought ?? i.qtyPlanned,
          unitPrice: i.unitPrice,
        );
      }
      for (final m in extras) {
        await _historyLine(
          historyId: historyId,
          now: now,
          name: m.label,
          qty: 1,
          unitPrice: m.amountUsd,
        );
      }
    });

    return (await (db.select(db.purchaseHistories)
          ..where((t) => t.id.equals(historyId)))
        .getSingle());
  }

  Future<void> _historyLine({
    required String historyId,
    required DateTime now,
    required String name,
    String? productId,
    String? unitAbbr,
    required double qty,
    double? unitPrice,
  }) async {
    final lineId = _uuid.v4();
    final itemTotal = lineTotal(
        qty: qty, unitAbbr: unitAbbr, unitPrice: unitPrice ?? 0);
    await db.into(db.purchaseHistoryItems).insert(
          PurchaseHistoryItemsCompanion.insert(
            id: lineId,
            purchaseHistoryId: historyId,
            productId: Value(productId),
            name: name,
            unitAbbr: Value(unitAbbr),
            quantity: Value(qty),
            unitPrice: Value(unitPrice),
            lineTotal: Value(itemTotal),
            clientUpdatedAt: now,
            updatedAt: now,
            createdAt: now,
          ),
        );
    await outbox.enqueue(
      entity: 'purchase_history_items',
      entityId: lineId,
      op: SyncOp.update,
      clientUpdatedAt: now,
      payload: {
        'purchase_history_id': historyId,
        'product_id': productId,
        'name': name,
        'unit_abbr': unitAbbr,
        'quantity': qty,
        'unit_price': unitPrice,
        'line_total': itemTotal,
      },
    );
  }

  Future<ShoppingList> reuseHistory(String historyId, {String? listName}) async {
    final items = await historyItems(historyId);
    final name = listName?.trim().isNotEmpty == true
        ? listName!.trim()
        : 'Recompra';
    final list = await createList(name);
    for (final it in items) {
      await addItem(
        listId: list.id,
        name: it.name,
        productId: it.productId,
        unitAbbr: it.unitAbbr,
        qtyPlanned: it.quantity,
        unitPrice: it.unitPrice,
      );
    }
    return list;
  }

  Stream<List<PurchaseHistory>> watchHistory() {
    return (db.select(db.purchaseHistories)
          ..where((t) => t.deletedAt.isNull())
          ..orderBy([(t) => OrderingTerm.desc(t.purchasedAt)]))
        .watch();
  }

  Future<List<PurchaseHistoryItem>> historyItems(String historyId) {
    return (db.select(db.purchaseHistoryItems)
          ..where((t) =>
              t.purchaseHistoryId.equals(historyId) & t.deletedAt.isNull()))
        .get();
  }

  Future<void> ensureDefaults() async {
    await ensureDefaultUnits();
    await ensureDefaultCategories();
  }

  Future<void> ensureDefaultUnits() async {
    final existing = await (db.select(db.units)
          ..where((t) => t.deletedAt.isNull()))
        .get();
    final abbrs = existing.map((u) => u.abbreviation).whereType<String>().toSet();
    for (final u in defaultUnits) {
      if (abbrs.contains(u.$2)) continue;
      final now = _now;
      final id = _uuid.v4();
      await db.into(db.units).insert(UnitsCompanion.insert(
            id: id,
            name: u.$1,
            abbreviation: Value(u.$2),
            clientUpdatedAt: now,
            updatedAt: now,
            createdAt: now,
          ));
      await outbox.enqueue(
        entity: 'units',
        entityId: id,
        op: SyncOp.update,
        clientUpdatedAt: now,
        payload: {'name': u.$1, 'abbreviation': u.$2},
      );
    }
  }

  Future<void> ensureDefaultCategories() async {
    final existing = await (db.select(db.categories)
          ..where((t) => t.deletedAt.isNull()))
        .get();
    if (existing.isNotEmpty) return;
    for (final c in defaultCategories) {
      await upsertCategory(name: c.$1, icon: c.$2, color: c.$3);
    }
  }

  Future<void> onUserSwitch(String? newUserId) async {
    final prefs = await SharedPreferences.getInstance();
    final prev = prefs.getString('local_user_id');
    if (prev != null && newUserId != null && prev != newUserId) {
      await db.wipeAllUserData();
    }
    if (newUserId != null) {
      await prefs.setString('local_user_id', newUserId);
    } else {
      await prefs.remove('local_user_id');
      await db.wipeAllUserData();
    }
  }
}
