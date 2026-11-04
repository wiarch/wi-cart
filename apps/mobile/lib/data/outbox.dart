import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import 'database.dart';

/// Local mutation actions written to `sync_queue`.
abstract final class SyncOp {
  static const create = 'create';
  static const update = 'update';
  static const delete = 'delete';

  /// Legacy alias still accepted by API.
  static const upsert = 'upsert';
}

/// Outbox Pattern writer — every local mutation enqueues here first.
class OutboxWriter {
  OutboxWriter(this.db);

  final AppDatabase db;
  final _uuid = const Uuid();

  Future<void> enqueue({
    required String entity,
    required String entityId,
    required String op,
    required DateTime clientUpdatedAt,
    Map<String, dynamic>? payload,
  }) async {
    // Coalesce: keep a single pending row per entity+id (latest wins).
    await (db.delete(db.syncOutbox)
          ..where(
            (t) => t.entity.equals(entity) & t.entityId.equals(entityId),
          ))
        .go();

    await db.into(db.syncOutbox).insert(
          SyncOutboxCompanion.insert(
            id: _uuid.v4(),
            entity: entity,
            entityId: entityId,
            op: op,
            payloadJson: jsonEncode(payload ?? {}),
            clientUpdatedAt: clientUpdatedAt,
            createdAt: DateTime.now().toUtc(),
          ),
        );
  }

  Future<List<SyncOutboxData>> pending() {
    return (db.select(db.syncOutbox)
          ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
        .get();
  }

  Future<int> pendingCount() async {
    final count = countAll();
    final row = await (db.selectOnly(db.syncOutbox)..addColumns([count]))
        .getSingle();
    return row.read(count) ?? 0;
  }

  Future<void> remove(String id) {
    return (db.delete(db.syncOutbox)..where((t) => t.id.equals(id))).go();
  }

  Future<void> removeAll(Iterable<String> ids) async {
    for (final id in ids) {
      await remove(id);
    }
  }

  Future<void> bumpAttempt(String id, String error) async {
    final row = await (db.select(db.syncOutbox)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    if (row == null) return;
    await (db.update(db.syncOutbox)..where((t) => t.id.equals(id))).write(
      SyncOutboxCompanion(
        attempts: Value(row.attempts + 1),
        lastError: Value(error),
      ),
    );
  }
}
