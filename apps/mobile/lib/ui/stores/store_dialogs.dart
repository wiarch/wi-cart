import 'package:flutter/material.dart';

import '../../app_scope.dart';
import '../../data/database.dart';
import '../lists/list_detail_page.dart';
import '../theme/app_theme.dart';
import '../widgets/category_style.dart';
import '../widgets/icon_picker.dart';

/// Name-only dialog for create ([initial] null) or rename. Returns trimmed name or null.
Future<String?> storeNameDialog(BuildContext context, {String? initial}) {
  final name = TextEditingController(text: initial ?? '');
  return showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppTheme.card,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (ctx) => Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 8,
        bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
      ),
      child: StatefulBuilder(
        builder: (ctx, setD) => Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    initial == null ? 'Nueva tienda' : 'Editar tienda',
                    style: Theme.of(ctx).textTheme.titleLarge?.copyWith(
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
              autofocus: true,
              textInputAction: TextInputAction.done,
              onChanged: (_) => setD(() {}),
              onSubmitted: (_) => _pop(ctx, name),
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(labelText: 'Nombre'),
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: name.text.trim().isEmpty
                  ? null
                  : () => _pop(ctx, name),
              child: Text(initial == null ? 'Crear' : 'Guardar'),
            ),
          ],
        ),
      ),
    ),
  );
}

void _pop(BuildContext ctx, TextEditingController c) {
  final t = c.text.trim();
  if (t.isNotEmpty) Navigator.pop(ctx, t);
}

/// Create a store with name only. Returns the created store or null when cancelled.
Future<Store?> createStoreDialog(BuildContext context) async {
  final scope = AppScope.of(context);
  final name = await storeNameDialog(context);
  if (name == null) return null;
  final store = await scope.repo.createStore(name: name);
  await scope.sync.syncNow();
  return store;
}

/// Bottom sheet to choose a store (or create one). Returns null if dismissed.
Future<Store?> pickStoreSheet(BuildContext context, List<Store> stores) {
  return showModalBottomSheet<Store>(
    context: context,
    builder: (ctx) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: Text(
              stores.isEmpty ? 'Crea una tienda primero' : 'Elige la tienda',
              style: Theme.of(ctx).textTheme.titleMedium,
            ),
          ),
          for (final s in stores)
            ListTile(
              leading: Icon(CategoryStyle.iconFor(s.icon)),
              title: Text(s.name),
              onTap: () => Navigator.pop(ctx, s),
            ),
          ListTile(
            leading: const Icon(Icons.add),
            title: const Text('Nueva tienda'),
            onTap: () async {
              final s = await createStoreDialog(ctx);
              if (ctx.mounted) Navigator.pop(ctx, s);
            },
          ),
        ],
      ),
    ),
  );
}

/// Create a list inside [store] and open it.
Future<void> createListDialog(BuildContext context, Store store) async {
  final scope = AppScope.of(context);
  final name = TextEditingController(text: 'Compra');
  var icon = 'cart';
  final ok = await showDialog<bool>(
    context: context,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setD) => AlertDialog(
        title: Text('Nueva lista · ${store.name}'),
        content: Row(
          children: [
            IconButton.filledTonal(
              tooltip: 'Icono',
              icon: Icon(CategoryStyle.iconFor(icon)),
              onPressed: () async {
                final k = await showIconPicker(ctx, current: icon);
                if (k != null) setD(() => icon = k);
              },
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                controller: name,
                decoration: const InputDecoration(labelText: 'Nombre'),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Crear'),
          ),
        ],
      ),
    ),
  );
  if (ok != true || !context.mounted) return;
  final list = await scope.repo.createList(
    name.text.trim(),
    icon: icon,
    storeId: store.id,
  );
  await scope.repo.rememberLastList(list.id);
  await scope.sync.syncNow();
  if (!context.mounted) return;
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => ListDetailPage(listId: list.id, listName: list.name),
    ),
  );
}
