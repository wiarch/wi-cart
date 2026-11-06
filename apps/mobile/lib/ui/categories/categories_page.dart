import '../widgets/add_fab.dart';
import '../widgets/app_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../app_scope.dart';
import '../../data/database.dart';
import '../theme/app_theme.dart';
import '../widgets/category_style.dart';
import '../widgets/search_field.dart';
import '../widgets/soft_card.dart';
import '../widgets/sync_badge.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key, this.onLogout, this.embedded = false});

  final VoidCallback? onLogout;

  /// Body only (used inside the Inventario tabs).
  final bool embedded;

  @override
  State<CategoriesPage> createState() => CategoriesPageState();
}

class CategoriesPageState extends State<CategoriesPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => widget.embedded;
  // Cached: a new stream per build restarts StreamBuilder (spinner flicker).
  Stream<List<Category>>? _stream;
  final _search = TextEditingController();

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  void openEditor() => _edit(context);

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final repo = AppScope.of(context).repo;
    _stream ??= repo.watchCategories();
    final content = StreamBuilder<List<Category>>(
      stream: _stream,
      builder: (context, snap) {
        final q = searchQuery(_search);
        final rows = (snap.data ?? [])
            .where((c) => matchesQuery(q, [c.name]))
            .toList();
        if (rows.isEmpty) {
          return Center(
            child: Text(
              'Sin categorías',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(0, 8, 0, 88),
          itemCount: rows.length,
          itemBuilder: (context, i) {
            final c = rows[i];
            final color = CategoryStyle.parseColor(c.color) ?? Colors.grey;
            return SoftCard(
              onTap: () => _edit(context, category: c),
              padding: const EdgeInsets.fromLTRB(14, 12, 8, 12),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(CategoryStyle.iconFor(c.icon), color: color),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          c.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                        if (c.color != null)
                          Text(
                            c.color!,
                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
                                ),
                          ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () async {
                      final sync = AppScope.of(context).sync;
                      await repo.deleteCategory(c.id);
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
    final body = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SearchField(
          controller: _search,
          hint: 'Buscar categoría',
          onChanged: () => setState(() {}),
        ),
        Expanded(child: content),
      ],
    );
    if (widget.embedded) return body;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categorías'),
        actions: [
          SyncBadge(),
          AppMenuButton(onLogout: widget.onLogout),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: AddFab(onPressed: () => _edit(context)),
      body: body,
    );
  }

  Future<void> _edit(BuildContext context, {Category? category}) async {
    final name = TextEditingController(text: category?.name ?? '');
    var selectedIcon = category?.icon ?? 'eco';
    if (!CategoryStyle.icons.containsKey(selectedIcon)) {
      selectedIcon = CategoryStyle.featuredIconKeys.first;
    }
    var selectedColor =
        CategoryStyle.normalizeHex(category?.color) ??
        CategoryStyle.presetColors.first;
    var showCustom = false;
    var hsv = HSVColor.fromColor(
      CategoryStyle.parseColor(selectedColor) ?? const Color(0xFF2E7D32),
    );
    final hexCtrl = TextEditingController(text: selectedColor.substring(1));

    final ok = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setLocal) {
            final preview =
                CategoryStyle.parseColor(selectedColor) ?? Colors.grey;

            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 8,
                bottom: MediaQuery.viewInsetsOf(ctx).bottom + 20,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            category == null ? 'Nueva categoría' : 'Editar categoría',
                            style: Theme.of(ctx).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        IconButton(
                          tooltip: 'Cerrar',
                          icon: const Icon(Icons.keyboard_arrow_down),
                          onPressed: () => Navigator.pop(ctx, false),
                        ),
                      ],
                    ),
                    TextField(
                        controller: name,
                        decoration: const InputDecoration(
                          labelText: 'Nombre',
                          hintText: 'Ej. Lácteos',
                        ),
                        onChanged: (_) => setLocal(() {}),
                      ),
                      const SizedBox(height: 20),
                      Text('Icono', style: Theme.of(ctx).textTheme.titleSmall),
                      const SizedBox(height: 10),
                      GridView.count(
                        crossAxisCount: 4,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 8,
                        childAspectRatio: 1.15,
                        children: [
                          for (final key in CategoryStyle.featuredIconKeys)
                            _IconCell(
                              icon: CategoryStyle.iconFor(key),
                              selected: selectedIcon == key,
                              accent: preview,
                              onTap: () => setLocal(() => selectedIcon = key),
                            ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text('Color', style: Theme.of(ctx).textTheme.titleSmall),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          for (final hex in CategoryStyle.presetColors.take(12))
                            _ColorDot(
                              hex: hex,
                              selected: selectedColor == hex,
                              onTap: () => setLocal(() {
                                selectedColor = hex;
                                showCustom = false;
                              }),
                            ),
                          _CustomColorButton(
                            selected: showCustom,
                            color: preview,
                            onTap: () => setLocal(() => showCustom = !showCustom),
                          ),
                        ],
                      ),
                      if (showCustom) ...[
                        const SizedBox(height: 8),
                        TextField(
                          controller: hexCtrl,
                          decoration: const InputDecoration(
                            labelText: 'Color personalizado',
                            prefixText: '#',
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              RegExp(r'[0-9a-fA-F]'),
                            ),
                            LengthLimitingTextInputFormatter(6),
                          ],
                          onChanged: (raw) {
                            final norm = CategoryStyle.normalizeHex('#$raw');
                            if (norm == null) return;
                            setLocal(() {
                              selectedColor = norm;
                              hsv = HSVColor.fromColor(
                                CategoryStyle.parseColor(norm)!,
                              );
                            });
                          },
                        ),
                        _SliderRow(
                          label: 'Tono',
                          value: hsv.hue,
                          max: 360,
                          activeColor: HSVColor.fromAHSV(1, hsv.hue, 1, 1).toColor(),
                          onChanged: (v) => setLocal(() {
                            hsv = hsv.withHue(v.clamp(0, 360));
                            selectedColor = CategoryStyle.hexFromColor(
                              hsv.toColor(),
                            );
                            hexCtrl.text = selectedColor.substring(1);
                          }),
                        ),
                        _SliderRow(
                          label: 'Saturación',
                          value: hsv.saturation,
                          max: 1,
                          activeColor: preview,
                          onChanged: (v) => setLocal(() {
                            hsv = hsv.withSaturation(v.clamp(0, 1));
                            selectedColor = CategoryStyle.hexFromColor(
                              hsv.toColor(),
                            );
                            hexCtrl.text = selectedColor.substring(1);
                          }),
                        ),
                        _SliderRow(
                          label: 'Brillo',
                          value: hsv.value,
                          max: 1,
                          activeColor: preview,
                          onChanged: (v) => setLocal(() {
                            hsv = hsv.withValue(v.clamp(0, 1));
                            selectedColor = CategoryStyle.hexFromColor(
                              hsv.toColor(),
                            );
                            hexCtrl.text = selectedColor.substring(1);
                          }),
                        ),
                      ],
                      const SizedBox(height: 16),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppTheme.field,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: preview.withValues(alpha: 0.16),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                CategoryStyle.iconFor(selectedIcon),
                                color: preview,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                name.text.trim().isEmpty
                                    ? 'Vista previa'
                                    : name.text.trim(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Text(
                              selectedColor,
                              style: Theme.of(ctx).textTheme.labelSmall,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      FilledButton(
                        onPressed: name.text.trim().isEmpty
                            ? null
                            : () => Navigator.pop(ctx, true),
                        child: const Text('Guardar'),
                      ),
                    ],
                  ),
                ),
              );
          },
        );
      },
    );
    if (ok != true || !context.mounted) return;
    if (name.text.trim().isEmpty) return;
    final scope = AppScope.of(context);
    final color = CategoryStyle.normalizeHex(selectedColor) ?? selectedColor;
    await scope.repo.upsertCategory(
      id: category?.id,
      name: name.text.trim(),
      icon: selectedIcon,
      color: color,
    );
    await scope.sync.syncNow();
  }

}

