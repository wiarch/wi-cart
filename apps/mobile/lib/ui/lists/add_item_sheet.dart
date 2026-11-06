import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../app_scope.dart';
import '../../data/database.dart';
import '../../data/repository.dart';
import '../../utils/quantity_math.dart';
import '../theme/app_theme.dart';
import '../widgets/category_style.dart';
import '../widgets/confirm_dialog.dart';
import '../widgets/image_crop_page.dart';
import '../widgets/money_text.dart';

class AddItemResult {
  AddItemResult({
    required this.name,
    this.productId,
    this.unitId,
    this.unitAbbr,
    this.categoryId,
    required this.qty,
    this.unitPrice,
    this.note,
    this.imagePath,
    this.addToCart = false,
  });

  final String name;
  final String? productId;
  final String? unitId;
  final String? unitAbbr;
  final String? categoryId;
  final double qty;
  final double? unitPrice;
  final String? note;
  final String? imagePath;
  final bool addToCart;
}

const _newCategoryKey = '__new_category__';

double _parseNum(String s) => double.tryParse(s.replaceAll(',', '.')) ?? 0;

/// Small input dialog; returns the trimmed name or null.
Future<String?> _promptCategoryName(BuildContext context) async {
  final ctrl = TextEditingController();
  final result = await showDialog<String>(
    context: context,
    builder: (ctx) => AppAlertDialog(
      title: 'Nueva categoría',
      confirmLabel: 'Crear',
      onCancel: () => Navigator.pop(ctx),
      onConfirm: () => Navigator.pop(ctx, ctrl.text.trim()),
      child: TextField(
        controller: ctrl,
        autofocus: false,
        textCapitalization: TextCapitalization.sentences,
        decoration: const InputDecoration(labelText: 'Nombre'),
      ),
    ),
  );
  return (result == null || result.isEmpty) ? null : result;
}

