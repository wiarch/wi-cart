import 'package:flutter/material.dart';

import '../../data/database.dart';
import '../../utils/spend_math.dart';
import '../theme/app_theme.dart';
import 'money_text.dart';
import 'spend_chart.dart';

/// Per-list spend bars (scaled to the largest list) with category legend.
class SpendOverviewCard extends StatelessWidget {
  const SpendOverviewCard({
    super.key,
    required this.lists,
    required this.itemsByList,
    required this.productMap,
    required this.categoryMap,
  });

  final List<ShoppingList> lists;
  final Map<String, List<ListItem>> itemsByList;
  final Map<String, Product> productMap;
  final Map<String, Category> categoryMap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final perList = <String, List<CategorySpend>>{};
    final totals = <String, double>{};
    final globalSpend = <String?, double>{};
    for (final l in lists) {
      final items = itemsByList[l.id] ?? const <ListItem>[];
      final spend = spendByCategory(items, productMap);
      perList[l.id] = buildCategorySpend(spend, categoryMap);
      totals[l.id] = spend.values.fold<double>(0, (s, v) => s + v);
      spend.forEach((k, v) => globalSpend[k] = (globalSpend[k] ?? 0) + v);
    }
    final maxTotal = totals.values.fold<double>(0, (m, v) => v > m ? v : m);
    if (maxTotal <= 0) return const SizedBox.shrink();
    final legend = buildCategorySpend(globalSpend, categoryMap);

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      padding: const EdgeInsets.all(16),
      decoration: AppTheme.cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Gasto por lista y categoría',
              style: theme.textTheme.titleSmall),
          const SizedBox(height: 12),
          for (final l in lists)
            if ((totals[l.id] ?? 0) > 0)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            l.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.labelMedium,
                          ),
                        ),
                        Text(
                          formatUsd(totals[l.id]!),
                          style: theme.textTheme.labelMedium
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    StackedSpendBar(
                      segments: perList[l.id] ?? const [],
                      fraction: totals[l.id]! / maxTotal,
                      height: 10,
                    ),
                  ],
                ),
              ),
          const SizedBox(height: 4),
          SpendLegend(rows: legend),
        ],
      ),
    );
  }
}
