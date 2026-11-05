import 'dart:io';

import 'package:flutter/material.dart';

import '../../app_scope.dart';
import '../../data/database.dart';
import '../../utils/streams.dart';
import '../lists/add_item_sheet.dart';
import '../widgets/add_fab.dart';
import '../widgets/app_menu.dart';
import '../widgets/category_style.dart';
import '../widgets/money_text.dart';
import '../widgets/search_field.dart';
import '../widgets/soft_card.dart';
import '../widgets/sync_badge.dart';

/// Product catalog grouped by category (sin categoría last).
class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key, this.onLogout, this.embedded = false});

  final VoidCallback? onLogout;

  /// Body only (used inside the Inventario tabs).
  final bool embedded;

  @override
  State<ProductsPage> createState() => ProductsPageState();
}

class ProductsPageState extends State<ProductsPage> {
  // Cached: a new stream per build restarts StreamBuilder (spinner flicker).
  Stream<(List<Product>, List<Category>)>? _stream;
  final _search = TextEditingController();

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  void openEditor() => _edit(context);

  @override
  Widget build(BuildContext context) {
    final scope = AppScope.of(context);
    final repo = scope.repo;
    _stream ??= combineLatest2(
      repo.watchProducts(),
      repo.watchCategories(),
      (List<Product> p, List<Category> c) => (p, c),
    );
    final content = ListenableBuilder(
      listenable: scope.rates,
      builder: (context, _) => StreamBuilder<(List<Product>, List<Category>)>(
        stream: _stream,
        builder: (context, snap) {
          if (snap.hasError) {
            return Center(child: Text('Error: ${snap.error}'));
          }
          if (!snap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final (products, categories) = snap.data!;
          if (products.isEmpty) {
            return Center(
              child: Text(
                'Sin productos. Crea uno.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            );
          }
          return _grouped(context, products, categories);
        },
      ),
    );
    final body = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SearchField(
          controller: _search,
          hint: 'Buscar producto',
          onChanged: () => setState(() {}),
        ),
        Expanded(child: content),
      ],
    );
    if (widget.embedded) return body;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Productos'),
        actions: [
          const SyncBadge(),
          AppMenuButton(onLogout: widget.onLogout),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: AddFab(onPressed: () => _edit(context)),
      body: body,
    );
  }

  Widget _grouped(
    BuildContext context,
    List<Product> products,
    List<Category> categories,
  ) {
    final catMap = {for (final c in categories) c.id: c};
    final q = searchQuery(_search);
    final groups = <String?, List<Product>>{};
    for (final p in products.where(
      (p) =>
          matchesQuery(q, [p.name, p.description, catMap[p.categoryId]?.name]),
    )) {
      final key = (p.categoryId != null && catMap.containsKey(p.categoryId))
          ? p.categoryId
          : null;
      groups.putIfAbsent(key, () => []).add(p);
    }
    final keys = groups.keys.toList()
      ..sort((a, b) {
        if (a == null) return 1;
        if (b == null) return -1;
        return catMap[a]!.name.compareTo(catMap[b]!.name);
      });

    return ListView(
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 88),
      children: [
        for (final k in keys) ...[
          _CategoryHeader(
            name: k == null ? 'Sin categoría' : catMap[k]!.name,
            icon: CategoryStyle.iconFor(k == null ? null : catMap[k]!.icon),
            color:
                CategoryStyle.parseColor(k == null ? null : catMap[k]!.color) ??
                const Color(0xFF9E9E9E),
            count: groups[k]!.length,
          ),
          for (final p in groups[k]!)
            _productCard(context, p, k == null ? null : catMap[k]),
        ],
      ],
    );
  }

  Widget _productCard(BuildContext context, Product p, Category? cat) {
    final color =
        CategoryStyle.parseColor(cat?.color) ?? const Color(0xFF9E9E9E);
    final rates = AppScope.of(context).rates;
    final repo = AppScope.of(context).repo;
    return SoftCard(
      onTap: () => _edit(context, product: p),
      padding: const EdgeInsets.fromLTRB(12, 12, 8, 12),
      child: Row(
        children: [
          _thumb(p.localImagePath, color, cat?.icon),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  p.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                if (p.basePrice != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    moneySubtitle(rates, p.basePrice!),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () async {
              final sync = AppScope.of(context).sync;
              await repo.deleteProduct(p.id);
              await sync.syncNow();
            },
          ),
        ],
      ),
    );
  }

  Widget _thumb(String? path, Color color, String? iconKey) {
    if (path != null && File(path).existsSync()) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.file(File(path), width: 48, height: 48, fit: BoxFit.cover),
      );
    }
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(CategoryStyle.iconFor(iconKey), color: color, size: 22),
    );
  }

  /// Same form as the list "Agregar Producto" modal, without the cart toggle.
  Future<void> _edit(BuildContext context, {Product? product}) async {
    final scope = AppScope.of(context);
    final result = await showAddItemSheet(
      context: context,
      repo: scope.repo,
      product: product,
      showCart: false,
    );
    if (result == null || !context.mounted) return;
    await scope.repo.upsertProduct(
      id: product?.id,
      name: result.name,
      description: result.note,
      categoryId: result.categoryId,
      unitId: result.unitId,
      basePrice: result.unitPrice,
      localImagePath: result.imagePath,
      imagePending:
          result.imagePath != null &&
          result.imagePath != product?.localImagePath,
    );
    await scope.sync.syncNow();
  }
}

class _CategoryHeader extends StatelessWidget {
  const _CategoryHeader({
    required this.name,
    required this.icon,
    required this.color,
    required this.count,
  });

  final String name;
  final IconData icon;
  final Color color;
  final int count;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 6),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 16, color: color),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              name,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Text(
            '$count',
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
