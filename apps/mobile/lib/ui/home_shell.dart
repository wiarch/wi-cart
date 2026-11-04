import 'package:flutter/material.dart';

import '../app_scope.dart';
import 'categories/categories_page.dart';
import 'history/history_page.dart';
import 'lists/list_detail_page.dart';
import 'lists/lists_page.dart';
import 'products/products_page.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key, required this.onLogout});

  final VoidCallback onLogout;

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;
  bool _openedLast = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_openedLast) {
      _openedLast = true;
      WidgetsBinding.instance.addPostFrameCallback((_) => _openLastList());
    }
  }

  Future<void> _openLastList() async {
    final list = await AppScope.of(context).repo.getLastActiveList();
    if (list == null || !mounted) return;
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) =>
            ListDetailPage(listId: list.id, listName: list.name),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      ListsPage(onLogout: widget.onLogout),
      const ProductsPage(),
      const CategoriesPage(),
      const HistoryPage(),
    ];
    return Scaffold(
      body: IndexedStack(index: _index, children: pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.list_alt), label: 'Listas'),
          NavigationDestination(
              icon: Icon(Icons.inventory_2_outlined), label: 'Productos'),
          NavigationDestination(
              icon: Icon(Icons.category_outlined), label: 'Categorías'),
          NavigationDestination(
              icon: Icon(Icons.history), label: 'Historial'),
        ],
      ),
    );
  }
}
