import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../app_scope.dart';
import '../../data/database.dart';
import '../../utils/spend_math.dart';
import '../theme/app_theme.dart';
import '../widgets/category_style.dart';
import '../widgets/icon_picker.dart';
import '../widgets/money_text.dart';
import '../widgets/soft_card.dart';
import 'list_detail_page.dart';
import 'list_spend_page.dart';

final _dateFmt = DateFormat('dd/MM/yyyy HH:mm');

/// One shopping list row: icon, name, date, total and cart (USD + Bs).
class ListCard extends StatelessWidget {
  const ListCard({
    super.key,
    required this.list,
    required this.items,
    this.storeName,
  });

  final ShoppingList list;
  final List<ListItem> items;
  final String? storeName;

  @override
  Widget build(BuildContext context) {
    final rates = AppScope.of(context).rates;
    final theme = Theme.of(context);
    final totals = listTotals(items);
    final muted = theme.textTheme.bodySmall
        ?.copyWith(color: theme.colorScheme.onSurfaceVariant);

    return SoftCard(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) =>
              ListDetailPage(listId: list.id, listName: list.name),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(14, 14, 4, 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppTheme.sage.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              CategoryStyle.iconFor(list.icon ?? 'cart'),
              color: AppTheme.sage,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  list.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                if (storeName != null) Text(storeName!, style: muted),
                const SizedBox(height: 2),
                Text(
                  'Actualizada ${_dateFmt.format(list.updatedAt.toLocal())}',
                  style: muted,
                ),
                const SizedBox(height: 8),
                Text(
                  'Total: ${moneySubtitle(rates, totals.$1)}',
                  style: theme.textTheme.labelMedium,
                ),
                Text(
                  'Carrito: ${moneySubtitle(rates, totals.$2)}',
                  style: theme.textTheme.labelMedium,
                ),
              ],
            ),
          ),
          PopupMenuButton<String>(
            onSelected: (v) => runListMenu(context, list, v),
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'clone', child: Text('Clonar lista')),
              PopupMenuItem(value: 'icon', child: Text('Cambiar icono')),
              PopupMenuItem(value: 'spend', child: Text('Ver gastos')),
            ],
          ),
        ],
      ),
    );
  }
}

/// Menu actions shared by list cards.
Future<void> runListMenu(BuildContext context, ShoppingList l, String v) async {
  final scope = AppScope.of(context);
  switch (v) {
    case 'clone':
      final clone = await scope.repo.cloneList(l.id);
      await scope.sync.syncNow();
      if (!context.mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ListDetailPage(listId: clone.id, listName: clone.name),
        ),
      );
    case 'icon':
      final key = await showIconPicker(context, current: l.icon);
      if (key == null) return;
      await scope.repo.setListIcon(l.id, key);
      await scope.sync.syncNow();
    case 'spend':
      if (!context.mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ListSpendPage(listId: l.id, listName: l.name),
        ),
      );
  }
}
