import 'package:isar/isar.dart';

import '../db/database_service.dart';
import '../db/entities/db_enums.dart';
import '../db/entities/sync_cursor_entity.dart';
import '../db/entities/sync_job_entity.dart';

class SyncRepository {
  SyncRepository({DatabaseService? dbService})
      : _dbService = dbService ?? DatabaseService.instance;

  final DatabaseService _dbService;

  Future<void> setCursor(String namespace, String? cursor) async {
    final db = await _dbService.isar;
    await db.writeTxn(() async {
      final row = await db.syncCursorEntitys
              .filter()
              .namespaceEqualTo(namespace)
              .findFirst() ??
          (SyncCursorEntity()..namespace = namespace);
      row.cursor = cursor;
      row.lastSyncAt = DateTime.now();
      row.syncStatus = SyncStatus.idle;
      row.lastError = null;
      await db.syncCursorEntitys.put(row);
    });
  }

  Future<String?> getCursor(String namespace) async {
    final db = await _dbService.isar;
    final row = await db.syncCursorEntitys
        .filter()
        .namespaceEqualTo(namespace)
        .findFirst();
    return row?.cursor;
  }

  Future<void> updateStatus(
    String namespace,
    SyncStatus status, {
    String? error,
  }) async {
    final db = await _dbService.isar;
    await db.writeTxn(() async {
      final row = await db.syncCursorEntitys
              .filter()
              .namespaceEqualTo(namespace)
              .findFirst() ??
          (SyncCursorEntity()..namespace = namespace);
      row.syncStatus = status;
      row.lastSyncAt = DateTime.now();
      row.lastError = error;
      await db.syncCursorEntitys.put(row);

      final job = await db.syncJobEntitys
              .filter()
              .namespaceEqualTo(namespace)
              .findFirst() ??
          (SyncJobEntity()..namespace = namespace);
      job.status = status;
      if (status == SyncStatus.running) {
        job.startedAt = DateTime.now();
        job.finishedAt = null;
      }
      if (status == SyncStatus.idle || status == SyncStatus.error) {
        job.finishedAt = DateTime.now();
      }
      job.lastError = error;
      await db.syncJobEntitys.put(job);
    });
  }
}
