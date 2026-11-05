import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'money_text.dart';

/// Summary card. Cart (left, primary) and total (right, secondary).
class TotalBanner extends StatelessWidget {
  const TotalBanner({
    super.key,
    required this.title,
    required this.total,
    required this.cart,
  });

  /// Label for the total block (right).
  final String title;
  final double total;
  final double cart;

  @override
  Widget build(BuildContext context) {
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
                  cart,
                  style: theme.textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: AppTheme.mint,
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
                  title,
                  style: theme.textTheme.labelMedium?.copyWith(color: muted),
                ),
                const SizedBox(height: 4),
                MoneyText(
                  total,
                  textAlign: TextAlign.end,
                  style: theme.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
