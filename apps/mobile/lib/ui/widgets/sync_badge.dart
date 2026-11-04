import 'package:flutter/material.dart';

import '../../app_scope.dart';
import '../../sync/sync_engine.dart';

class SyncBadge extends StatelessWidget {
  const SyncBadge({super.key});

  @override
  Widget build(BuildContext context) {
    final sync = AppScope.of(context).sync;
    return StreamBuilder<SyncStatus>(
      stream: sync.status$,
      builder: (context, snap) {
        final s = snap.data;
        final online = s?.online ?? true;
        final pending = s?.pending ?? 0;
        final syncing = s?.syncing ?? false;
        return IconButton(
          tooltip: online
              ? (syncing ? 'Sincronizando…' : 'Online · pendientes $pending')
              : 'Offline · pendientes $pending',
          onPressed: () => sync.syncNow(),
          icon: Badge(
            isLabelVisible: pending > 0,
            label: Text('$pending'),
            child: Icon(
              syncing
                  ? Icons.sync
                  : online
                      ? Icons.cloud_done_outlined
                      : Icons.cloud_off_outlined,
            ),
          ),
        );
      },
    );
  }
}
