import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../app_scope.dart';
import '../../data/database.dart';
import '../widgets/category_style.dart';
import '../widgets/money_text.dart';
import '../widgets/soft_card.dart';
import '../widgets/sync_badge.dart';

class ProductsPage extends StatelessWidget {
  const ProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = AppScope.of(context).repo;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Productos'),
        actions: const [SyncBadge()],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _edit(context),
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<List<Product>>(
        stream: repo.watchProducts(),
        builder: (context, snap) {
          final items = snap.data ?? [];
          if (items.isEmpty) {
            return Center(
              child: Text(
                'Sin productos. Crea uno.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            );
          }
          return FutureBuilder<List<Category>>(
            future: repo.getCategories(),
            builder: (context, catSnap) {
              final cats = {
                for (final c in catSnap.data ?? <Category>[]) c.id: c
              };
              return ListView.builder(
                padding: const EdgeInsets.fromLTRB(0, 8, 0, 88),
                itemCount: items.length,
                itemBuilder: (context, i) {
                  final p = items[i];
                  final cat =
                      p.categoryId != null ? cats[p.categoryId] : null;
                  final color = CategoryStyle.parseColor(cat?.color) ??
                      const Color(0xFF9E9E9E);
                  return SoftCard(
                    onTap: () => _edit(context, product: p),
                    padding: const EdgeInsets.fromLTRB(12, 12, 8, 12),
                    child: Row(
                      children: [
                        _thumb(p.localImagePath, color, cat?.icon),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                p.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(height: 2),
                              ListenableBuilder(
                                listenable: AppScope.of(context).rates,
                                builder: (context, _) {
                                  final rates = AppScope.of(context).rates;
                                  final parts = <String>[
                                    if (cat != null) cat.name,
                                    if (p.basePrice != null)
                                      moneySubtitle(rates, p.basePrice!),
                                  ];
                                  return Text(
                                    parts.join(' · '),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurfaceVariant,
                                        ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline),
                          onPressed: () async {
                            final sync = AppScope.of(context).sync;
                            await repo.deleteProduct(p.id);
                            await sync.syncNow();
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Widget _thumb(String? path, Color color, String? iconKey) {
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
      child: Icon(CategoryStyle.iconFor(iconKey), color: color, size: 22),
    );
  }

  Future<void> _edit(BuildContext context, {Product? product}) async {
    final repo = AppScope.of(context).repo;
    final categories = await repo.getCategories();
    final units = await repo.getUnits();
    if (!context.mounted) return;

    final name = TextEditingController(text: product?.name ?? '');
    final desc = TextEditingController(text: product?.description ?? '');
    final price = TextEditingController(
        text: product?.basePrice?.toStringAsFixed(2) ?? '');
    String? localImage = product?.localImagePath;
    String? categoryId = product?.categoryId;
    String? unitId = product?.unitId ??
        units
            .where((u) => u.abbreviation == 'un')
            .map((u) => u.id)
            .firstOrNull;

    final ok = await showModalBottomSheet<bool>(
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
          child: StatefulBuilder(
            builder: (ctx, setLocal) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      product == null ? 'Nuevo producto' : 'Editar producto',
                      style: Theme.of(ctx).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    const SizedBox(height: 16),
                    if (localImage != null && File(localImage!).existsSync())
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.file(File(localImage!),
                              height: 140,
                              width: double.infinity,
                              fit: BoxFit.cover),
                        ),
                      ),
                    TextField(
                      controller: name,
                      decoration: const InputDecoration(labelText: 'Nombre'),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: desc,
                      decoration:
                          const InputDecoration(labelText: 'Descripción'),
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
                      decoration:
                          const InputDecoration(labelText: 'Categoría'),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String?>(
                      // ignore: deprecated_member_use
                      value: unitId,
                      items: units
                          .map((u) => DropdownMenuItem(
                                value: u.id,
                                child:
                                    Text('${u.name} (${u.abbreviation})'),
                              ))
                          .toList(),
                      onChanged: (v) => setLocal(() => unitId = v),
                      decoration: const InputDecoration(labelText: 'Medida'),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: price,
                      keyboardType: const TextInputType.numberWithOptions(
                          decimal: true),
                      decoration: const InputDecoration(
                          labelText: 'Precio base (USD)'),
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton.icon(
                      onPressed: () async {
                        final file = await ImagePicker()
                            .pickImage(source: ImageSource.gallery);
                        if (file != null) {
                          setLocal(() => localImage = file.path);
                        }
                      },
                      icon: const Icon(Icons.photo_outlined),
                      label:
                          Text(localImage == null ? 'Añadir foto' : 'Cambiar foto'),
                    ),
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: () => Navigator.pop(ctx, true),
                      child: const Text('Guardar'),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );

    if (ok != true || !context.mounted) return;
    if (name.text.trim().isEmpty) return;
    final scope = AppScope.of(context);
    await scope.repo.upsertProduct(
      id: product?.id,
      name: name.text.trim(),
      description: desc.text.trim().isEmpty ? null : desc.text.trim(),
      categoryId: categoryId,
      unitId: unitId,
      basePrice: double.tryParse(price.text.replaceAll(',', '.')),
      localImagePath: localImage,
      imagePending:
          localImage != null && localImage != product?.localImagePath,
    );
    await scope.sync.syncNow();
  }
}
