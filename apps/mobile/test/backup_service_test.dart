import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wicart_mobile/data/database.dart';
import 'package:wicart_mobile/data/outbox.dart';
import 'package:wicart_mobile/data/repository.dart';
import 'package:wicart_mobile/services/backup_service.dart';

void main() {
  test('store backup includes its lists and products, not the rest', () async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    final repo = CartRepository(db, OutboxWriter(db));
    addTearDown(db.close);

    final store = await repo.createStore(name: 'Mercado');
    final other = await repo.createStore(name: 'Otra');
    final cat = await repo.upsertCategory(name: 'Verdura');
    final extraCat = await repo.upsertCategory(name: 'Limpieza');
    final product = await repo.upsertProduct(
      name: 'Tomate',
      categoryId: cat.id,
      basePrice: 1.5,
    );
    await repo.upsertProduct(name: 'Jabón', categoryId: extraCat.id);
    final list = await repo.createList('Compra', storeId: store.id);
    await repo.createList('Ajena', storeId: other.id);
    await repo.addItem(
      listId: list.id,
      name: 'Tomate',
      productId: product.id,
      unitPrice: 1.5,
    );

    final doc = await BackupService(repo).build(storeId: store.id);
    expect((doc['stores'] as List).map((s) => s['name']), ['Mercado']);
    expect((doc['shopping_lists'] as List).map((l) => l['name']), ['Compra']);
    expect((doc['products'] as List).map((p) => p['name']), ['Tomate']);
    expect((doc['categories'] as List).map((c) => c['name']), ['Verdura']);
    expect(doc['list_items'], hasLength(1));

    final all = await BackupService(repo).build(
      allProducts: true,
      allCategories: true,
    );
    expect((all['products'] as List).map((p) => p['name']), contains('Jabón'));
    expect(
      (all['categories'] as List).map((c) => c['name']),
      containsAll(['Verdura', 'Limpieza']),
    );

    final copyDb = AppDatabase.forTesting(NativeDatabase.memory());
    final copy = CartRepository(copyDb, OutboxWriter(copyDb));
    addTearDown(copyDb.close);
    final n = await BackupService(copy).restore(doc);
    expect(n, greaterThan(0));
    expect((await copy.watchStores().first).map((s) => s.name), ['Mercado']);
    expect((await copy.watchActiveLists().first).map((l) => l.name), ['Compra']);
    expect((await copy.watchProducts().first).map((p) => p.name), ['Tomate']);
  });
}
