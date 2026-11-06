import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wicart_mobile/data/database.dart';
import 'package:wicart_mobile/data/outbox.dart';
import 'package:wicart_mobile/data/repository.dart';

void main() {
  test('delete list keeps products; delete store cascades lists', () async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    final repo = CartRepository(db, OutboxWriter(db));
    addTearDown(db.close);

    final store = await repo.createStore(name: 'Mercado');
    final product = await repo.upsertProduct(name: 'Tomate');
    final list = await repo.createList('Compra', storeId: store.id);
    await repo.addItem(
      listId: list.id,
      name: 'Tomate',
      productId: product.id,
      unitPrice: 1.5,
    );

    await repo.deleteList(list.id);

    final products = await repo.watchProducts().first;
    expect(products, hasLength(1));
    expect(products.single.deletedAt, isNull);
    expect(await repo.watchActiveLists().first, isEmpty);
    expect(await repo.watchAllItems().first, isEmpty);

    final other = await repo.createStore(name: 'Otra');
    await repo.createList('Lista A', storeId: store.id);
    await repo.createList('Lista B', storeId: other.id);
    await repo.deleteStore(store.id);

    final stores = await repo.watchStores().first;
    expect(stores.map((s) => s.name), ['Otra']);
    final lists = await repo.watchActiveLists().first;
    expect(lists.map((l) => l.name), ['Lista B']);
    expect(await repo.watchProducts().first, hasLength(1));
  });

  test('clone store copies its lists and keeps products', () async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    final repo = CartRepository(db, OutboxWriter(db));
    addTearDown(db.close);

    final store = await repo.createStore(name: 'Mercado');
    final product = await repo.upsertProduct(name: 'Tomate');
    final list = await repo.createList('Compra', storeId: store.id);
    await repo.addItem(listId: list.id, name: 'Tomate', productId: product.id);

    final clone = await repo.cloneStore(store.id);
    final lists = await repo.watchActiveLists().first;
    expect(clone.name, 'Mercado (copia)');
    expect(lists.map((l) => l.storeId).toSet(), {store.id, clone.id});
    expect(await repo.watchProducts().first, hasLength(1));
  });

  test('saveCartHistory keeps one store cart and leaves lists active', () async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    final repo = CartRepository(db, OutboxWriter(db));
    addTearDown(db.close);

    final store = await repo.createStore(name: 'Mercado');
    final other = await repo.createStore(name: 'Otra');
    final a = await repo.createList('A', storeId: store.id);
    final b = await repo.createList('B', storeId: other.id);
    final item = await repo.addItem(
      listId: a.id,
      name: 'Tomate',
      unitPrice: 2,
      qtyPlanned: 3,
    );
    await repo.setItemStatus(item, 'in_cart');
    final outside = await repo.addItem(listId: b.id, name: 'Pan', unitPrice: 1);
    await repo.setItemStatus(outside, 'in_cart');

    final saved =
        await repo.saveCartHistory(storeId: store.id, storeLocation: store.name);
    expect(saved.total, closeTo(6, 1e-9));
    expect(saved.storeLocation, 'Mercado');
    final lines = await repo.historyItems(saved.id);
    expect(lines.map((l) => l.name), ['Tomate']);
    expect((await repo.watchActiveLists().first).length, 2);
  });

  test('budget movement updates the watched total', () async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    final repo = CartRepository(db, OutboxWriter(db));
    addTearDown(db.close);

    final seen = repo.watchBudgetMovements().map(
          (rows) => rows.fold<double>(0, (s, m) => s + m.amountUsd),
        );
    final first = seen.first;
    await repo.addBudgetMovement(label: 'Hortalizas', amountUsd: 4);
    expect(await first, 4);
    final rows = await repo.watchBudgetMovements().first;
    await repo.updateBudgetMovement(rows.single.id, label: 'Verduras', amountUsd: 6);
    expect(
      (await repo.watchBudgetMovements().first).single.amountUsd,
      6,
    );
    await repo.deleteBudgetMovement(rows.single.id);
    expect(await repo.watchBudgetMovements().first, isEmpty);
  });
}
