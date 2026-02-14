import 'package:isar/isar.dart';

import 'db_enums.dart';

part 'sync_job_entity.g.dart';

@collection
class SyncJobEntity {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String namespace;

  @Enumerated(EnumType.ordinal)
  SyncStatus status = SyncStatus.idle;

  DateTime? startedAt;
  DateTime? finishedAt;
  String? lastError;
  String? extraJson;
}
