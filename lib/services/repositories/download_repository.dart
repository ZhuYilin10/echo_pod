import 'package:isar/isar.dart';

import '../../core/models/episode.dart';
import '../db/database_service.dart';
import '../db/db_utils.dart';
import '../db/entities/db_enums.dart';
import '../db/entities/episode_state_entity.dart';
import 'library_repository.dart';
import 'models.dart';

class DownloadRepository {
  DownloadRepository({
    required LibraryRepository libraryRepository,
    DatabaseService? dbService,
  })  : _libraryRepository = libraryRepository,
        _dbService = dbService ?? DatabaseService.instance;

  final LibraryRepository _libraryRepository;
  final DatabaseService _dbService;

  Future<void> markDownloaded(Episode episode, {String? localFilePath}) async {
    final episodeUid = await _ensureEpisodeUid(episode);
    final db = await _dbService.isar;
    await db.writeTxn(() async {
      final state = await db.episodeStateEntitys
              .filter()
              .episodeUidEqualTo(episodeUid)
              .findFirst() ??
          (EpisodeStateEntity()..episodeUid = episodeUid);
      state.downloadStatus = DownloadStatus.completed;
      state.downloadProgress = 1;
      state.localFilePath = localFilePath;
      state.updatedAt = DateTime.now();
      await db.episodeStateEntitys.put(state);
    });
  }

  Future<void> markDownloadRemovedByGuid(String guid) async {
    final episodeUid = await _libraryRepository.findEpisodeUidByGuid(guid);
    if (episodeUid == null) return;

    final db = await _dbService.isar;
    await db.writeTxn(() async {
      final state = await db.episodeStateEntitys
          .filter()
          .episodeUidEqualTo(episodeUid)
          .findFirst();
      if (state == null) return;
      state.downloadStatus = DownloadStatus.none;
      state.downloadProgress = 0;
      state.localFilePath = null;
      state.updatedAt = DateTime.now();
      await db.episodeStateEntitys.put(state);
    });
  }

  Future<void> updateDownloadProgress(
    String episodeUid, {
    required double progress,
    required int downloadedBytes,
    int? totalBytes,
  }) async {
    final db = await _dbService.isar;
    await db.writeTxn(() async {
      final state = await db.episodeStateEntitys
              .filter()
              .episodeUidEqualTo(episodeUid)
              .findFirst() ??
          (EpisodeStateEntity()..episodeUid = episodeUid);
      state.downloadStatus = DownloadStatus.downloading;
      state.downloadProgress = progress;
      state.downloadedBytes = downloadedBytes;
      state.totalBytes = totalBytes;
      state.updatedAt = DateTime.now();
      await db.episodeStateEntitys.put(state);
    });
  }

  Future<List<Episode>> getDownloadedEpisodes({int limit = 500}) async {
    final db = await _dbService.isar;
    final states = await db.episodeStateEntitys
        .filter()
        .downloadStatusEqualTo(DownloadStatus.completed)
        .sortByUpdatedAtDesc()
        .limit(limit)
        .findAll();

    final episodes = <Episode>[];
    for (final state in states) {
      final episode =
          await _libraryRepository.findEpisodeByUid(state.episodeUid);
      if (episode != null) {
        episodes.add(episode);
      }
    }
    return episodes;
  }

  Future<String> _ensureEpisodeUid(Episode episode) async {
    final existing =
        await _libraryRepository.findEpisodeUidByGuid(episode.guid);
    if (existing != null) return existing;

    final podcastUid = await _libraryRepository.ensurePodcastUidForFeed(
      episode.podcastFeedUrl.isEmpty
          ? 'manual://${episode.podcastTitle}'
          : episode.podcastFeedUrl,
      title: episode.podcastTitle,
      subscribed: false,
    );

    await _libraryRepository.upsertEpisodes(
      podcastUid,
      [
        EpisodeDraft(
          podcastUid: podcastUid,
          title: episode.title,
          guid: episode.guid,
          description: episode.description,
          pubDate: episode.pubDate,
          durationMs: parseDurationToMs(episode.duration),
          imageUrl: episode.imageUrl,
          audioUrl: episode.audioUrl,
          articleUrl: episode.articleUrl,
        ),
      ],
    );

    return (await _libraryRepository.findEpisodeUidByGuid(episode.guid)) ??
        episodeUidFromFingerprint(
          buildEpisodeFingerprint(
            podcastUid: podcastUid,
            guid: episode.guid,
            normalizedEnclosureUrl: episode.audioUrl == null
                ? null
                : normalizeUrl(episode.audioUrl!),
            title: episode.title,
            pubDate: episode.pubDate,
          ),
        );
  }
}
