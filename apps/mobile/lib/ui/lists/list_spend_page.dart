import 'package:flutter/material.dart';

import '../../app_scope.dart';
import '../../data/database.dart';
import '../../utils/spend_math.dart';
import '../../utils/streams.dart';
import '../widgets/money_text.dart';
import '../widgets/spend_chart.dart';

/// Spend breakdown by category for a single list.
class ListSpendPage extends StatelessWidget {
  const ListSpendPage({
    super.key,
    required this.listId,
    required this.listName,
  });

  final String listId;
  final String listName;

  @override
  Widget build(BuildContext context) {
    final repo = AppScope.of(context).repo;
    return Scaffold(
      appBar: AppBar(title: Text('Gastos · $listName')),
      body: StreamBuilder<(List<ListItem>, List<Product>, List<Category>)>(
        stream: combineLatest3(
          repo.watchItems(listId),
          repo.watchProducts(),
          repo.watchCategories(),
          (List<ListItem> i, List<Product> p, List<Category> c) => (i, p, c),
        ),
        builder: (context, snap) {
          if (!snap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final (items, products, categories) = snap.data!;
          final productMap = {for (final p in products) p.id: p};
          final categoryMap = {for (final c in categories) c.id: c};
          final rows = buildCategorySpend(
            spendByCategory(items, productMap),
            categoryMap,
          );
          final total = items.fold<double>(0, (s, i) => s + itemCost(i));
          final cart = items
              .where((i) => i.status == 'in_cart')
              .fold<double>(0, (s, i) => s + itemCost(i));
          final theme = Theme.of(context);

          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Text('Total lista', style: theme.textTheme.labelMedium),
              MoneyText(
                total,
                style: theme.textTheme.headlineSmall
                    ?.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 12),
              Text('En carrito', style: theme.textTheme.labelMedium),
              MoneyText(
                cart,
                style: theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 24),
              if (rows.isEmpty)
                Text('Sin gastos aún', style: theme.textTheme.bodyMedium)
              else ...[
                StackedSpendBar(segments: rows, height: 16),
                const SizedBox(height: 12),
                SpendLegend(rows: rows),
                const SizedBox(height: 20),
                SpendBreakdown(rows: rows),
              ],
            ],
          );
        },
      ),
    );
  }
}
