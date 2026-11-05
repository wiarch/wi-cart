import 'package:flutter/material.dart';

import '../../app_scope.dart';
import '../../data/database.dart';
import '../../utils/spend_math.dart';
import '../../utils/streams.dart';
import '../widgets/app_menu.dart';
import '../theme/app_theme.dart';
import '../widgets/add_fab.dart';
import '../widgets/category_style.dart';
import '../widgets/soft_card.dart';
import '../widgets/sync_badge.dart';
import '../widgets/money_text.dart';
import '../widgets/search_field.dart';
import '../widgets/total_banner.dart';
import 'store_dialogs.dart';
import 'store_lists_page.dart';

typedef _Data = (
  List<ShoppingList>,
  List<ListItem>,
  List<Product>,
  List<Category>,
  List<Store>,
);

/// Root of the "Listas" flow: stores → lists → products.
class StoresPage extends StatefulWidget {
  const StoresPage({super.key, this.onLogout});

  final VoidCallback? onLogout;

  @override
  State<StoresPage> createState() => _StoresPageState();
}

class _StoresPageState extends State<StoresPage> {
  // Created once: rebuilding a stream on every build restarts StreamBuilder
  // and shows the spinner again (the "infinite loading" bug).
  Stream<_Data>? _stream;
  final _search = TextEditingController();

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  Stream<_Data> _makeStream(AppScope scope) {
    final repo = scope.repo;
    return combineLatest2(
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
  }

  @override
  Widget build(BuildContext context) {
    final scope = AppScope.of(context);
    _stream ??= _makeStream(scope);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tiendas'),
        actions: [
          const SyncBadge(),
          AppMenuButton(onLogout: widget.onLogout),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: AddFab(
        tooltip: 'Nueva tienda',
        onPressed: () async {
          final s = await createStoreDialog(context);
          if (s != null && context.mounted) {
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => StoreListsPage(store: s)),
            );
          }
        },
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SearchField(
            controller: _search,
            hint: 'Buscar tienda',
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
                  final (lists, items, _, _, stores) = snap.data!;
                  return _body(context, lists, items, stores);
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
    List<ShoppingList> lists,
    List<ListItem> items,
    List<Store> stores,
  ) {
    final theme = Theme.of(context);
    final q = searchQuery(_search);
    final storeIds = stores.map((s) => s.id).toSet();
    final itemsByList = <String, List<ListItem>>{};
    for (final i in items) {
      itemsByList.putIfAbsent(i.shoppingListId, () => []).add(i);
    }
    final all = listTotals(items);
    final noStoreLists = lists
        .where((l) => l.storeId == null || !storeIds.contains(l.storeId))
        .toList();
    final hasNoStore = noStoreLists.isNotEmpty;

    if (stores.isEmpty && !hasNoStore) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Text(
            'Crea una tienda para empezar',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 88),
      children: [
        TotalBanner(title: 'Total general', total: all.$1, cart: all.$2),
        for (final s in stores.where(
          (s) => matchesQuery(q, [s.name, s.location, s.notes]),
        ))
          _storeCard(
            context,
            store: s,
            lists: lists.where((l) => l.storeId == s.id).toList(),
            itemsByList: itemsByList,
          ),
        if (hasNoStore &&
            matchesQuery(q, ['sin tienda', ...noStoreLists.map((l) => l.name)]))
          _storeCard(
            context,
            store: null,
            lists: noStoreLists,
            itemsByList: itemsByList,
          ),
      ],
    );
  }

  Widget _storeCard(
    BuildContext context, {
    required Store? store,
    required List<ShoppingList> lists,
    required Map<String, List<ListItem>> itemsByList,
  }) {
    final theme = Theme.of(context);
    final muted = theme.textTheme.bodySmall?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
    );
    final ownItems = [for (final l in lists) ...?itemsByList[l.id]];
    final totals = listTotals(ownItems);
    final name = store?.name ?? 'Sin tienda';

    return SoftCard(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => StoreListsPage(store: store)),
      ),
      padding: const EdgeInsets.fromLTRB(14, 14, 8, 14),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppTheme.sage.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              CategoryStyle.iconFor(store?.icon),
              color: AppTheme.sage,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                if (store?.location != null && store!.location!.isNotEmpty)
                  Text(store.location!, style: muted),
                Text('${lists.length} listas', style: muted),
                const SizedBox(height: 6),
                MoneyText(
                  totals.$1,
                  compact: true,
                  style: theme.textTheme.labelMedium,
                ),
                MoneyText(
                  totals.$2,
                  compact: true,
                  style: theme.textTheme.labelSmall,
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right),
        ],
      ),
    );
  }
}
