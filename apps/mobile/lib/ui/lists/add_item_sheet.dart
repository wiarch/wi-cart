import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';

import '../../app_scope.dart';
import '../../data/database.dart';
import '../../data/repository.dart';
import '../theme/app_theme.dart';
import '../widgets/category_style.dart';
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
  });

  final String name;
  final String? productId;
  final String? unitId;
  final String? unitAbbr;
  final String? categoryId;
  final double qty;
  final double? unitPrice;
}

Future<AddItemResult?> showAddItemSheet({
  required BuildContext context,
  required CartRepository repo,
}) async {
  final units = await repo.getUnits();
  final categories = await repo.getCategories();
  if (!context.mounted) return null;

  final name = TextEditingController();
  final qty = TextEditingController(text: '1');
  final price = TextEditingController();
  Product? selected;
  Unit? selectedUnit = units.isNotEmpty
      ? units.firstWhere((u) => u.abbreviation == 'un',
          orElse: () => units.first)
      : null;
  String? categoryId;
  List<Product> suggestions = [];
  Timer? debounce;

  return showModalBottomSheet<AddItemResult>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
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
        child: StatefulBuilder(builder: (ctx, setLocal) {
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

          Widget thumb(Product p) {
            final cat = categories
                .where((c) => c.id == p.categoryId)
                .firstOrNull;
            final color = CategoryStyle.parseColor(cat?.color) ??
                const Color(0xFF9E9E9E);
            if (p.localImagePath != null &&
                File(p.localImagePath!).existsSync()) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.file(File(p.localImagePath!),
                    width: 40, height: 40, fit: BoxFit.cover),
              );
            }
            return Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(CategoryStyle.iconFor(cat?.icon),
                  size: 20, color: color),
            );
          }

          return SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Agregar ítem',
                  style: Theme.of(ctx).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: name,
                  autofocus: true,
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
                              : Text(moneySubtitle(
                                  AppScope.of(context).rates,
                                  p.basePrice!,
                                )),
                          onTap: () {
                            setLocal(() {
                              selected = p;
                              name.text = p.name;
                              suggestions = [];
                              if (p.basePrice != null) {
                                price.text =
                                    p.basePrice!.toStringAsFixed(2);
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
                      style: Theme.of(ctx).textTheme.labelSmall?.copyWith(
                            color: Theme.of(ctx).colorScheme.primary,
                          ),
                    ),
                  ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: qty,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        decoration:
                            const InputDecoration(labelText: 'Cantidad'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: TextField(
                        controller: price,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        decoration: const InputDecoration(
                            labelText: 'Precio (USD)'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String?>(
                  // ignore: deprecated_member_use
                  value: categoryId,
                  items: [
                    const DropdownMenuItem(
                        value: null, child: Text('Sin categoría')),
                    ...categories.map((c) => DropdownMenuItem(
                          value: c.id,
                          child: Row(
                            children: [
                              Icon(
                                CategoryStyle.iconFor(c.icon),
                                size: 18,
                                color: CategoryStyle.parseColor(c.color) ??
                                    Colors.grey,
                              ),
                              const SizedBox(width: 8),
                              Text(c.name),
                            ],
                          ),
                        )),
                  ],
                  onChanged: (v) => setLocal(() => categoryId = v),
                  decoration: const InputDecoration(labelText: 'Categoría'),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<Unit?>(
                  // ignore: deprecated_member_use
                  value: selectedUnit,
                  items: units
                      .map((u) => DropdownMenuItem(
                            value: u,
                            child: Text('${u.name} (${u.abbreviation})'),
                          ))
                      .toList(),
                  onChanged: (u) => setLocal(() => selectedUnit = u),
                  decoration: const InputDecoration(labelText: 'Medida'),
                ),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: () {
                    final n = name.text.trim();
                    if (n.isEmpty) return;
                    Navigator.pop(
                      ctx,
                      AddItemResult(
                        name: n,
                        productId: selected?.id,
                        unitId: selectedUnit?.id,
                        unitAbbr: selectedUnit?.abbreviation,
                        categoryId: categoryId,
                        qty: double.tryParse(
                                qty.text.replaceAll(',', '.')) ??
                            1,
                        unitPrice: double.tryParse(
                            price.text.replaceAll(',', '.')),
                      ),
                    );
                  },
                  child: const Text('Agregar'),
                ),
              ],
            ),
          );
        }),
      );
    },
  );
}
