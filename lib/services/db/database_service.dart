import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import 'entities/app_setting_entity.dart';
import 'entities/episode_content_entity.dart';
import 'entities/episode_entity.dart';
import 'entities/episode_state_entity.dart';
import 'entities/external_ref_entity.dart';
import 'entities/media_asset_entity.dart';
import 'entities/podcast_entity.dart';
import 'entities/podcast_preference_entity.dart';
import 'entities/queue_item_entity.dart';
import 'entities/sync_cursor_entity.dart';
import 'entities/sync_job_entity.dart';

class DatabaseService {
  DatabaseService._();

  static final DatabaseService instance = DatabaseService._();

  static const int schemaVersion = 1;

  Isar? _isar;

  Future<Isar> get isar async {
    if (_isar != null) return _isar!;
    return initialize();
  }

  Future<Isar> initialize() async {
    if (_isar != null) return _isar!;

    final dir = await getApplicationDocumentsDirectory();
    _isar = await Isar.open(
      [
        PodcastEntitySchema,
        EpisodeEntitySchema,
        EpisodeContentEntitySchema,
        MediaAssetEntitySchema,
        ExternalRefEntitySchema,
        EpisodeStateEntitySchema,
        PodcastPreferenceEntitySchema,
        QueueItemEntitySchema,
        AppSettingEntitySchema,
        SyncCursorEntitySchema,
        SyncJobEntitySchema,
      ],
      directory: dir.path,
      name: 'echopod_v$schemaVersion',
      inspector: false,
    );
    return _isar!;
  }

  Future<void> close() async {
    if (_isar == null) return;
    await _isar!.close();
    _isar = null;
  }

  Future<void> resetLocalData() async {
    final db = await isar;
    await db.writeTxn(() async {
      await db.clear();
    });
  }
}
