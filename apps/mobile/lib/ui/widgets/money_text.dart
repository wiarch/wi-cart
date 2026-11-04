import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../app_scope.dart';
import '../../services/exchange_rate_service.dart';

final _usdFmt = NumberFormat.currency(locale: 'en_US', symbol: '\$');
final _bsFmt = NumberFormat.currency(locale: 'es_VE', symbol: 'Bs\u00a0');
final _eurFmt = NumberFormat.currency(locale: 'de_DE', symbol: '€');

String formatUsd(double amount) => _usdFmt.format(amount);
String formatBs(double amount) => _bsFmt.format(amount);
String formatEur(double amount) => _eurFmt.format(amount);

/// Primary USD + Bs (BCV) + optional EUR equivalent.
class MoneyText extends StatelessWidget {
  const MoneyText(
    this.amountUsd, {
    super.key,
    this.style,
    this.secondaryStyle,
    this.compact = false,
    this.textAlign,
  });

  final double amountUsd;
  final TextStyle? style;
  final TextStyle? secondaryStyle;
  final bool compact;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    final rates = AppScope.of(context).rates;
    return ListenableBuilder(
      listenable: rates,
      builder: (context, _) => _body(context, rates),
    );
  }

  Widget _body(BuildContext context, ExchangeRateService rates) {
    final usd = formatUsd(amountUsd);
    final bs = rates.toBs(amountUsd);
    final eur = rates.toEur(amountUsd);
    final sec = secondaryStyle ??
        Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            );

    if (compact) {
      final parts = <String>[usd];
      if (bs != null) parts.add(formatBs(bs));
      if (eur != null) parts.add('≈ ${formatEur(eur)}');
      return Text(parts.join(' · '), style: style, textAlign: textAlign);
    }

    return Column(
      crossAxisAlignment: textAlign == TextAlign.end
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(usd, style: style, textAlign: textAlign),
        if (bs != null)
          Text(formatBs(bs), style: sec, textAlign: textAlign),
        if (eur != null)
          Text('≈ ${formatEur(eur)}', style: sec, textAlign: textAlign),
      ],
    );
  }
}

/// Inline subtitle helper when ListenableBuilder parent already rebuilds.
String moneySubtitle(ExchangeRateService rates, double amountUsd) {
  final parts = <String>[formatUsd(amountUsd)];
  final bs = rates.toBs(amountUsd);
  if (bs != null) parts.add(formatBs(bs));
  final eur = rates.toEur(amountUsd);
  if (eur != null) parts.add('≈ ${formatEur(eur)}');
  return parts.join(' · ');
}
