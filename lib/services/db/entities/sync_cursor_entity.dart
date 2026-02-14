import 'package:isar/isar.dart';

import 'db_enums.dart';

part 'sync_cursor_entity.g.dart';

@collection
class SyncCursorEntity {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String namespace;

  String? cursor;
  DateTime? lastSyncAt;

  @Enumerated(EnumType.ordinal)
  SyncStatus syncStatus = SyncStatus.idle;

  String? lastError;
  String? extraJson;
}
