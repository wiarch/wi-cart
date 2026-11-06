import 'dart:async';
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
import '../widgets/confirm_dialog.dart';
import '../widgets/icon_picker.dart';
import '../widgets/image_crop_page.dart';
import '../stores/store_dialogs.dart';
import 'add_item_sheet.dart';
import 'list_spend_page.dart';
import 'share_list_dialog.dart';

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
  String? _title;
  bool _cartExpanded = true;
  bool _searchOpen = false;
  bool _cartPulse = false;
  /// Category keys currently expanded. Missing key ⇒ expanded by default.
  final Set<String> _collapsedCats = {};
  /// Category key selected in the filter chips; null ⇒ show all.
  String? _filterKey;
  /// Item ids playing "fly to cart" / "return" animation.
  final Set<String> _flyingIds = {};
  /// Long-press multi-select. Empty ⇒ selection mode off.
  final Set<String> _selected = {};
  String? _cartToast;
  Timer? _cartToastTimer;
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
    _cartToastTimer?.cancel();
    _searchCtrl.dispose();
    _searchFocus.dispose();
    _listScroll.dispose();
    super.dispose();
  }

  void _showCartToast(String name) {
    _cartToastTimer?.cancel();
    setState(() => _cartToast = name);
    _cartToastTimer = Timer(const Duration(milliseconds: 1400), () {
      if (mounted) setState(() => _cartToast = null);
    });
  }

  Future<void> _scrollToCart() async {
    setState(() {
      _cartExpanded = true;
      _cartPulse = true;
    });
    // Wait for expand layout, then jump to cart (always last in ListView).
    await Future<void>.delayed(const Duration(milliseconds: 50));
    if (!mounted) return;
    await WidgetsBinding.instance.endOfFrame;
    if (!mounted || !_listScroll.hasClients) return;
    final target = _listScroll.position.maxScrollExtent;
    await _listScroll.animateTo(
      target,
      duration: const Duration(milliseconds: 420),
      curve: Curves.easeInOutCubic,
    );
    // Fallback if already near bottom / extent grew after expand.
    if (mounted && _listScroll.hasClients) {
      final ctx = _cartSectionKey.currentContext;
      if (ctx != null && ctx.mounted) {
        await Scrollable.ensureVisible(
          ctx,
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
          alignment: 0.05,
        );
      }
    }
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
            automaticallyImplyLeading: _selected.isEmpty,
            leading: _selected.isEmpty
                ? null
                : IconButton(
                    tooltip: 'Cancelar',
                    icon: const Icon(Icons.close),
                    onPressed: () => setState(() => _selected.clear()),
                  ),
            title: Text(
              _selected.isEmpty
                  ? (_title ?? widget.listName)
                  : '${_selected.length} seleccionados',
            ),
            actions: _selected.isNotEmpty
                ? const []
                : [
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
                  } else if (v == 'delete') {
                    await _deleteList(context);
                  } else if (v == 'edit') {
                    final list = await repo.getList(widget.listId);
                    if (!context.mounted || list == null) return;
                    final name = await listNameDialog(context, list.name);
                    if (name == null || !context.mounted) return;
                    final sync = AppScope.of(context).sync;
                    await repo.renameList(widget.listId, name);
                    await sync.syncNow();
                    if (mounted) setState(() => _title = name);
                  } else if (v == 'share') {
                    await shareListDialog(context, widget.listId);
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
                  PopupMenuItem(
                    value: 'edit',
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(Icons.edit_outlined),
                      title: Text('Editar'),
                    ),
                  ),
                  PopupMenuItem(
                    value: 'share',
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(Icons.share_outlined),
                      title: Text('Compartir lista'),
                    ),
                  ),
                  PopupMenuItem(
                    value: 'clone',
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(Icons.copy_outlined),
                      title: Text('Clonar lista'),
                    ),
                  ),
                  PopupMenuItem(
                    value: 'icon',
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(Icons.interests_outlined),
                      title: Text('Cambiar icono'),
                    ),
                  ),
                  PopupMenuItem(
                    value: 'finalize',
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(Icons.check_circle_outline),
                      title: Text('Finalizar compra'),
                    ),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(Icons.delete_outline),
                      title: Text('Eliminar lista'),
                    ),
                  ),
                ],
              ),
            ],
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          floatingActionButton: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 220),
                switchInCurve: Curves.easeOutCubic,
                switchOutCurve: Curves.easeInCubic,
                transitionBuilder: (child, anim) => FadeTransition(
                  opacity: anim,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0.15, 0),
                      end: Offset.zero,
                    ).animate(anim),
                    child: child,
                  ),
                ),
                child: _cartToast == null
                    ? const SizedBox.shrink(key: ValueKey('toast-off'))
                    : Material(
                        key: const ValueKey('toast-on'),
                        color: AppTheme.ink800,
                        elevation: 6,
                        shadowColor: AppTheme.ink800.withValues(alpha: 0.35),
                        borderRadius: BorderRadius.circular(28),
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 220),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 12),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.shopping_cart_checkout,
                                  color: AppTheme.mint,
                                  size: 18,
                                ),
                                const SizedBox(width: 8),
                                Flexible(
                                  child: Text(
                                    '$_cartToast → carrito',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: AppTheme.mint,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
              ),
              if (_cartToast != null) const SizedBox(width: 12),
              AddFab(onPressed: () => _addItem(context)),
            ],
          ),
          bottomNavigationBar: _selected.isNotEmpty
              ? BottomAppBar(
                  height: 78,
                  color: AppTheme.surface,
                  elevation: 16,
                  child: Row(
                    children: [
                      _BulkAction(
                        icon: Icons.delete_outline,
                        label: 'Eliminar',
                        onTap: () => _deleteSelected(items),
                      ),
                      _BulkAction(
                        icon: Icons.copy_outlined,
                        label: 'Copiar',
                        onTap: () => _copySelected(items),
                      ),
                      _BulkAction(
                        icon: Icons.add_shopping_cart_outlined,
                        label: 'Al carrito',
                        onTap: () => _cartSelected(items),
                      ),
                    ],
                  ),
                )
              : ListenableBuilder(
            listenable: AppScope.of(context).rates,
            builder: (context, _) {
              final showTotal =
                  AppScope.of(context).rates.showListGrandTotal;
              return BottomAppBar(
            height: 78,
            color: AppTheme.surface,
            elevation: 16,
            shadowColor: Colors.black54,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                if (showTotal)
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
                    onPressed: _scrollToCart,
                    style: FilledButton.styleFrom(
                      backgroundColor: AppTheme.sage.withValues(alpha: 0.35),
                      foregroundColor: AppTheme.ink700,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10),
                      minimumSize: const Size(0, 40),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      cart.isEmpty ? 'Ver carrito' : 'Ver carrito (${cart.length})',
                      style: const TextStyle(
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
          );
            },
          ),
          body: Column(
            children: [
              ListenableBuilder(
                listenable: ListItemClipboard.instance,
                builder: (context, _) {
                  final n = ListItemClipboard.instance.items.length;
                  if (n == 0 || _selected.isNotEmpty) {
                    return const SizedBox.shrink();
                  }
                  return Material(
                    color: AppTheme.sage.withValues(alpha: 0.35),
                    child: ListTile(
                      dense: true,
                      leading: const Icon(Icons.content_paste_outlined),
                      title: Text('Pegar $n en esta lista'),
                      onTap: _pasteCopied,
                    ),
                  );
                },
              ),
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
    final selecting = _selected.isNotEmpty;
    final marked = _selected.contains(item.id);

    Future<void> toggleCart() async {
      if (_flyingIds.contains(item.id)) return;
      final sync = AppScope.of(context).sync;
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
        _showCartToast(item.name);
        Future<void>.delayed(const Duration(milliseconds: 700), () {
          if (mounted) setState(() => _cartPulse = false);
        });
      }
      await sync.syncNow();
    }

    final card = AnimatedSlide(
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
            child: GestureDetector(
              onLongPress: () => _toggleSelect(item.id),
              child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _leading(
                  product?.localImagePath,
                  catColor,
                  catIcon,
                  onTap: () => _previewImage(
                    context,
                    product: product,
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
                      onTap: () => selecting
                          ? _toggleSelect(item.id)
                          : _editItem(context, item),
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
                Checkbox(
                  value: selecting ? marked : inCart,
                  activeColor: AppTheme.sage,
                  visualDensity: VisualDensity.compact,
                  onChanged: (_) => selecting
                      ? _toggleSelect(item.id)
                      : toggleCart(),
                ),
              ],
            ),
            ),
          ),
        ),
      ),
    );

    return Dismissible(
      key: ValueKey('swipe-${item.id}'),
      direction: inCart || selecting
          ? DismissDirection.none
          : DismissDirection.startToEnd,
      dismissThresholds: const {DismissDirection.startToEnd: 0.32},
      movementDuration: const Duration(milliseconds: 220),
      resizeDuration: Duration.zero,
      confirmDismiss: (_) async {
        await _swipeToCart(item);
        return false;
      },
      background: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        padding: const EdgeInsets.only(left: 22),
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          color: AppTheme.sage,
          borderRadius: BorderRadius.circular(AppTheme.radius),
        ),
        child: const Icon(Icons.shopping_cart, color: AppTheme.ink800, size: 28),
      ),
      child: card,
    );
  }

  void _toggleSelect(String id) {
    setState(() {
      if (!_selected.add(id)) _selected.remove(id);
    });
  }

  Future<void> _swipeToCart(ListItem item) async {
    if (item.status == 'in_cart' || _flyingIds.contains(item.id)) return;
    final scope = AppScope.of(context);
    setState(() {
      _cartExpanded = true;
      _cartPulse = true;
    });
    await scope.repo.setItemStatus(item, 'in_cart');
    if (!mounted) return;
    _showCartToast(item.name);
    Future<void>.delayed(const Duration(milliseconds: 700), () {
      if (mounted) setState(() => _cartPulse = false);
    });
    unawaited(scope.sync.syncNow());
  }

  Future<void> _deleteSelected(List<ListItem> items) async {
    final ids = items
        .where((i) => _selected.contains(i.id))
        .map((i) => i.id)
        .toList();
    if (ids.isEmpty || !mounted) return;
    final ok = await confirmDialog(
      context,
      title: 'Eliminar',
      message: ids.length == 1
          ? 'Se quita 1 producto de la lista.'
          : 'Se quitan ${ids.length} productos de la lista.',
    );
    if (ok != true || !mounted) return;
    final scope = AppScope.of(context);
    for (final id in ids) {
      await scope.repo.deleteItem(id);
    }
    await scope.sync.syncNow();
    if (mounted) setState(() => _selected.clear());
  }

  void _copySelected(List<ListItem> items) {
    final picked = items.where((i) => _selected.contains(i.id)).toList();
    if (picked.isEmpty) return;
    ListItemClipboard.instance.setItems(picked);
    setState(() => _selected.clear());
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          picked.length == 1
              ? '1 producto copiado. Pégalo en otra lista.'
              : '${picked.length} productos copiados. Pégalos en otra lista.',
        ),
      ),
    );
  }

  Future<void> _cartSelected(List<ListItem> items) async {
    final picked = items
        .where((i) => _selected.contains(i.id) && i.status != 'in_cart')
        .toList();
    final scope = AppScope.of(context);
    for (final item in picked) {
      await scope.repo.setItemStatus(item, 'in_cart');
    }
    if (picked.isNotEmpty) await scope.sync.syncNow();
    if (!mounted) return;
    setState(() {
      _selected.clear();
      if (picked.isNotEmpty) {
        _cartExpanded = true;
        _cartPulse = true;
      }
    });
    if (picked.isNotEmpty) {
      Future<void>.delayed(const Duration(milliseconds: 700), () {
        if (mounted) setState(() => _cartPulse = false);
      });
    }
  }

  Future<void> _pasteCopied() async {
    final clip = List.of(ListItemClipboard.instance.items);
    if (clip.isEmpty || !mounted) return;
    final scope = AppScope.of(context);
    for (final i in clip) {
      await scope.repo.addItem(
        listId: widget.listId,
        name: i.name,
        productId: i.productId,
        unitId: i.unitId,
        unitAbbr: i.unitAbbr,
        qtyPlanned: i.qtyPlanned,
        unitPrice: i.unitPrice,
        notes: i.notes,
      );
    }
    await scope.sync.syncNow();
    ListItemClipboard.instance.clear();
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
    Product? product,
    required String? path,
    required String name,
    required Color color,
    required IconData icon,
  }) async {
    if (!kIsWeb && path != null && path.isNotEmpty && File(path).existsSync()) {
      final next = await Navigator.push<String>(
        context,
        MaterialPageRoute(
          fullscreenDialog: true,
          builder: (_) => ImageCropPage(sourcePath: path),
        ),
      );
      if (next == null || product == null || !context.mounted) return;
      final scope = AppScope.of(context);
      await scope.repo.upsertProduct(
        id: product.id,
        name: product.name,
        description: product.description,
        categoryId: product.categoryId,
        unitId: product.unitId,
        basePrice: product.basePrice,
        localImagePath: next,
        imagePending: true,
      );
      await scope.sync.syncNow();
      await _loadLookups();
      return;
    }
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

  Future<void> _deleteList(BuildContext context) async {
    final ok = await confirmDialog(
      context,
      title: 'Eliminar lista',
      message: 'La lista se elimina. Los productos se quedan en el inventario.',
    );
    if (ok != true || !context.mounted) return;
    final scope = AppScope.of(context);
    await scope.repo.deleteList(widget.listId);
    await scope.sync.syncNow();
    if (context.mounted) Navigator.pop(context);
  }

  Future<void> _clearCart(BuildContext context) async {
    final ok = await confirmDialog(
      context,
      title: 'Limpiar carrito',
      message: 'Mueve todos los ítems del carrito a Pendiente.',
      confirm: 'Limpiar',
    );
    if (ok != true || !context.mounted) return;
    final scope = AppScope.of(context);
    await scope.repo.clearCart(widget.listId);
    await scope.sync.syncNow();
  }

  Future<void> _deleteCompleted(
      BuildContext context, List<ListItem> cart) async {
    final ok = await confirmDialog(
      context,
      title: 'Eliminar comprados',
      message: 'Elimina ${cart.length} ítems del carrito.',
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
    final ok = await confirmDialog(
      context,
      title: 'Finalizar compra',
      message: 'Se guardará el carrito en el historial.',
      confirm: 'Finalizar',
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

  Future<void> _editItem(BuildContext context, ListItem item) async {
    final scope = AppScope.of(context);
    final product = item.productId == null
        ? null
        : (_products[item.productId] ??
            await scope.repo.getProduct(item.productId!));
    if (!context.mounted) return;
    final qty = item.status == 'in_cart'
        ? (item.qtyBought ?? item.qtyPlanned)
        : item.qtyPlanned;
    final result = await showAddItemSheet(
      context: context,
      repo: scope.repo,
      product: product,
      initialName: item.name,
      initialQty: qty,
      initialPrice: item.unitPrice,
      initialUnitId: item.unitId,
      initialNote: item.notes ?? product?.description,
      initialAddToCart: item.status == 'in_cart',
      onDelete: () async {
        await scope.repo.deleteItem(item.id);
        await scope.sync.syncNow();
      },
    );
    if (result == null || !context.mounted) return;
    await scope.repo.updateListItem(
      item: item,
      name: result.name,
      productId: result.productId ?? item.productId,
      unitId: result.unitId,
      unitAbbr: result.unitAbbr,
      categoryId: result.categoryId,
      qty: result.qty,
      unitPrice: result.unitPrice,
      description: result.note,
      localImagePath: result.imagePath,
      addToCart: result.addToCart,
    );
    await scope.sync.syncNow();
    await _loadLookups();
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

/// Horizontal category chips. "Todas" clears the filter.
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
    if (keys.isEmpty) return const SizedBox.shrink();
    return SizedBox(
      height: 48,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
        children: [
          _chip(
            label: 'Todas',
            selected: selected == null,
            onTap: () => onSelect(null),
          ),
          for (final k in keys)
            _chip(
              label: labelFor(k),
              color: colorFor(k),
              selected: selected == k,
              onTap: () => onSelect(k),
            ),
        ],
      ),
    );
  }

  Widget _chip({
    required String label,
    required bool selected,
    required VoidCallback onTap,
    Color? color,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        avatar: color == null
            ? null
            : CircleAvatar(radius: 5, backgroundColor: color),
        selected: selected,
        showCheckmark: false,
        backgroundColor: Colors.white,
        selectedColor: AppTheme.ink700,
        side: BorderSide(
          color: selected ? AppTheme.ink700 : AppTheme.borderSubtle,
          width: selected ? 2 : 1,
        ),
        labelStyle: TextStyle(
          color: selected ? AppTheme.mint : AppTheme.ink700,
          fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
        ),
        onSelected: (_) => onTap(),
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

/// Items copied from a list, ready to paste into another.
class ListItemClipboard extends ChangeNotifier {
  ListItemClipboard._();
  static final instance = ListItemClipboard._();

  final List<ListItem> items = [];

  void setItems(List<ListItem> next) {
    items
      ..clear()
      ..addAll(next);
    notifyListeners();
  }

  void clear() {
    if (items.isEmpty) return;
    items.clear();
    notifyListeners();
  }
}

class _BulkAction extends StatelessWidget {
  const _BulkAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppTheme.ink700),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(
                color: AppTheme.ink700,
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
