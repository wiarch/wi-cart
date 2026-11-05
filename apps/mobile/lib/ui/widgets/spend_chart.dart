import 'package:flutter/material.dart';

import '../../app_scope.dart';
import '../../data/database.dart';
import '../theme/app_theme.dart';
import 'category_style.dart';
import 'money_text.dart';

class CategorySpend {
  const CategorySpend({
    required this.label,
    required this.color,
    required this.usd,
  });

  final String label;
  final Color color;
  final double usd;
}

/// Spend-by-category map → sorted chart rows (largest first).
List<CategorySpend> buildCategorySpend(
  Map<String?, double> spend,
  Map<String, Category> categories,
) {
  final rows = <CategorySpend>[];
  spend.forEach((id, usd) {
    if (usd <= 0) return;
    final cat = id == null ? null : categories[id];
    rows.add(CategorySpend(
      label: cat?.name ?? 'Sin categoría',
      color: CategoryStyle.parseColor(cat?.color) ?? const Color(0xFF9E9E9E),
      usd: usd,
    ));
  });
  rows.sort((a, b) => b.usd.compareTo(a.usd));
  return rows;
}

/// Horizontal stacked bar. [fraction] scales the bar against a shared max.
class StackedSpendBar extends StatelessWidget {
  const StackedSpendBar({
    super.key,
    required this.segments,
    this.fraction = 1,
    this.height = 12,
  });

  final List<CategorySpend> segments;
  final double fraction;
  final double height;

  @override
  Widget build(BuildContext context) {
    final total = segments.fold<double>(0, (s, e) => s + e.usd);
    final track = AppTheme.ink700;
    if (total <= 0) {
      return Container(
        height: height,
        decoration: BoxDecoration(
          color: track,
          borderRadius: BorderRadius.circular(height / 2),
        ),
      );
    }
    final f = fraction.clamp(0.0, 1.0).toDouble();
    return LayoutBuilder(
      builder: (context, c) => Container(
        height: height,
        decoration: BoxDecoration(
          color: track,
          borderRadius: BorderRadius.circular(height / 2),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(height / 2),
          child: SizedBox(
            width: c.maxWidth * f,
            height: height,
            child: Row(
              children: [
                for (final seg in segments)
                  Expanded(
                    flex: (seg.usd / total * 1000).round().clamp(1, 1000),
                    child: ColoredBox(color: seg.color),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Per-category rows: colour dot, label, USD · Bs, proportional bar.
class SpendBreakdown extends StatelessWidget {
  const SpendBreakdown({super.key, required this.rows});

  final List<CategorySpend> rows;

  @override
  Widget build(BuildContext context) {
    final rates = AppScope.of(context).rates;
    final theme = Theme.of(context);
    final max = rows.isEmpty
        ? 1.0
        : rows.map((r) => r.usd).reduce((a, b) => a > b ? a : b);
    return Column(
      children: [
        for (final r in rows)
          Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: r.color,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        r.label,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodyMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                    ),
                    Text(
                      moneySubtitle(rates, r.usd),
                      style: theme.textTheme.labelSmall,
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                StackedSpendBar(
                  segments: [r],
                  fraction: r.usd / max,
                  height: 8,
                ),
              ],
            ),
          ),
      ],
    );
  }
}

/// Legend chips for the categories present in [rows].
class SpendLegend extends StatelessWidget {
  const SpendLegend({super.key, required this.rows});

  final List<CategorySpend> rows;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 6,
      children: [
        for (final r in rows)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration:
                    BoxDecoration(color: r.color, shape: BoxShape.circle),
              ),
              const SizedBox(width: 6),
              Text(
                '${r.label} · ${formatUsd(r.usd)}',
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ],
          ),
      ],
    );
  }
}
