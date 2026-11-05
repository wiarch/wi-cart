import 'dart:convert';

import 'package:drift/drift.dart' show OrderingTerm;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../app_scope.dart';
import '../../data/database.dart';

final _timeFmt = DateFormat('dd/MM HH:mm:ss');

const _entityLabels = {
  'categories': 'Categoría',
  'units': 'Unidad',
  'products': 'Producto',
  'stores': 'Tienda',
  'shopping_lists': 'Lista',
  'list_items': 'Ítem de lista',
  'purchase_histories': 'Compra',
  'purchase_history_items': 'Línea de compra',
};

const _opLabels = {
  'create': 'Crear',
  'update': 'Actualizar',
  'upsert': 'Guardar',
  'delete': 'Eliminar',
};

const _entityIcons = {
  'categories': Icons.category_outlined,
  'units': Icons.straighten_outlined,
  'products': Icons.inventory_2_outlined,
  'stores': Icons.storefront_outlined,
  'shopping_lists': Icons.list_alt,
  'list_items': Icons.shopping_cart_outlined,
  'purchase_histories': Icons.receipt_long_outlined,
  'purchase_history_items': Icons.receipt_outlined,
};

/// Bottom sheet listing every pending sync_queue row.
Future<void> showSyncQueueSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: false,
    builder: (ctx) => DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.7,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      builder: (ctx, controller) => _SyncQueueView(scrollController: controller),
    ),
  );
}

class _SyncQueueView extends StatelessWidget {
  const _SyncQueueView({required this.scrollController});

  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    final scope = AppScope.of(context);
    final theme = Theme.of(context);
    final query = scope.db.select(scope.db.syncOutbox)
      ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]);
    return StreamBuilder<List<SyncOutboxData>>(
      stream: query.watch(),
      builder: (context, snap) {
        final rows = snap.data ?? const <SyncOutboxData>[];
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 4, 4),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Cola de sincronización (${rows.length})',
                      style: theme.textTheme.titleMedium,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () => scope.sync.syncNow(),
                    icon: const Icon(Icons.sync),
                    label: const Text('Sincronizar'),
                  ),
                  IconButton(
                    tooltip: 'Cerrar',
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: !snap.hasData
                  ? const Center(child: CircularProgressIndicator())
                  : rows.isEmpty
                      ? Center(
                          child: Text('Todo sincronizado',
                              style: theme.textTheme.bodyLarge),
                        )
                      : ListView.separated(
                          controller: scrollController,
                          itemCount: rows.length,
                          separatorBuilder: (_, __) =>
                              const Divider(height: 1),
                          itemBuilder: (_, i) => _QueueTile(row: rows[i]),
                        ),
            ),
          ],
        );
      },
    );
  }
}

class _QueueTile extends StatelessWidget {
  const _QueueTile({required this.row});

  final SyncOutboxData row;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final muted = theme.textTheme.bodySmall
        ?.copyWith(color: theme.colorScheme.onSurfaceVariant);
    final name = _payloadName(row.payloadJson);
    final failed = row.attempts > 0 || row.lastError != null;
    final entity = _entityLabels[row.entity] ?? row.entity;
    final op = _opLabels[row.op] ?? row.op;

    return ListTile(
      leading: Icon(
        _entityIcons[row.entity] ?? Icons.sync_problem_outlined,
        color: failed ? theme.colorScheme.error : null,
      ),
      title: Text('$op · $entity'),
      subtitle: Text(
        [
          if (name != null) name,
          'En cola desde ${_timeFmt.format(row.createdAt.toLocal())}',
          'Intentos: ${row.attempts}',
          if (row.lastError != null) 'Error: ${row.lastError}',
        ].join('\n'),
        style: muted,
      ),
      isThreeLine: true,
      trailing: Text(
        failed ? 'Fallido' : 'Pendiente',
        style: theme.textTheme.labelSmall?.copyWith(
          color: failed ? theme.colorScheme.error : null,
        ),
      ),
    );
  }

  static String? _payloadName(String json) {
    try {
      final map = jsonDecode(json);
      if (map is Map && map['name'] is String) {
        final n = (map['name'] as String).trim();
        return n.isEmpty ? null : n;
      }
    } catch (_) {}
    return null;
  }
}
