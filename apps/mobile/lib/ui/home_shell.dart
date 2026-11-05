import 'package:flutter/material.dart';

import 'budget/budget_page.dart';
import 'history/history_page.dart';
import 'inventario/inventario_page.dart';
import 'stores/stores_page.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key, required this.onLogout});

  final VoidCallback onLogout;

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      StoresPage(onLogout: widget.onLogout),
      InventarioPage(onLogout: widget.onLogout),
      BudgetPage(onLogout: widget.onLogout),
      const HistoryPage(),
    ];
    return Scaffold(
      body: IndexedStack(index: _index, children: pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) {
          // Tap the active tab again: back to its root (pop sub-pages).
          if (i == _index) Navigator.of(context).popUntil((r) => r.isFirst);
          setState(() => _index = i);
        },
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.storefront_outlined), label: 'Tiendas'),
          NavigationDestination(
              icon: Icon(Icons.inventory_2_outlined), label: 'Inventario'),
          NavigationDestination(
              icon: Icon(Icons.account_balance_wallet_outlined),
              label: 'Presupuesto'),
          NavigationDestination(icon: Icon(Icons.history), label: 'Historial'),
        ],
      ),
    );
  }
}
