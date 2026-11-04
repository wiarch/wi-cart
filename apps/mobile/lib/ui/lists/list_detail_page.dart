import 'dart:io';

import 'package:flutter/material.dart';

import '../../app_scope.dart';
import '../../data/database.dart';
import '../theme/app_theme.dart';
import '../widgets/category_style.dart';
import '../widgets/money_text.dart';
import '../widgets/soft_card.dart';
import 'add_item_sheet.dart';

class ListDetailPage extends StatefulWidget {
  const ListDetailPage({
    super.key,
    required this.listId,
    required this.listName,
  });

  final String listId;
  final String listName;

  @override
  State<ListDetailPage> createState() => _ListDetailPageState();
}

class _ListDetailPageState extends State<ListDetailPage> {
  bool _cartExpanded = true;
  Map<String, Product> _products = {};
  Map<String, Category> _categories = {};

  static const _uncategorizedKey = '__none__';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      await AppScope.of(context).repo.rememberLastList(widget.listId);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadLookups();
  }

  Future<void> _loadLookups() async {
    final repo = AppScope.of(context).repo;
    final products = await repo.getProducts();
    final cats = await repo.getCategories();
    if (!mounted) return;
    setState(() {
      _products = {for (final p in products) p.id: p};
      _categories = {for (final c in cats) c.id: c};
    });
  }

  String _categoryKey(ListItem item) {
    final product =
        item.productId != null ? _products[item.productId] : null;
    final id = product?.categoryId;
    if (id != null && _categories.containsKey(id)) return id;
    return _uncategorizedKey;
  }

  Category? _categoryForKey(String key) =>
      key == _uncategorizedKey ? null : _categories[key];

  double _lineCost(ListItem i) {
    final qty =
        i.status == 'in_cart' ? (i.qtyBought ?? i.qtyPlanned) : i.qtyPlanned;
    return qty * (i.unitPrice ?? 0);
  }

  @override
  Widget build(BuildContext context) {
    final repo = AppScope.of(context).repo;
    return StreamBuilder<List<ListItem>>(
      stream: repo.watchItems(widget.listId),
      builder: (context, snap) {
        final items = snap.data ?? [];
        final pending = items.where((i) => i.status == 'pending').toList();
        final cart = items.where((i) => i.status == 'in_cart').toList();

        final listTotal = items.fold<double>(0, (s, i) => s + _lineCost(i));
        final cartTotal = cart.fold<double>(0, (s, i) => s + _lineCost(i));

        final byCatAll = <String, List<ListItem>>{};
        for (final i in items) {
          byCatAll.putIfAbsent(_categoryKey(i), () => []).add(i);
        }
        final pendingByCat = <String, List<ListItem>>{};
        for (final i in pending) {
          pendingByCat.putIfAbsent(_categoryKey(i), () => []).add(i);
        }
        final catKeys = pendingByCat.keys.toList()
          ..sort((a, b) {
            if (a == _uncategorizedKey) return 1;
            if (b == _uncategorizedKey) return -1;
            final na = _categoryForKey(a)?.name ?? '';
            final nb = _categoryForKey(b)?.name ?? '';
            return na.compareTo(nb);
          });

        return Scaffold(
          backgroundColor: AppTheme.bg,
          appBar: AppBar(
            title: Text(widget.listName),
            actions: [
              IconButton(
                tooltip: 'Limpiar carrito',
                icon: const Icon(Icons.remove_shopping_cart_outlined),
                onPressed: () => _clearCart(context),
              ),
              PopupMenuButton<String>(
                onSelected: (v) async {
                  if (!mounted) return;
                  if (v == 'clone') {
                    await _clone(context);
                  } else if (v == 'finalize') {
                    await _finalize(context);
                  }
                },
                itemBuilder: (_) => const [
                  PopupMenuItem(value: 'clone', child: Text('Clonar lista')),
                  PopupMenuItem(
                      value: 'finalize', child: Text('Finalizar compra')),
                ],
              ),
            ],
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: FloatingActionButton(
            onPressed: () => _addItem(context),
            tooltip: 'Agregar',
            child: const Icon(Icons.add, size: 28),
          ),
          bottomNavigationBar: BottomAppBar(
            shape: const CircularNotchedRectangle(),
            notchMargin: 8,
            height: 78,
            color: Colors.white,
            elevation: 16,
            shadowColor: Colors.black26,
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Row(
              children: [
                Expanded(
                  child: _TotalBlock(
                    label: 'Total Lista',
                    count: items.length,
                    amount: listTotal,
                    alignEnd: false,
                  ),
                ),
                const SizedBox(width: 72),
                Expanded(
                  child: _TotalBlock(
                    label: 'Total Carrito',
                    count: cart.length,
                    amount: cartTotal,
                    alignEnd: true,
                  ),
                ),
              ],
            ),
          ),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(0, 4, 0, 28),
            children: [
              for (final catKey in catKeys) ...[
                _categoryHeader(
                  context,
                  _categoryForKey(catKey),
                  byCatAll[catKey] ?? const [],
                ),
                for (final item in pendingByCat[catKey]!)
                  _itemCard(context, item, inCart: false),
              ],
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                child: Row(
                  children: [
                    Text(
                      'En el carrito',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppTheme.field,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        '${cart.length}',
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () =>
                          setState(() => _cartExpanded = !_cartExpanded),
                      child: Text(_cartExpanded ? 'Ocultar' : 'Mostrar'),
                    ),
                  ],
                ),
              ),
              if (_cartExpanded)
                if (cart.isEmpty)
                  SoftCard(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      'Vacío',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurfaceVariant,
                          ),
                    ),
                  )
                else
                  for (final item in cart)
                    _itemCard(context, item, inCart: true),
            ],
          ),
        );
      },
    );
  }

  Widget _categoryHeader(
      BuildContext context, Category? category, List<ListItem> allInCat) {
    final listSum = allInCat.fold<double>(0, (s, i) => s + _lineCost(i));
    final cartSum = allInCat
        .where((i) => i.status == 'in_cart')
        .fold<double>(0, (s, i) => s + _lineCost(i));
    final name = category?.name ?? 'Sin categoría';
    final color = CategoryStyle.parseColor(category?.color) ??
        const Color(0xFF9E9E9E);
    final icon = CategoryStyle.iconFor(category?.icon);

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 6),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 22, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.2,
                      ),
                ),
                const SizedBox(height: 2),
                ListenableBuilder(
                  listenable: AppScope.of(context).rates,
                  builder: (context, _) {
                    final rates = AppScope.of(context).rates;
                    final listLabel = formatUsd(listSum);
                    final cartLabel = formatUsd(cartSum);
                    final bsList = rates.toBs(listSum);
                    final bsCart = rates.toBs(cartSum);
                    final extra = StringBuffer(
                        'Lista: $listLabel · Carrito: $cartLabel');
                    if (bsList != null && bsCart != null) {
                      extra.write(
                          '\n${formatBs(bsList)} · ${formatBs(bsCart)}');
                    }
                    return Text(
                      extra.toString(),
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurfaceVariant,
                            height: 1.35,
                          ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _itemCard(BuildContext context, ListItem item,
      {required bool inCart}) {
    final repo = AppScope.of(context).repo;
    final qty = inCart ? (item.qtyBought ?? item.qtyPlanned) : item.qtyPlanned;
    final abbr = item.unitAbbr ?? 'un';
    final qtyLabel =
        qty % 1 == 0 ? qty.toStringAsFixed(0) : qty.toStringAsFixed(2);
    final price = item.unitPrice ?? 0;
    final product =
        item.productId != null ? _products[item.productId] : null;
    final category = product?.categoryId != null
        ? _categories[product!.categoryId]
        : null;
    final catColor = CategoryStyle.parseColor(category?.color) ??
        const Color(0xFF9E9E9E);
    final catIcon = CategoryStyle.iconFor(category?.icon);
    final rates = AppScope.of(context).rates;

    return SoftCard(
      padding: const EdgeInsets.fromLTRB(12, 10, 8, 10),
      child: Row(
        children: [
          _leading(product?.localImagePath, catColor, catIcon),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    letterSpacing: -0.1,
                  ),
                ),
                const SizedBox(height: 2),
                ListenableBuilder(
                  listenable: rates,
                  builder: (_, __) => Text(
                    '$qtyLabel $abbr · ${formatUsd(price)}'
                    '${rates.toBs(price) != null ? ' · ${formatBs(rates.toBs(price)!)}' : ''}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurfaceVariant,
                        ),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            visualDensity: VisualDensity.compact,
            icon: const Icon(Icons.edit_outlined, size: 20),
            onPressed: () => _editQty(context, item),
          ),
          IconButton(
            visualDensity: VisualDensity.compact,
            icon: Icon(
              Icons.delete_outline,
              size: 20,
              color: Theme.of(context).colorScheme.error.withValues(alpha: 0.8),
            ),
            onPressed: () async {
              final sync = AppScope.of(context).sync;
              await repo.deleteItem(item.id);
              await sync.syncNow();
            },
          ),
          Checkbox(
            value: inCart,
            onChanged: (_) async {
              final sync = AppScope.of(context).sync;
              await repo.setItemStatus(
                  item, inCart ? 'pending' : 'in_cart');
              await sync.syncNow();
            },
          ),
        ],
      ),
    );
  }

  Widget _leading(String? path, Color color, IconData icon) {
    if (path != null && File(path).existsSync()) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child:
            Image.file(File(path), width: 48, height: 48, fit: BoxFit.cover),
      );
    }
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, color: color, size: 24),
    );
  }

  Future<void> _clearCart(BuildContext context) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Limpiar carrito'),
        content: const Text(
            'Mueve todos los ítems del carrito a Pendiente.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancelar')),
          FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Limpiar')),
        ],
      ),
    );
    if (ok != true || !context.mounted) return;
    final scope = AppScope.of(context);
    await scope.repo.clearCart(widget.listId);
    await scope.sync.syncNow();
  }

  Future<void> _clone(BuildContext context) async {
    final scope = AppScope.of(context);
    final clone = await scope.repo.cloneList(widget.listId);
    await scope.sync.syncNow();
    if (!context.mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) =>
            ListDetailPage(listId: clone.id, listName: clone.name),
      ),
    );
  }

  Future<void> _finalize(BuildContext context) async {
    final repo = AppScope.of(context).repo;
    final list = await repo.getList(widget.listId);
    final storeCtrl =
        TextEditingController(text: list?.storeLocation ?? '');
    if (!context.mounted) return;

    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Finalizar compra'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Confirma la tienda/ubicación del ticket.',
              style: Theme.of(ctx).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(ctx).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: storeCtrl,
              autofocus: true,
              decoration: const InputDecoration(
                labelText: 'Tienda / ubicación',
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
              child: const Text('Finalizar')),
        ],
      ),
    );
    if (ok != true || !context.mounted) return;
    final store = storeCtrl.text.trim();
    if (store.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Indica la tienda')),
      );
      return;
    }
    try {
      final scope = AppScope.of(context);
      await repo.finalizePurchase(widget.listId, storeLocation: store);
      await repo.rememberLastList(null);
      await scope.sync.syncNow();
      if (context.mounted) Navigator.pop(context);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }

  Future<void> _addItem(BuildContext context) async {
    final scope = AppScope.of(context);
    final result = await showAddItemSheet(context: context, repo: scope.repo);
    if (result == null || !context.mounted) return;
    await scope.repo.addItemSmart(
      listId: widget.listId,
      name: result.name,
      productId: result.productId,
      unitId: result.unitId,
      unitAbbr: result.unitAbbr,
      categoryId: result.categoryId,
      qtyPlanned: result.qty,
      unitPrice: result.unitPrice,
    );
    await scope.sync.syncNow();
    await _loadLookups();
  }

  Future<void> _editQty(BuildContext context, ListItem item) async {
    final qty = TextEditingController(
        text: (item.status == 'in_cart'
                ? (item.qtyBought ?? item.qtyPlanned)
                : item.qtyPlanned)
            .toString());
    final price =
        TextEditingController(text: (item.unitPrice ?? 0).toStringAsFixed(2));
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(item.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
                controller: qty,
                decoration: const InputDecoration(labelText: 'Cantidad')),
            const SizedBox(height: 12),
            TextField(
                controller: price,
                decoration: const InputDecoration(
                    labelText: 'Precio unitario (USD)')),
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
    );
    if (ok != true || !context.mounted) return;
    final scope = AppScope.of(context);
    final q = double.tryParse(qty.text.replaceAll(',', '.'));
    final p = double.tryParse(price.text.replaceAll(',', '.'));
    await scope.repo.updateItemQty(
      item: item,
      qtyPlanned: item.status == 'pending' ? q : null,
      qtyBought: item.status == 'in_cart' ? q : null,
      unitPrice: p,
    );
    await scope.sync.syncNow();
  }
}

class _TotalBlock extends StatelessWidget {
  const _TotalBlock({
    required this.label,
    required this.count,
    required this.amount,
    required this.alignEnd,
  });

  final String label;
  final int count;
  final double amount;
  final bool alignEnd;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment:
          alignEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(
          '$label · $count',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
        MoneyText(
          amount,
          textAlign: alignEnd ? TextAlign.end : TextAlign.start,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
                letterSpacing: -0.2,
              ),
        ),
      ],
    );
  }
}
