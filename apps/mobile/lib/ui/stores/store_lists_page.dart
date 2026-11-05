import 'package:flutter/material.dart';

import '../../app_scope.dart';
import '../../data/database.dart';
import '../../utils/spend_math.dart';
import '../../utils/streams.dart';
import '../lists/list_card.dart';
import '../theme/app_theme.dart';
import '../widgets/add_fab.dart';
import '../widgets/category_style.dart';
import '../widgets/money_text.dart';
import '../widgets/search_field.dart';
import 'store_dialogs.dart';

/// Cart is the primary figure; list total is secondary.
class _CartHighlight extends StatelessWidget {
  const _CartHighlight({required this.total, required this.cart});

  final double total;
  final double cart;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final muted = theme.colorScheme.onSurfaceVariant;
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      padding: const EdgeInsets.all(20),
      decoration: AppTheme.cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'En carrito',
            style: theme.textTheme.labelLarge?.copyWith(
              color: AppTheme.sage,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          MoneyText(
            cart,
            style: theme.textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.w900,
              color: AppTheme.mint,
              letterSpacing: -1,
            ),
          ),
          const Divider(height: 24),
          Text(
            'Total de la lista',
            style: theme.textTheme.labelMedium?.copyWith(color: muted),
          ),
          const SizedBox(height: 2),
          MoneyText(
            total,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

typedef _Data = (
  List<ShoppingList>,
  List<ListItem>,
  List<Product>,
  List<Category>,
  List<Store>,
);

/// Lists of one store. [store] null = lists without a (known) store.
class StoreListsPage extends StatefulWidget {
  const StoreListsPage({super.key, required this.store});

  final Store? store;

  @override
  State<StoreListsPage> createState() => _StoreListsPageState();
}

class _StoreListsPageState extends State<StoreListsPage> {
  Stream<_Data>? _stream;
  final _search = TextEditingController();
  String? _name;

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  Future<void> _rename(Store store) async {
    final scope = AppScope.of(context);
    final name = await storeNameDialog(context, initial: _name ?? store.name);
    if (name == null || name == (_name ?? store.name)) return;
    await scope.repo.renameStore(store.id, name);
    await scope.sync.syncNow();
    if (mounted) setState(() => _name = name);
  }

  @override
  Widget build(BuildContext context) {
    final scope = AppScope.of(context);
    final repo = scope.repo;
    final store = widget.store;
    _stream ??= combineLatest2(
      combineLatest4(
        repo.watchActiveLists(),
        repo.watchAllItems(),
        repo.watchProducts(),
        repo.watchCategories(),
        (a, b, c, d) => (a, b, c, d),
      ),
      repo.watchStores(),
      (x, y) => (x.$1, x.$2, x.$3, x.$4, y),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(_name ?? store?.name ?? 'Sin tienda'),
        actions: [
          if (store != null)
            IconButton(
              tooltip: 'Editar nombre',
              icon: const Icon(Icons.edit_outlined),
              onPressed: () => _rename(store),
            ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: AddFab(
        tooltip: 'Nueva lista',
        onPressed: () async {
          if (store != null) {
            await createListDialog(context, store);
            return;
          }
          final stores = await repo.watchStores().first;
          if (!context.mounted) return;
          final s = await pickStoreSheet(context, stores);
          if (s != null && context.mounted) await createListDialog(context, s);
        },
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SearchField(
            controller: _search,
            hint: 'Buscar lista',
            onChanged: () => setState(() {}),
          ),
          Expanded(
            child: ListenableBuilder(
              listenable: scope.rates,
              builder: (context, _) => StreamBuilder<_Data>(
                stream: _stream,
                builder: (context, snap) {
                  if (snap.hasError) {
                    return Center(child: Text('Error: ${snap.error}'));
                  }
                  if (!snap.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final (allLists, items, products, categories, stores) =
                      snap.data!;
                  return _body(
                    context,
                    allLists,
                    items,
                    products,
                    categories,
                    stores,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _body(
    BuildContext context,
    List<ShoppingList> allLists,
    List<ListItem> items,
    List<Product> products,
    List<Category> categories,
    List<Store> stores,
  ) {
    final theme = Theme.of(context);
    final store = widget.store;
    final storeIds = stores.map((s) => s.id).toSet();
    final q = searchQuery(_search);
    final lists = allLists
        .where(
          (l) => store == null
              ? l.storeId == null || !storeIds.contains(l.storeId)
              : l.storeId == store.id,
        )
        .where((l) => matchesQuery(q, [l.name]))
        .toList();
    final itemsByList = <String, List<ListItem>>{};
    for (final i in items) {
      itemsByList.putIfAbsent(i.shoppingListId, () => []).add(i);
    }
    final ownItems = [for (final l in lists) ...?itemsByList[l.id]];
    final totals = listTotals(ownItems);

    return ListView(
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 88),
      children: [
        if (store != null && (store.location?.isNotEmpty ?? false))
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
            child: Row(
              children: [
                Icon(
                  CategoryStyle.iconFor(store.icon),
                  size: 18,
                  color: AppTheme.sage,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    store.location!,
                    style: theme.textTheme.bodySmall,
                  ),
                ),
              ],
            ),
          ),
        _CartHighlight(total: totals.$1, cart: totals.$2),
        if (lists.isEmpty)
          Padding(
            padding: const EdgeInsets.all(32),
            child: Center(
              child: Text(
                'Sin listas en esta tienda',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ),
        for (final l in lists)
          ListCard(list: l, items: itemsByList[l.id] ?? const []),
      ],
    );
  }
}
