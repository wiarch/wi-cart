import 'package:flutter/material.dart';

import '../../app_scope.dart';
import '../../data/database.dart';
import '../../sync/sync_engine.dart';
import 'sync_queue_sheet.dart';

const _onlineColor = Color(0xFF43A047);
const _offlineColor = Color(0xFFE53935);

/// Cloud status icon. Green when online, red ring when offline.
/// Count badge only while there is something pending.
/// Tap: sync now. Long press: queue details.
class SyncBadge extends StatefulWidget {
  const SyncBadge({super.key});

  @override
  State<SyncBadge> createState() => _SyncBadgeState();
}

class _SyncBadgeState extends State<SyncBadge> {
  // Cached: a new stream per build restarts StreamBuilder (spinner/flicker).
  Stream<List<SyncOutboxData>>? _pending;

  @override
  Widget build(BuildContext context) {
    final scope = AppScope.of(context);
    final sync = scope.sync;
    _pending ??= scope.db.select(scope.db.syncOutbox).watch();

    return StreamBuilder<SyncStatus>(
      stream: sync.status$,
      builder: (context, statusSnap) {
        final s = statusSnap.data;
        final online = s?.online ?? true;
        final syncing = s?.syncing ?? false;
        return StreamBuilder<List<SyncOutboxData>>(
          stream: _pending,
          builder: (context, pendingSnap) {
            final pending = pendingSnap.data?.length ?? s?.pending ?? 0;
            final icon = syncing
                ? const Icon(Icons.sync, color: _onlineColor)
                : Icon(
                    Icons.cloud_done_outlined,
                    color: online ? _onlineColor : null,
                  );
            return Tooltip(
              message: online
                  ? (syncing ? 'Sincronizando…' : 'Sincronizado')
                  : 'Sin conexión',
              child: InkResponse(
                radius: 24,
                onTap: () => sync.syncNow(),
                onLongPress: () => showSyncQueueSheet(context),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Badge(
                    isLabelVisible: pending > 0,
                    label: Text('$pending'),
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: online
                          ? null
                          : BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: _offlineColor,
                                width: 2,
                              ),
                            ),
                      child: icon,
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
