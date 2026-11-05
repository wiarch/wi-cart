import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

import '../../app_scope.dart';
import '../../data/database.dart';
import '../../utils/quantity_math.dart';
import '../../utils/spend_math.dart';
import '../theme/app_theme.dart';
import '../widgets/category_style.dart';
import '../widgets/money_text.dart';
import '../widgets/search_field.dart';
import '../widgets/soft_card.dart';
import '../widgets/add_fab.dart';
import '../widgets/icon_picker.dart';
import 'add_item_sheet.dart';
import 'list_spend_page.dart';

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
  bool _searchOpen = false;
  bool _cartPulse = false;
  /// Category keys currently expanded. Missing key ⇒ expanded by default.
  final Set<String> _collapsedCats = {};
  /// Category key selected in the filter chips; null ⇒ show all.
  String? _filterKey;
  /// Item ids playing "fly to cart" / "return" animation.
  final Set<String> _flyingIds = {};
  final _searchCtrl = TextEditingController();
  final _searchFocus = FocusNode();
  final _listScroll = ScrollController();
  final _cartSectionKey = GlobalKey();
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
  void dispose() {
    _searchCtrl.dispose();
    _searchFocus.dispose();
    _listScroll.dispose();
    super.dispose();
  }

  Future<void> _scrollToCart() async {
    setState(() => _cartExpanded = true);
    await Future<void>.delayed(const Duration(milliseconds: 40));
    if (!mounted) return;
    final ctx = _cartSectionKey.currentContext;
    if (ctx == null) return;
    await Scrollable.ensureVisible(
      ctx,
      duration: const Duration(milliseconds: 420),
      curve: Curves.easeInOutCubic,
      alignment: 0.08,
    );
    if (!mounted) return;
    setState(() => _cartPulse = true);
    Future<void>.delayed(const Duration(milliseconds: 700), () {
      if (mounted) setState(() => _cartPulse = false);
    });
  }

  void _toggleSearch() {
    setState(() {
      _searchOpen = !_searchOpen;
      if (!_searchOpen) {
        _searchCtrl.clear();
        _searchFocus.unfocus();
      }
    });
    if (_searchOpen) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _searchFocus.requestFocus();
      });
    }
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

  int _compareKeys(String a, String b) {
    if (a == _uncategorizedKey) return 1;
    if (b == _uncategorizedKey) return -1;
    final na = _categoryForKey(a)?.name ?? '';
    final nb = _categoryForKey(b)?.name ?? '';
    return na.compareTo(nb);
  }

  bool _isCatExpanded(String key) => !_collapsedCats.contains(key);

  void _toggleCat(String key) {
    setState(() {
      if (_collapsedCats.contains(key)) {
        _collapsedCats.remove(key);
      } else {
        _collapsedCats.add(key);
      }
    });
  }

  double _lineCost(ListItem i) => itemCost(i);

  @override
  Widget build(BuildContext context) {
    final repo = AppScope.of(context).repo;
    return StreamBuilder<List<ListItem>>(
      stream: repo.watchItems(widget.listId),
      builder: (context, snap) {
        final items = snap.data ?? [];
        final query = searchQuery(_searchCtrl);
        bool matches(ListItem i) => matchesQuery(query, [i.name]);
        final pending = items
            .where((i) => i.status == 'pending' && matches(i))
            .toList();
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
        final catKeys = pendingByCat.keys.toList()..sort(_compareKeys);
        final filterKeys = byCatAll.keys.toList()..sort(_compareKeys);
        final visibleCart = cart
            .where((i) =>
                (_filterKey == null || _categoryKey(i) == _filterKey) &&
                matches(i))
            .toList();

        return Scaffold(
          backgroundColor: AppTheme.bg,
          appBar: AppBar(
            title: Text(widget.listName),
            actions: [
              IconButton(
                tooltip: _searchOpen ? 'Cerrar búsqueda' : 'Buscar',
                icon: Icon(_searchOpen ? Icons.search_off : Icons.search),
                onPressed: _toggleSearch,
              ),
              PopupMenuButton<String>(
                onSelected: (v) async {
                  if (!mounted) return;
                  if (v == 'spend') {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ListSpendPage(
                          listId: widget.listId,
                          listName: widget.listName,
                        ),
                      ),
                    );
                  } else if (v == 'clear_cart') {
                    await _clearCart(context);
                  } else if (v == 'clone') {
                    await _clone(context);
                  } else if (v == 'finalize') {
                    await _finalize(context);
                  } else if (v == 'icon') {
                    final list = await repo.getList(widget.listId);
                    if (!context.mounted) return;
                    final sync = AppScope.of(context).sync;
                    final key =
                        await showIconPicker(context, current: list?.icon);
                    if (key == null) return;
                    await repo.setListIcon(widget.listId, key);
                    await sync.syncNow();
                  }
                },
                itemBuilder: (_) => const [
                  PopupMenuItem(
                    value: 'spend',
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(Icons.pie_chart_outline),
                      title: Text('Gastos por categoría'),
                    ),
                  ),
                  PopupMenuItem(
                    value: 'clear_cart',
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(Icons.remove_shopping_cart_outlined),
                      title: Text('Limpiar carrito'),
                    ),
                  ),
                  PopupMenuDivider(),
                  PopupMenuItem(value: 'clone', child: Text('Clonar lista')),
                  PopupMenuItem(value: 'icon', child: Text('Cambiar icono')),
                  PopupMenuItem(
                      value: 'finalize', child: Text('Finalizar compra')),
                ],
              ),
            ],
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          floatingActionButton: AddFab(onPressed: () => _addItem(context)),
          bottomNavigationBar: BottomAppBar(
            height: 78,
            color: AppTheme.surface,
            elevation: 16,
            shadowColor: Colors.black54,
            padding: const EdgeInsets.symmetric(horizontal: 10),
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: FilledButton.tonal(
                    onPressed: cart.isEmpty ? null : _scrollToCart,
                    style: FilledButton.styleFrom(
                      backgroundColor: AppTheme.sage.withValues(alpha: 0.35),
                      foregroundColor: AppTheme.ink700,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10),
                      minimumSize: const Size(0, 40),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text(
                      'Ver carrito',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
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
          body: Column(
            children: [
              if (_searchOpen)
                Material(
                  color: AppTheme.surface,
                  elevation: 1,
                  child: SearchField(
                    controller: _searchCtrl,
                    focusNode: _searchFocus,
                    autofocus: true,
                    hint: 'Buscar en la lista',
                    onChanged: () => setState(() {}),
                  ),
                ),
              Expanded(
                child: ListView(
                  controller: _listScroll,
                  padding: const EdgeInsets.fromLTRB(0, 8, 0, 28),
                  children: [
                    _ProgressHeader(done: cart.length, total: items.length),
                    _CategoryFilter(
                      keys: filterKeys,
                      labelFor: (k) =>
                          _categoryForKey(k)?.name ?? 'Sin categoría',
                      colorFor: (k) =>
                          CategoryStyle.parseColor(
                              _categoryForKey(k)?.color) ??
                          const Color(0xFF9E9E9E),
                      selected: _filterKey,
                      onSelect: (k) => setState(() => _filterKey = k),
                    ),
                    for (final catKey in catKeys)
                      if (_filterKey == null || _filterKey == catKey)
                        _CategoryAccordion(
                          category: _categoryForKey(catKey),
                          allInCat: byCatAll[catKey] ?? const [],
                          pendingItems: pendingByCat[catKey]!,
                          expanded: _isCatExpanded(catKey),
                          onToggle: () => _toggleCat(catKey),
                          lineCost: _lineCost,
                          itemBuilder: (item) =>
                              _itemCard(context, item, inCart: false),
                        ),
                    KeyedSubtree(
                      key: _cartSectionKey,
                      child: _CartSection(
                        count: cart.length,
                        expanded: _cartExpanded,
                        pulse: _cartPulse,
                        onToggle: () =>
                            setState(() => _cartExpanded = !_cartExpanded),
                        onDeleteAll: cart.isEmpty
                            ? null
                            : () => _deleteCompleted(context, cart),
                        child: !_cartExpanded
                            ? const SizedBox.shrink()
                            : visibleCart.isEmpty
                                ? SoftCard(
                                    padding: const EdgeInsets.all(20),
                                    child: Text(
                                      'Vacío',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurfaceVariant,
                                          ),
                                    ),
                                  )
                                : Column(
                                    children: [
                                      for (final item in visibleCart)
                                        _itemCard(context, item, inCart: true),
                                    ],
                                  ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
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

    final flying = _flyingIds.contains(item.id);
    final toCart = !inCart;

    Future<void> toggleCart() async {
      if (_flyingIds.contains(item.id)) return;
      final sync = AppScope.of(context).sync;
      final messenger = ScaffoldMessenger.of(context);
      setState(() => _flyingIds.add(item.id));
      await Future<void>.delayed(const Duration(milliseconds: 280));
      if (!mounted) return;
      if (toCart) {
        setState(() {
          _cartExpanded = true;
          _cartPulse = true;
        });
      }
      await repo.setItemStatus(item, inCart ? 'pending' : 'in_cart');
      if (!mounted) return;
      setState(() => _flyingIds.remove(item.id));
      if (toCart) {
        messenger.clearSnackBars();
        messenger.showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.shopping_cart_checkout,
                    color: AppTheme.mint, size: 18),
                const SizedBox(width: 10),
                Expanded(child: Text('${item.name} → carrito')),
              ],
            ),
            duration: const Duration(milliseconds: 1400),
          ),
        );
        Future<void>.delayed(const Duration(milliseconds: 700), () {
          if (mounted) setState(() => _cartPulse = false);
        });
      }
      await sync.syncNow();
    }

    return AnimatedSlide(
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeInOutCubic,
      offset: flying
          ? (toCart ? const Offset(0, 0.55) : const Offset(0, -0.35))
          : Offset.zero,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeInOut,
        opacity: flying ? 0.0 : 1.0,
        child: AnimatedScale(
          duration: const Duration(milliseconds: 280),
          curve: Curves.easeInOut,
          scale: flying ? 0.92 : 1.0,
          child: SoftCard(
            color: inCart ? AppTheme.sage.withValues(alpha: 0.28) : null,
            padding: const EdgeInsets.fromLTRB(12, 6, 4, 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _leading(
                  product?.localImagePath,
                  catColor,
                  catIcon,
                  onTap: () => _previewImage(
                    context,
                    path: product?.localImagePath,
                    name: item.name,
                    color: catColor,
                    icon: catIcon,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: toggleCart,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                                letterSpacing: -0.1,
                                color: inCart ? AppTheme.ink800 : null,
                                decoration: inCart
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                                decorationColor: AppTheme.ink700,
                              ),
                            ),
                            const SizedBox(height: 2),
                            ListenableBuilder(
                              listenable: rates,
                              builder: (_, __) => Text(
                                '$qtyLabel $abbr · ${formatUsd(price)}/${basePriceLabel(item.unitAbbr)}'
                                '${rates.toBs(price) != null ? ' · ${formatBs(rates.toBs(price)!)}' : ''}',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                PopupMenuButton<String>(
                  tooltip: 'Más',
                  padding: EdgeInsets.zero,
                  icon: const Icon(Icons.more_vert, size: 20),
                  onSelected: (v) async {
                    if (v == 'edit') {
                      await _editQty(context, item);
                      return;
                    }
                    if (v == 'delete') {
                      final sync = AppScope.of(context).sync;
                      await repo.deleteItem(item.id);
                      await sync.syncNow();
                    }
                  },
                  itemBuilder: (_) => [
                    const PopupMenuItem(
                      value: 'edit',
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Icon(Icons.edit_outlined),
                        title: Text('Editar'),
                      ),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Icon(
                          Icons.delete_outline,
                          color: Theme.of(context).colorScheme.error,
                        ),
                        title: Text(
                          'Eliminar',
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.error),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _leading(
    String? path,
    Color color,
    IconData icon, {
    VoidCallback? onTap,
  }) {
    Widget thumb;
    if (!kIsWeb && path != null && path.isNotEmpty) {
      try {
        final file = File(path);
        if (file.existsSync()) {
          thumb = ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.file(file, width: 48, height: 48, fit: BoxFit.cover),
          );
        } else {
          thumb = _placeholderThumb(color, icon);
        }
      } catch (_) {
        thumb = _placeholderThumb(color, icon);
      }
    } else {
      thumb = _placeholderThumb(color, icon);
    }
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: thumb,
      ),
    );
  }

  Widget _placeholderThumb(Color color, IconData icon) {
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

  Future<void> _previewImage(
    BuildContext context, {
    required String? path,
    required String name,
    required Color color,
    required IconData icon,
  }) async {
    Widget body;
    if (!kIsWeb && path != null && path.isNotEmpty) {
      try {
        final file = File(path);
        if (file.existsSync()) {
          body = InteractiveViewer(
            child: Image.file(file, fit: BoxFit.contain),
          );
        } else {
          body = Icon(icon, size: 96, color: color);
        }
      } catch (_) {
        body = Icon(icon, size: 96, color: color);
      }
    } else {
      body = Icon(icon, size: 96, color: color);
    }

    await showDialog<void>(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: AppTheme.card,
        insetPadding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 4, 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      name,
                      style: Theme.of(ctx).textTheme.titleMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
            ),
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.sizeOf(ctx).height * 0.55,
                maxWidth: MediaQuery.sizeOf(ctx).width,
              ),
              child: ColoredBox(
                color: color.withValues(alpha: 0.08),
                child: Center(child: body),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
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

  Future<void> _deleteCompleted(
      BuildContext context, List<ListItem> cart) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar comprados'),
        content: Text('Elimina ${cart.length} ítems del carrito.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancelar')),
          FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Eliminar')),
        ],
      ),
    );
    if (ok != true || !context.mounted) return;
    final scope = AppScope.of(context);
    for (final item in cart) {
      await scope.repo.deleteItem(item.id);
    }
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
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Finalizar compra'),
        content: const Text('Se guardará el carrito en el historial.'),
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
    try {
      final scope = AppScope.of(context);
      await repo.finalizePurchase(widget.listId);
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
      description: result.note,
      localImagePath: result.imagePath,
      addToCart: result.addToCart,
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

/// Collapsible category block: header bar + animated product list.
class _CategoryAccordion extends StatelessWidget {
  const _CategoryAccordion({
    required this.category,
    required this.allInCat,
    required this.pendingItems,
    required this.expanded,
    required this.onToggle,
    required this.lineCost,
    required this.itemBuilder,
  });

  final Category? category;
  final List<ListItem> allInCat;
  final List<ListItem> pendingItems;
  final bool expanded;
  final VoidCallback onToggle;
  final double Function(ListItem) lineCost;
  final Widget Function(ListItem) itemBuilder;

  @override
  Widget build(BuildContext context) {
    final listSum = allInCat.fold<double>(0, (s, i) => s + lineCost(i));
    final cartSum = allInCat
        .where((i) => i.status == 'in_cart')
        .fold<double>(0, (s, i) => s + lineCost(i));
    final name = category?.name ?? 'Sin categoría';
    final color =
        CategoryStyle.parseColor(category?.color) ?? const Color(0xFF9E9E9E);
    final icon = CategoryStyle.iconFor(category?.icon);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onToggle,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 12, 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                          style:
                              Theme.of(context).textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: -0.2,
                                  ),
                        ),
                        const SizedBox(height: 3),
                        ListenableBuilder(
                          listenable: AppScope.of(context).rates,
                          builder: (context, _) {
                            final rates = AppScope.of(context).rates;
                            final bsList = rates.toBs(listSum);
                            final bsCart = rates.toBs(cartSum);
                            final line1 =
                                'Lista: ${formatUsd(listSum)}${bsList != null ? ' (${formatBs(bsList)})' : ''}';
                            final line2 =
                                'Carrito: ${formatUsd(cartSum)}${bsCart != null ? ' (${formatBs(bsCart)})' : ''}';
                            return Text(
                              '$line1 · $line2',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall
                                  ?.copyWith(
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
                  const SizedBox(width: 4),
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: AnimatedRotation(
                      turns: expanded ? 0.5 : 0,
                      duration: const Duration(milliseconds: 200),
                      child: Icon(
                        Icons.keyboard_arrow_down,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        AnimatedCrossFade(
          firstChild: Column(
            children: [
              for (final item in pendingItems) itemBuilder(item),
            ],
          ),
          secondChild: const SizedBox(width: double.infinity),
          crossFadeState: expanded
              ? CrossFadeState.showFirst
              : CrossFadeState.showSecond,
          duration: const Duration(milliseconds: 220),
          sizeCurve: Curves.easeInOut,
        ),
      ],
    );
  }
}

class _CartSection extends StatelessWidget {
  const _CartSection({
    required this.count,
    required this.expanded,
    required this.pulse,
    required this.onToggle,
    required this.onDeleteAll,
    required this.child,
  });

  final int count;
  final bool expanded;
  final bool pulse;
  final VoidCallback onToggle;
  final VoidCallback? onDeleteAll;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 320),
          curve: Curves.easeOut,
          margin: const EdgeInsets.fromLTRB(12, 16, 12, 0),
          padding: const EdgeInsets.fromLTRB(8, 4, 0, 4),
          decoration: BoxDecoration(
            color: pulse
                ? AppTheme.sage.withValues(alpha: 0.35)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              AnimatedScale(
                duration: const Duration(milliseconds: 280),
                scale: pulse ? 1.12 : 1.0,
                child: Icon(
                  Icons.shopping_cart_outlined,
                  size: 18,
                  color: pulse ? AppTheme.ink700 : AppTheme.sage,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'En el carrito ($count)',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const Spacer(),
              if (onDeleteAll != null)
                IconButton(
                  visualDensity: VisualDensity.compact,
                  tooltip: 'Eliminar comprados',
                  icon: Icon(Icons.delete_sweep_outlined,
                      size: 20,
                      color: Theme.of(context).colorScheme.error),
                  onPressed: onDeleteAll,
                ),
              TextButton(
                onPressed: onToggle,
                child: Text(expanded ? 'Ocultar' : 'Mostrar'),
              ),
            ],
          ),
        ),
        AnimatedCrossFade(
          firstChild: child,
          secondChild: const SizedBox(width: double.infinity),
          crossFadeState: expanded
              ? CrossFadeState.showFirst
              : CrossFadeState.showSecond,
          duration: const Duration(milliseconds: 220),
          sizeCurve: Curves.easeInOut,
        ),
      ],
    );
  }
}

/// "X de Y comprados" with a purple progress bar.
class _ProgressHeader extends StatelessWidget {
  const _ProgressHeader({required this.done, required this.total});

  final int done;
  final int total;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Text(
                '$done de $total comprados',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: AppTheme.ink700,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Text(
                total == 0 ? '0%' : '${(done * 100 ~/ total)}%',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: AppTheme.ink800,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: total == 0 ? 0 : done / total,
              minHeight: 6,
              backgroundColor: AppTheme.ink700,
              valueColor: const AlwaysStoppedAnimation(AppTheme.sage),
            ),
          ),
        ],
      ),
    );
  }
}

/// Horizontal category chips; tapping the active chip clears the filter.
class _CategoryFilter extends StatelessWidget {
  const _CategoryFilter({
    required this.keys,
    required this.labelFor,
    required this.colorFor,
    required this.selected,
    required this.onSelect,
  });

  final List<String> keys;
  final String Function(String key) labelFor;
  final Color Function(String key) colorFor;
  final String? selected;
  final ValueChanged<String?> onSelect;

  @override
  Widget build(BuildContext context) {
    if (keys.length < 2) return const SizedBox.shrink();
    return SizedBox(
      height: 44,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        children: [
          for (final k in keys)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: Text(labelFor(k)),
                avatar: CircleAvatar(
                  radius: 5,
                  backgroundColor: colorFor(k),
                ),
                selected: selected == k,
                showCheckmark: false,
                selectedColor: AppTheme.sage.withValues(alpha: 0.22),
                onSelected: (on) => onSelect(on ? k : null),
              ),
            ),
        ],
      ),
    );
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
