import 'package:flutter/material.dart';

import '../categories/categories_page.dart';
import '../products/products_page.dart';
import '../widgets/add_fab.dart';
import '../widgets/app_menu.dart';
import '../widgets/sync_badge.dart';

/// Inventario: Productos y Categorías en tabs. The "+" acts on the open tab.
class InventarioPage extends StatefulWidget {
  const InventarioPage({super.key, this.onLogout});

  final VoidCallback? onLogout;

  @override
  State<InventarioPage> createState() => _InventarioPageState();
}

class _InventarioPageState extends State<InventarioPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs = TabController(length: 2, vsync: this);
  final _productsKey = GlobalKey<ProductsPageState>();
  final _categoriesKey = GlobalKey<CategoriesPageState>();

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventario'),
        actions: [
          const SyncBadge(),
          AppMenuButton(onLogout: widget.onLogout),
        ],
        bottom: TabBar(
          controller: _tabs,
          tabs: const [
            Tab(text: 'Productos'),
            Tab(text: 'Categorías'),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: ListenableBuilder(
        listenable: _tabs,
        builder: (context, _) {
          final products = _tabs.index == 0;
          return AddFab(
            key: ValueKey(products ? 'product' : 'category'),
            tooltip: products ? 'Nuevo producto' : 'Nueva categoría',
            onPressed: () => products
                ? _productsKey.currentState?.openEditor()
                : _categoriesKey.currentState?.openEditor(),
          );
        },
      ),
      body: TabBarView(
        controller: _tabs,
        children: [
          ProductsPage(
            key: _productsKey,
            embedded: true,
            onLogout: widget.onLogout,
          ),
          CategoriesPage(
            key: _categoriesKey,
            embedded: true,
            onLogout: widget.onLogout,
          ),
        ],
      ),
    );
  }
}
