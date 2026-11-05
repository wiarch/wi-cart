import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../app_scope.dart';
import '../../data/database.dart';
import '../../services/exchange_rate_service.dart';
import '../../utils/spend_math.dart';
import '../../utils/streams.dart';
import '../theme/app_theme.dart';
import '../widgets/app_menu.dart';
import '../widgets/money_text.dart';

typedef _Snap = (List<PurchaseHistory>, List<ShoppingList>, List<ListItem>);

/// Monthly budget vs. spent this month and what is already in the cart
/// of active lists. Budget is stored locally (SharedPreferences) in USD.
class BudgetPage extends StatefulWidget {
  const BudgetPage({super.key, this.onLogout});

  final VoidCallback? onLogout;

  static const prefKey = 'monthly_budget_usd';

  @override
  State<BudgetPage> createState() => _BudgetPageState();
}

class _BudgetPageState extends State<BudgetPage> {
  double? _budgetUsd;
  Stream<_Snap>? _stream;
  final _rateCtrl = TextEditingController();
  bool _rateSeeded = false;
  static final _dateFmt = DateFormat('dd/MM HH:mm');

  @override
  void initState() {
    super.initState();
    _loadBudget();
  }

  @override
  void dispose() {
    _rateCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadBudget() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) setState(() => _budgetUsd = prefs.getDouble(BudgetPage.prefKey));
  }

  Future<void> _setBudget(double? usd) async {
    final prefs = await SharedPreferences.getInstance();
    if (usd == null) {
      await prefs.remove(BudgetPage.prefKey);
    } else {
      await prefs.setDouble(BudgetPage.prefKey, usd);
    }
    if (mounted) setState(() => _budgetUsd = usd);
  }

  Future<void> _editBudget() async {
    final rates = AppScope.of(context).rates;
    final rate = rates.usdToBs;
    final initial = _budgetUsd;
    final ctrl = TextEditingController(text: initial?.toStringAsFixed(2) ?? '');
    var inBs = false;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setD) => AlertDialog(
          title: const Text('Presupuesto mensual'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SegmentedButton<bool>(
                showSelectedIcon: false,
                segments: const [
                  ButtonSegment(value: false, label: Text('USD')),
                  ButtonSegment(value: true, label: Text('Bs')),
                ],
                selected: {inBs},
                onSelectionChanged: rate == null
                    ? null
                    : (s) {
                        // Keep the same amount when switching currency.
                        final v = double.tryParse(ctrl.text.replaceAll(',', '.'));
                        if (v != null) {
                          ctrl.text = (inBs ? v / rate : v * rate)
                              .toStringAsFixed(2);
                        }
                        setD(() => inBs = s.first);
                      },
              ),
              const SizedBox(height: 12),
              TextField(
                controller: ctrl,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: inBs ? 'Monto (Bs)' : 'Monto (USD)',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text('Cancelar')),
            FilledButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text('Guardar')),
          ],
        ),
      ),
    );
    if (ok != true) return;
    final v = double.tryParse(ctrl.text.replaceAll(',', '.'));
    if (v == null || v <= 0) {
      await _setBudget(null);
      return;
    }
    // Store USD; convert from Bs with the active rate.
    final usd = inBs ? (rate == null ? null : v / rate) : v;
    await _setBudget(usd);
  }

  Future<void> _saveRate(ExchangeRateService rates) async {
    final v = double.tryParse(_rateCtrl.text.replaceAll(',', '.'));
    await rates.setManualUsdToBs(v);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(v == null
              ? 'Tasa oficial BCV restablecida'
              : 'Tasa manual guardada'),
        ),
      );
    }
  }

  Future<void> _useOfficial(ExchangeRateService rates) async {
    await rates.setManualUsdToBs(null);
    _rateCtrl.text = rates.usdToBs?.toStringAsFixed(2) ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final scope = AppScope.of(context);
    final repo = scope.repo;
    final rates = scope.rates;
    _stream ??= combineLatest3(
      repo.watchHistory(),
      repo.watchActiveLists(),
      repo.watchAllItems(),
      (List<PurchaseHistory> h, List<ShoppingList> l, List<ListItem> i) =>
          (h, l, i),
    );
    if (!_rateSeeded && rates.usdToBs != null) {
      _rateSeeded = true;
      _rateCtrl.text = rates.usdToBs!.toStringAsFixed(2);
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Presupuesto'),
        actions: [
          IconButton(
            tooltip: 'Editar presupuesto',
            icon: const Icon(Icons.edit_outlined),
            onPressed: _editBudget,
          ),
          AppMenuButton(onLogout: widget.onLogout),
        ],
      ),
      body: ListenableBuilder(
        listenable: rates,
        builder: (context, _) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _rateCard(context, rates),
            const SizedBox(height: 16),
            StreamBuilder<_Snap>(
              stream: _stream,
              builder: (context, snap) {
                if (snap.hasError) {
                  return Text('Error: ${snap.error}');
                }
                if (!snap.hasData) {
                  return const Padding(
                    padding: EdgeInsets.all(24),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                final (history, lists, items) = snap.data!;
                final now = DateTime.now();
                final monthStart = DateTime(now.year, now.month);
                final monthEnd = DateTime(now.year, now.month + 1);
                final thisMonth = history.where((h) {
                  final d = h.purchasedAt.toLocal();
                  return !d.isBefore(monthStart) && d.isBefore(monthEnd);
                }).toList();
                final spent =
                    thisMonth.fold<double>(0, (s, h) => s + h.total);
                final activeIds = lists.map((l) => l.id).toSet();
                final inCart = items
                    .where((i) =>
                        i.status == 'in_cart' &&
                        activeIds.contains(i.shoppingListId))
                    .fold<double>(0, (s, i) => s + itemCost(i));
                return _budgetBody(context, spent, inCart, thisMonth);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _rateCard(BuildContext context, ExchangeRateService rates) {
    final theme = Theme.of(context);
    final muted = theme.textTheme.labelSmall
        ?.copyWith(color: theme.colorScheme.onSurfaceVariant);
    final isManual = rates.usdManual != null;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: AppTheme.cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Tasa de cambio (Bs por USD)',
              style: theme.textTheme.titleSmall),
          const SizedBox(height: 4),
          Text(
            rates.usdOfficial == null
                ? 'BCV oficial: sin datos (usa Ajustes > Actualizar)'
                : 'BCV oficial: ${rates.usdOfficial!.toStringAsFixed(2)}'
                    '${isManual ? ' · manual activa' : ''}',
            style: muted,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _rateCtrl,
            keyboardType:
                const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              labelText: 'Tasa (editable)',
              suffixText: 'Bs',
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: rates.usdOfficial == null
                      ? null
                      : () => _useOfficial(rates),
                  child: const Text('Usar BCV'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton(
                  onPressed: () => _saveRate(rates),
                  child: const Text('Guardar tasa'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _budgetBody(
    BuildContext context,
    double spent,
    double inCart,
    List<PurchaseHistory> thisMonth,
  ) {
    final theme = Theme.of(context);
    final budget = _budgetUsd;
    if (budget == null) {
      return Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Define un presupuesto mensual',
                style: theme.textTheme.titleMedium),
            const SizedBox(height: 12),
            FilledButton(
                onPressed: _editBudget, child: const Text('Definir monto')),
          ],
        ),
      );
    }
    final over = spent > budget;
    final ratio = (spent / budget).clamp(0.0, 1.0).toDouble();
    final available = budget - spent - inCart;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(18),
          decoration: AppTheme.cardDecoration(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Presupuesto mensual', style: theme.textTheme.labelMedium),
              const SizedBox(height: 4),
              MoneyText(budget,
                  style: theme.textTheme.headlineSmall
                      ?.copyWith(fontWeight: FontWeight.w800)),
              const SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: LinearProgressIndicator(
                  value: ratio,
                  minHeight: 10,
                  backgroundColor: AppTheme.ink700,
                  color: over ? theme.colorScheme.error : AppTheme.sage,
                ),
              ),
              const SizedBox(height: 16),
              _row(context, 'Gastado este mes', spent),
              _row(context, 'Restante', budget - spent,
                  danger: budget - spent < 0),
              _row(context, 'En carrito (listas activas)', inCart),
              const Divider(height: 24),
              _row(context, 'Disponible tras carrito', available,
                  danger: available < 0, bold: true),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Text('Compras de este mes', style: theme.textTheme.titleSmall),
        const SizedBox(height: 8),
        if (thisMonth.isEmpty)
          Text('Sin compras finalizadas', style: theme.textTheme.bodySmall)
        else
          for (final h in thisMonth)
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(_dateFmt.format(h.purchasedAt.toLocal())),
              trailing: MoneyText(h.total,
                  compact: true,
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(fontWeight: FontWeight.w600)),
            ),
      ],
    );
  }

  Widget _row(BuildContext context, String label, double usd,
      {bool danger = false, bool bold = false}) {
    final theme = Theme.of(context);
    final color = danger ? theme.colorScheme.error : null;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(label,
                style: theme.textTheme.bodyMedium?.copyWith(
                    color: color,
                    fontWeight: bold ? FontWeight.w700 : FontWeight.w400)),
          ),
          MoneyText(usd,
              textAlign: TextAlign.end,
              style: theme.textTheme.bodyMedium?.copyWith(
                  color: color,
                  fontWeight: bold ? FontWeight.w700 : FontWeight.w600)),
        ],
      ),
    );
  }
}
