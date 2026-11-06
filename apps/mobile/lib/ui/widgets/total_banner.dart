import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../app_scope.dart';
import '../budget/budget_page.dart';
import '../theme/app_theme.dart';
import 'money_text.dart';

/// Summary card. Cart on the left, purchase budget on the right.
class TotalBanner extends StatefulWidget {
  const TotalBanner({
    super.key,
    required this.title,
    required this.total,
    required this.cart,
  });

  /// Label for the optional list-total block.
  final String title;
  final double total;
  final double cart;

  @override
  State<TotalBanner> createState() => _TotalBannerState();
}

class _TotalBannerState extends State<TotalBanner> {
  double? _budget;
  var _loaded = false;

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefs) {
      if (!mounted) return;
      setState(() {
        _budget = prefs.getDouble(BudgetPage.prefKey);
        _loaded = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final rates = AppScope.of(context).rates;
    return ListenableBuilder(
      listenable: rates,
      builder: (context, _) => _body(context, rates.showListGrandTotal),
    );
  }

  Widget _body(BuildContext context, bool showTotal) {
    final theme = Theme.of(context);
    final muted = theme.colorScheme.onSurfaceVariant;
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      padding: const EdgeInsets.all(18),
      decoration: AppTheme.cardDecoration(),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            flex: 3,
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
                  widget.cart,
                  style: theme.textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: AppTheme.ink700,
                    letterSpacing: -1,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Presupuesto',
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: AppTheme.sage,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                if (!_loaded)
                  const SizedBox(height: 28)
                else if (_budget == null)
                  Text(
                    '—',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: muted,
                    ),
                  )
                else
                  MoneyText(
                    _budget!,
                    textAlign: TextAlign.end,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: AppTheme.ink700,
                    ),
                  ),
                if (showTotal) ...[
                  const SizedBox(height: 8),
                  Text(
                    widget.title,
                    style: theme.textTheme.labelMedium?.copyWith(color: muted),
                  ),
                  MoneyText(
                    widget.total,
                    textAlign: TextAlign.end,
                    style: theme.textTheme.labelLarge
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
