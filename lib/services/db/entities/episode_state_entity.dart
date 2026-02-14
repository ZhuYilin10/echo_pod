import 'package:isar/isar.dart';

import 'db_enums.dart';

part 'episode_state_entity.g.dart';

@collection
class EpisodeStateEntity {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String episodeUid;

  int statusFlags = 0;
  int progressMs = 0;

  @Index()
  DateTime? lastPlayedAt;

  int playCount = 0;
  DateTime? completedAt;

  @Enumerated(EnumType.ordinal)
  @Index(composite: [CompositeIndex('updatedAt')])
  DownloadStatus downloadStatus = DownloadStatus.none;

  double downloadProgress = 0;
  int downloadedBytes = 0;
  int? totalBytes;
  String? localFilePath;

  @Index()
  DateTime? favoriteAt;

  @Index()
  DateTime updatedAt = DateTime.now();

  String? extraJson;
}