class _IconCell extends StatelessWidget {
  const _IconCell({
    required this.icon,
    required this.selected,
    required this.accent,
    required this.onTap,
  });

  final IconData icon;
  final bool selected;
  final Color accent;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? accent.withValues(alpha: 0.14) : AppTheme.field,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: selected ? Border.all(color: accent, width: 1.5) : null,
          ),
          child: Icon(
            icon,
            color: selected
                ? accent
                : Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}

class _ColorDot extends StatelessWidget {
  const _ColorDot({
    required this.hex,
    required this.selected,
    required this.onTap,
  });

  final String hex;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = CategoryStyle.parseColor(hex) ?? Colors.grey;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(width: selected ? 3 : 0, color: Colors.white),
          boxShadow: [
            if (selected)
              BoxShadow(
                color: color.withValues(alpha: 0.45),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
      ),
    );
  }
}

class _CustomColorButton extends StatelessWidget {
  const _CustomColorButton({
    required this.selected,
    required this.color,
    required this.onTap,
  });

  final bool selected;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'Personalizar',
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const SweepGradient(
              colors: [
                Colors.red,
                Colors.yellow,
                Colors.green,
                Colors.cyan,
                Colors.blue,
                Colors.purple,
                Colors.red,
              ],
            ),
            border: Border.all(width: selected ? 3 : 0, color: Colors.white),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: const Icon(Icons.tune, size: 14, color: Colors.white),
        ),
      ),
    );
  }
}

class _SliderRow extends StatelessWidget {
  const _SliderRow({
    required this.label,
    required this.value,
    required this.max,
    required this.onChanged,
    required this.activeColor,
  });

  final String label;
  final double value;
  final double max;
  final ValueChanged<double> onChanged;
  final Color activeColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.labelMedium),
        Slider(
          value: value.clamp(0, max),
          max: max,
          onChanged: onChanged,
          activeColor: activeColor,
        ),
      ],
    );
  }
}
