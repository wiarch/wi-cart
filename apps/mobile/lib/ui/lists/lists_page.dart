import 'package:flutter/material.dart';

import '../../app_scope.dart';
import '../../data/database.dart';
import '../settings/settings_page.dart';
import '../widgets/soft_card.dart';
import '../widgets/sync_badge.dart';
import 'list_detail_page.dart';

class ListsPage extends StatelessWidget {
  const ListsPage({super.key, this.onLogout});

  final VoidCallback? onLogout;

  @override
  Widget build(BuildContext context) {
    final repo = AppScope.of(context).repo;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Listas'),
        actions: [
          const SyncBadge(),
          IconButton(
            tooltip: 'Ajustes / tasas',
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SettingsPage()),
            ),
          ),
          if (onLogout != null)
            IconButton(
              tooltip: 'Salir',
              icon: const Icon(Icons.logout),
              onPressed: () async {
                final scope = AppScope.of(context);
                await scope.api.logout();
                await scope.repo.onUserSwitch(null);
                onLogout!();
              },
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final name = TextEditingController(text: 'Compra');
          final ok = await showDialog<bool>(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text('Nueva lista'),
              content: TextField(
                controller: name,
                autofocus: true,
                decoration: const InputDecoration(labelText: 'Nombre'),
              ),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(ctx, false),
                    child: const Text('Cancelar')),
                FilledButton(
                    onPressed: () => Navigator.pop(ctx, true),
                    child: const Text('Crear')),
              ],
            ),
          );
          if (ok == true && context.mounted) {
            final sync = AppScope.of(context).sync;
            final list = await repo.createList(name.text.trim());
            await repo.rememberLastList(list.id);
            await sync.syncNow();
            if (context.mounted) {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) =>
                        ListDetailPage(listId: list.id, listName: list.name)),
              );
            }
          }
        },
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<List<ShoppingList>>(
        stream: repo.watchActiveLists(),
        builder: (context, snap) {
          final lists = snap.data ?? [];
          if (lists.isEmpty) {
            return Center(
              child: Text(
                'Sin listas activas',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(0, 8, 0, 88),
            itemCount: lists.length,
            itemBuilder: (context, i) {
              final l = lists[i];
              return SoftCard(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        ListDetailPage(listId: l.id, listName: l.name),
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(16, 14, 8, 14),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            l.storeLocation?.isNotEmpty == true
                                ? l.storeLocation!
                                : 'Sin tienda',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant,
                                ),
                          ),
                        ],
                      ),
                    ),
                    PopupMenuButton<String>(
                      onSelected: (v) async {
                        if (v != 'clone') return;
                        final scope = AppScope.of(context);
                        final clone = await scope.repo.cloneList(l.id);
                        await scope.sync.syncNow();
                        if (!context.mounted) return;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ListDetailPage(
                                listId: clone.id, listName: clone.name),
                          ),
                        );
                      },
                      itemBuilder: (_) => const [
                        PopupMenuItem(
                            value: 'clone', child: Text('Clonar lista')),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