/// Shared product form. Used by the list ("agregar ítem", showCart: true)
/// and by the products module (catalog, showCart: false). [product] prefills
/// the form for editing.
Future<AddItemResult?> showAddItemSheet({
  required BuildContext context,
  required CartRepository repo,
  Product? product,
  bool showCart = true,
  String? initialName,
  double? initialQty,
  double? initialPrice,
  String? initialUnitId,
  String? initialNote,
  bool initialAddToCart = false,
  Future<void> Function()? onDelete,
}) async {
  final units = await repo.getUnits();
  var categories = await repo.getCategories();
  if (!context.mounted) return null;
  final rates = AppScope.of(context).rates;

  final editing = product != null || (initialName?.trim().isNotEmpty ?? false);
  String qtyText(double q) =>
      q % 1 == 0 ? q.toStringAsFixed(0) : q.toString();
  final name = TextEditingController(text: initialName ?? product?.name ?? '');
  final qty = TextEditingController(text: qtyText(initialQty ?? 1));
  final price = TextEditingController(
    text: (initialPrice ?? product?.basePrice)?.toStringAsFixed(2) ?? '',
  );
  final note =
      TextEditingController(text: initialNote ?? product?.description ?? '');
  Product? selected = product;
  final unitId = initialUnitId ?? product?.unitId;
  Unit? selectedUnit = unitId != null
      ? units.where((u) => u.id == unitId).firstOrNull
      : null;
  selectedUnit ??= units.isNotEmpty
      ? units.firstWhere(
          (u) => u.abbreviation == 'un',
          orElse: () => units.first,
        )
      : null;
  String? categoryId = product?.categoryId;
  String? imagePath = product?.localImagePath;
  bool addToCart = initialAddToCart;
  bool priceInBs = false; // price field currency; USD by default
  List<Product> suggestions = [];
  Timer? debounce;

  return showModalBottomSheet<AddItemResult>(
    context: context,
    isScrollControlled: true,
    enableDrag: false,
    backgroundColor: AppTheme.card,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (ctx) {
      return Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 8,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
        ),
        child: StatefulBuilder(
          builder: (ctx, setLocal) {
            void onQuery(String text) {
              debounce?.cancel();
              debounce = Timer(const Duration(milliseconds: 180), () async {
                final hits = await repo.searchProducts(text);
                if (ctx.mounted) setLocal(() => suggestions = hits);
              });
              if (selected != null && selected!.name != text) {
                setLocal(() => selected = null);
              }
            }

            // Rate helpers. usdToBs is Bs per 1 USD; null when no rate stored.
            double? rate() {
              final r = rates.usdToBs;
              return (r != null && r > 0) ? r : null;
            }

            // Price in USD regardless of the active field currency.
            double priceUsd() {
              final v = _parseNum(price.text);
              if (!priceInBs) return v;
              final r = rate();
              return r == null ? 0 : v / r;
            }

            String priceText(double usd) {
              if (!priceInBs) return usd.toStringAsFixed(2);
              final r = rate();
              return ((r == null) ? usd : usd * r).toStringAsFixed(2);
            }

            void setCurrency(bool toBs) {
              if (toBs == priceInBs || rate() == null) return;
              final usd = priceUsd();
              setLocal(() {
                priceInBs = toBs;
                price.text = priceText(usd);
              });
            }

            void submit() {
              final n = name.text.trim();
              if (n.isEmpty) return;
              final noteText = note.text.trim();
              Navigator.pop(
                ctx,
                AddItemResult(
                  name: n,
                  productId: selected?.id,
                  unitId: selectedUnit?.id,
                  unitAbbr: selectedUnit?.abbreviation,
                  categoryId: categoryId,
                  qty: _parseNum(qty.text) == 0 ? 1 : _parseNum(qty.text),
                  unitPrice: price.text.trim().isEmpty ? null : priceUsd(),
                  note: noteText.isEmpty ? null : noteText,
                  imagePath: imagePath,
                  addToCart: addToCart,
                ),
              );
            }

            Future<void> pickImage() async {
              final source = await showModalBottomSheet<ImageSource>(
                context: ctx,
                builder: (sheet) => SafeArea(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        leading: const Icon(Icons.photo_camera_outlined),
                        title: const Text('Cámara'),
                        onTap: () => Navigator.pop(sheet, ImageSource.camera),
                      ),
                      ListTile(
                        leading: const Icon(Icons.photo_library_outlined),
                        title: const Text('Galería'),
                        onTap: () => Navigator.pop(sheet, ImageSource.gallery),
                      ),
                    ],
                  ),
                ),
              );
              if (source == null || !ctx.mounted) return;
              try {
                final file = await ImagePicker().pickImage(
                  source: source,
                  maxWidth: 2048,
                  imageQuality: 90,
                );
                if (file == null || !ctx.mounted) return;
                final cropped = await Navigator.push<String>(
                  ctx,
                  MaterialPageRoute(
                    builder: (_) => ImageCropPage(sourcePath: file.path),
                  ),
                );
                if (cropped != null && ctx.mounted) {
                  setLocal(() => imagePath = cropped);
                }
              } catch (e) {
                if (ctx.mounted) {
                  ScaffoldMessenger.maybeOf(ctx)?.showSnackBar(
                    SnackBar(content: Text('No se pudo obtener la imagen: $e')),
                  );
                }
              }
            }

            Widget thumb(Product p) {
              final cat = categories
                  .where((c) => c.id == p.categoryId)
                  .firstOrNull;
              final color =
                  CategoryStyle.parseColor(cat?.color) ??
                  const Color(0xFF9E9E9E);
              if (p.localImagePath != null &&
                  File(p.localImagePath!).existsSync()) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.file(
                    File(p.localImagePath!),
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                  ),
                );
              }
              return Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  CategoryStyle.iconFor(cat?.icon),
                  size: 20,
                  color: color,
                ),
              );
            }

            final abbr = selectedUnit?.abbreviation;
            final r = rate();
            final pUsd = priceUsd();
            final totalUsd = lineTotal(
              qty: _parseNum(qty.text),
              unitAbbr: abbr,
              unitPrice: pUsd,
            );
            final totalBs = r == null ? null : totalUsd * r;
            final theme = Theme.of(ctx);

            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          editing ? 'Editar Producto' : 'Agregar Producto',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      IconButton(
                        tooltip: 'Cerrar',
                        icon: const Icon(Icons.keyboard_arrow_down),
                        onPressed: () => Navigator.pop(ctx),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: name,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Producto',
                      hintText: 'Buscar o crear…',
                      prefixIcon: Icon(Icons.search),
                    ),
                    onChanged: onQuery,
                  ),
                  if (suggestions.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Container(
                      constraints: const BoxConstraints(maxHeight: 180),
                      decoration: BoxDecoration(
                        color: AppTheme.field,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: ListView.separated(
                        shrinkWrap: true,
                        itemCount: suggestions.length,
                        separatorBuilder: (_, __) => Divider(
                          height: 1,
                          color: Colors.black.withValues(alpha: 0.05),
                        ),
                        itemBuilder: (_, i) {
                          final p = suggestions[i];
                          return ListTile(
                            dense: true,
                            leading: thumb(p),
                            title: Text(p.name),
                            subtitle: p.basePrice == null
                                ? null
                                : Text(moneySubtitle(rates, p.basePrice!)),
                            onTap: () {
                              setLocal(() {
                                selected = p;
                                name.text = p.name;
                                suggestions = [];
                                if (p.basePrice != null) {
                                  price.text = priceText(p.basePrice!);
                                }
                                categoryId = p.categoryId;
                                if (p.unitId != null) {
                                  selectedUnit = units
                                      .where((u) => u.id == p.unitId)
                                      .firstOrNull;
                                }
                              });
                            },
                          );
                        },
                      ),
                    ),
                  ],
                  if (selected == null && name.text.trim().isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        'Nuevo → se creará en el catálogo',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: imagePath == null
                            ? null
                            : () async {
                                final next = await Navigator.push<String>(
                                  ctx,
                                  MaterialPageRoute(
                                    fullscreenDialog: true,
                                    builder: (_) =>
                                        ImagePreviewPage(path: imagePath!),
                                  ),
                                );
                                if (next != null && ctx.mounted) {
                                  setLocal(() => imagePath = next);
                                }
                              },
                        child: Container(
                          width: 96,
                          height: 96,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            color: AppTheme.field,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: imagePath != null
                              ? Image.file(File(imagePath!), fit: BoxFit.cover)
                              : Icon(
                                  Icons.image_outlined,
                                  size: 32,
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            OutlinedButton.icon(
                              onPressed: pickImage,
                              icon: const Icon(Icons.add_a_photo_outlined),
                              label: const Text('Agregar imagen'),
                            ),
                            if (imagePath != null)
                              TextButton(
                                onPressed: () =>
                                    setLocal(() => imagePath = null),
                                child: const Text('Quitar imagen'),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: TextField(
                          controller: qty,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          decoration: const InputDecoration(
                            labelText: 'Cantidad',
                          ),
                          onChanged: (_) => setLocal(() {}),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 3,
                        child: DropdownButtonFormField<Unit?>(
                          // ignore: deprecated_member_use
                          value: selectedUnit,
                          isExpanded: true,
                          items: units
                              .map(
                                (u) => DropdownMenuItem(
                                  value: u,
                                  child: Text(
                                    '${u.name} (${u.abbreviation})',
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (u) => setLocal(() => selectedUnit = u),
                          decoration: const InputDecoration(
                            labelText: 'Unidad',
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: price,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: InputDecoration(
                      labelText: priceInBs ? 'Precio (Bs)' : 'Precio (USD)',
                      suffixIcon: Container(
                        margin: const EdgeInsets.all(6),
                        padding: const EdgeInsets.only(left: 6),
                        decoration: const BoxDecoration(
                          border: Border(
                            left: BorderSide(color: AppTheme.borderSubtle),
                          ),
                        ),
                        child: SegmentedButton<bool>(
                          showSelectedIcon: false,
                          style: SegmentedButton.styleFrom(
                            side: BorderSide.none,
                            visualDensity: VisualDensity.compact,
                            shape: const StadiumBorder(),
                          ),
                          segments: const [
                            ButtonSegment(value: false, label: Text('USD')),
                            ButtonSegment(value: true, label: Text('Bs')),
                          ],
                          selected: {priceInBs},
                          onSelectionChanged: r == null
                              ? null
                              : (s) => setCurrency(s.first),
                        ),
                      ),
                    ),
                    onChanged: (_) => setLocal(() {}),
                  ),
                  if (r != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4, left: 4),
                      child: Text(
                        priceInBs
                            ? '≈ ${formatUsd(pUsd)} por ${basePriceLabel(abbr)}'
                            : '≈ ${formatBs(pUsd * r)} por ${basePriceLabel(abbr)}',
                        style: theme.textTheme.labelSmall,
                      ),
                    )
                  else
                    Padding(
                      padding: const EdgeInsets.only(top: 4, left: 4),
                      child: Text(
                        'Sin tasa Bs: solo USD',
                        style: theme.textTheme.labelSmall,
                      ),
                    ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String?>(
                    // ignore: deprecated_member_use
                    value: categoryId,
                    isExpanded: true,
                    items: [
                      const DropdownMenuItem(
                        value: null,
                        child: Text('Sin categoría'),
                      ),
                      ...categories.map(
                        (c) => DropdownMenuItem(
                          value: c.id,
                          child: Row(
                            children: [
                              Icon(
                                CategoryStyle.iconFor(c.icon),
                                size: 18,
                                color:
                                    CategoryStyle.parseColor(c.color) ??
                                    Colors.grey,
                              ),
                              const SizedBox(width: 8),
                              Flexible(
                                child: Text(
                                  c.name,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const DropdownMenuItem(
                        value: _newCategoryKey,
                        child: Row(
                          children: [
                            Icon(Icons.add, size: 18),
                            SizedBox(width: 8),
                            Text('Agregar nueva categoría'),
                          ],
                        ),
                      ),
                    ],
                    onChanged: (v) async {
                      if (v != _newCategoryKey) {
                        setLocal(() => categoryId = v);
                        return;
                      }
                      final name = await _promptCategoryName(ctx);
                      if (name == null || !ctx.mounted) return;
                      final scope = AppScope.of(ctx);
                      final created = await scope.repo.upsertCategory(
                        name: name,
                      );
                      await scope.sync.syncNow();
                      final fresh = await scope.repo.getCategories();
                      if (!ctx.mounted) return;
                      setLocal(() {
                        categories = fresh;
                        categoryId = created.id;
                      });
                    },
                    decoration: const InputDecoration(labelText: 'Categoría'),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: note,
                    minLines: 1,
                    maxLines: 3,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: const InputDecoration(
                      labelText: 'Nota / Observación',
                      hintText: 'Opcional',
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.field,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppTheme.sage.withValues(alpha: 0.4),
                      ),
                    ),
                    child: Row(
                      children: [
                        Text(
                          'Total',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Spacer(),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              formatUsd(totalUsd),
                              style: theme.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.5,
                              ),
                            ),
                            if (totalBs != null)
                              Text(
                                formatBs(totalBs),
                                style: theme.textTheme.titleSmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      if (onDelete != null) ...[
                        IconButton.filled(
                          tooltip: 'Eliminar de la lista',
                          icon: const Icon(Icons.delete_outline),
                          style: IconButton.styleFrom(
                            minimumSize: const Size(52, 52),
                            backgroundColor:
                                theme.colorScheme.error.withValues(alpha: 0.12),
                            foregroundColor: theme.colorScheme.error,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          onPressed: () async {
                            final go = await confirmDialog(
                              ctx,
                              title: 'Eliminar de la lista',
                              message:
                                  'El producto sale de esta lista. Sigue en el inventario.',
                            );
                            if (go != true || !ctx.mounted) return;
                            await onDelete();
                            if (ctx.mounted) Navigator.pop(ctx);
                          },
                        ),
                        const SizedBox(width: 12),
                      ],
                      Expanded(
                        child: FilledButton(
                          onPressed: submit,
                          child: Text(editing ? 'Guardar' : 'Agregar'),
                        ),
                      ),
                      if (showCart) ...[
                        const SizedBox(width: 12),
                        IconButton.filled(
                          tooltip: 'Agregar directamente al carrito',
                          isSelected: addToCart,
                          icon: const Icon(Icons.add_shopping_cart_outlined),
                          selectedIcon: const Icon(Icons.shopping_cart),
                          style:
                              IconButton.styleFrom(
                                minimumSize: const Size(52, 52),
                                backgroundColor: AppTheme.ink700,
                                foregroundColor: AppTheme.mint,
                                side: const BorderSide(color: AppTheme.sage),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ).copyWith(
                                backgroundColor:
                                    WidgetStateProperty.resolveWith(
                                      (s) => s.contains(WidgetState.selected)
                                          ? AppTheme.sage
                                          : AppTheme.ink700,
                                    ),
                                foregroundColor:
                                    WidgetStateProperty.resolveWith(
                                      (s) => s.contains(WidgetState.selected)
                                          ? AppTheme.ink950
                                          : AppTheme.mint,
                                    ),
                              ),
                          onPressed: () =>
                              setLocal(() => addToCart = !addToCart),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      );
    },
  );
}
