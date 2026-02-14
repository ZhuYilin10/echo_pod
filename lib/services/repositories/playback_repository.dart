import 'dart:async';

import 'package:isar/isar.dart';

import '../../core/models/episode.dart';
import '../db/database_service.dart';
import '../db/db_utils.dart';
import '../db/entities/db_enums.dart';
import '../db/entities/episode_state_entity.dart';
import '../db/entities/podcast_preference_entity.dart';
import '../db/entities/queue_item_entity.dart';
import 'library_repository.dart';
import 'models.dart';
import 'settings_repository.dart';

class PlaybackRepository {
  PlaybackRepository({
    required LibraryRepository libraryRepository,
    required SettingsRepository settingsRepository,
    DatabaseService? dbService,
  })  : _libraryRepository = libraryRepository,
        _settingsRepository = settingsRepository,
        _dbService = dbService ?? DatabaseService.instance;

  static const String _skipSilenceKey = 'skip_silence_enabled';
  static const String _timeSavedKey = 'total_time_saved_ms';

  final LibraryRepository _libraryRepository;
  final SettingsRepository _settingsRepository;
  final DatabaseService _dbService;

  Future<void> setEpisodeProgress(
    String episodeUid,
    int positionMs, {
    bool completed = false,
  }) async {
    final db = await _dbService.isar;
    await db.writeTxn(() async {
      final state = await _ensureStateByUid(db, episodeUid);
      state.progressMs = positionMs;
      state.updatedAt = DateTime.now();
      if (completed) {
        state.completedAt = DateTime.now();
        state.statusFlags = _setFlag(
          state.statusFlags,
          EpisodeStatusFlags.played,
          true,
        );
      }
      await db.episodeStateEntitys.put(state);
    });
  }

  Future<void> savePositionByGuid(String guid, Duration position) async {
    final uid = await _ensureEpisodeUidByGuid(guid);
    if (uid == null) return;
    await setEpisodeProgress(uid, position.inMilliseconds);
  }

  Future<Duration> getPositionByGuid(String guid) async {
    final uid = await _libraryRepository.findEpisodeUidByGuid(guid);
    if (uid == null) return Duration.zero;

    final db = await _dbService.isar;
    final state = await db.episodeStateEntitys
        .filter()
        .episodeUidEqualTo(uid)
        .findFirst();
    if (state == null) return Duration.zero;
    return Duration(milliseconds: state.progressMs);
  }

  Future<void> recordHistory(Episode episode) async {
    final uid = await _ensureEpisodeFromModel(episode);
    final db = await _dbService.isar;
    await db.writeTxn(() async {
      final state = await _ensureStateByUid(db, uid);
      state.lastPlayedAt = DateTime.now();
      state.playCount += 1;
      state.updatedAt = DateTime.now();
      await db.episodeStateEntitys.put(state);
    });
  }

  Future<List<Episode>> getHistory({int limit = 300}) async {
    final db = await _dbService.isar;
    final states = await db.episodeStateEntitys
        .filter()
        .lastPlayedAtIsNotNull()
        .sortByLastPlayedAtDesc()
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

  Stream<List<EpisodeView>> watchHistory({int limit = 100}) async* {
    final db = await _dbService.isar;
    final query = db.episodeStateEntitys
        .filter()
        .lastPlayedAtIsNotNull()
        .sortByLastPlayedAtDesc()
        .limit(limit)
        .build();

    yield* query.watch(fireImmediately: true).asyncMap((states) async {
      final result = <EpisodeView>[];
      for (final state in states) {
        final episode =
            await _libraryRepository.findEpisodeByUid(state.episodeUid);
        if (episode == null) continue;
        result.add(
          EpisodeView(
            episode: episode,
            isFavorite:
                _hasFlag(state.statusFlags, EpisodeStatusFlags.favorite),
            progressMs: state.progressMs,
            lastPlayedAt: state.lastPlayedAt,
            downloadStatus: state.downloadStatus,
          ),
        );
      }
      return result;
    });
  }

  Future<void> setFavorite(String episodeUid, bool value) async {
    final db = await _dbService.isar;
    await db.writeTxn(() async {
      final state = await _ensureStateByUid(db, episodeUid);
      state.statusFlags =
          _setFlag(state.statusFlags, EpisodeStatusFlags.favorite, value);
      state.favoriteAt = value ? DateTime.now() : null;
      state.updatedAt = DateTime.now();
      await db.episodeStateEntitys.put(state);
    });
  }

  Future<void> toggleFavoriteEpisode(Episode episode) async {
    final uid = await _ensureEpisodeFromModel(episode);
    final favored = await isFavoriteByUid(uid);
    await setFavorite(uid, !favored);
  }

  Future<void> addFavorite(Episode episode) async {
    final uid = await _ensureEpisodeFromModel(episode);
    await setFavorite(uid, true);
  }

  Future<void> removeFavoriteByGuid(String guid) async {
    final uid = await _libraryRepository.findEpisodeUidByGuid(guid);
    if (uid == null) return;
    await setFavorite(uid, false);
  }

  Future<bool> isFavoriteByGuid(String guid) async {
    final uid = await _libraryRepository.findEpisodeUidByGuid(guid);
    if (uid == null) return false;
    return isFavoriteByUid(uid);
  }

  Future<bool> isFavoriteByUid(String uid) async {
    final db = await _dbService.isar;
    final state = await db.episodeStateEntitys
        .filter()
        .episodeUidEqualTo(uid)
        .findFirst();
    if (state == null) return false;
    return _hasFlag(state.statusFlags, EpisodeStatusFlags.favorite);
  }

  Future<List<Episode>> getFavorites({int limit = 500}) async {
    final db = await _dbService.isar;
    final states = await db.episodeStateEntitys
        .filter()
        .favoriteAtIsNotNull()
        .sortByFavoriteAtDesc()
        .limit(limit)
        .findAll();

    final episodes = <Episode>[];
    for (final state in states) {
      final episode =
          await _libraryRepository.findEpisodeByUid(state.episodeUid);
      if (episode != null) episodes.add(episode);
    }
    return episodes;
  }

  Stream<List<EpisodeView>> watchFavorites({int limit = 100}) async* {
    final db = await _dbService.isar;
    final query = db.episodeStateEntitys
        .filter()
        .favoriteAtIsNotNull()
        .sortByFavoriteAtDesc()
        .limit(limit)
        .build();

    yield* query.watch(fireImmediately: true).asyncMap((states) async {
      final result = <EpisodeView>[];
      for (final state in states) {
        final episode =
            await _libraryRepository.findEpisodeByUid(state.episodeUid);
        if (episode == null) continue;
        result.add(
          EpisodeView(
            episode: episode,
            isFavorite: true,
            progressMs: state.progressMs,
            lastPlayedAt: state.lastPlayedAt,
            downloadStatus: state.downloadStatus,
          ),
        );
      }
      return result;
    });
  }

  Future<void> setPodcastSpeed(String feedUrl, double speed) async {
    final db = await _dbService.isar;
    final podcastUid = await _libraryRepository.ensurePodcastUidForFeed(
      feedUrl,
      subscribed: false,
    );
    await db.writeTxn(() async {
      final pref = await db.podcastPreferenceEntitys
              .filter()
              .podcastUidEqualTo(podcastUid)
              .findFirst() ??
          PodcastPreferenceEntity()
        ..podcastUid = podcastUid;
      pref.speed = speed;
      pref.updatedAt = DateTime.now();
      await db.podcastPreferenceEntitys.put(pref);
    });
  }

  Future<void> removePodcastSpeed(String feedUrl) async {
    final db = await _dbService.isar;
    final podcastUid = await _libraryRepository.ensurePodcastUidForFeed(
      feedUrl,
      subscribed: false,
    );
    await db.writeTxn(() async {
      final pref = await db.podcastPreferenceEntitys
          .filter()
          .podcastUidEqualTo(podcastUid)
          .findFirst();
      if (pref == null) return;
      pref.speed = null;
      pref.updatedAt = DateTime.now();
      await db.podcastPreferenceEntitys.put(pref);
    });
  }

  Future<double?> getPodcastSpeed(String feedUrl) async {
    final db = await _dbService.isar;
    final canonicalUrl = feedUrl.contains('://')
        ? normalizeUrl(feedUrl)
        : cacheCanonicalUrl(feedUrl);
    final podcastUid = podcastUidFromCanonicalUrl(canonicalUrl);
    final pref = await db.podcastPreferenceEntitys
        .filter()
        .podcastUidEqualTo(podcastUid)
        .findFirst();
    return pref?.speed;
  }

  Future<void> enqueue(
    String episodeUid, {
    QueueType queueType = QueueType.nowPlaying,
    int? index,
  }) async {
    final db = await _dbService.isar;
    await db.writeTxn(() async {
      final current = await db.queueItemEntitys
          .filter()
          .queueTypeEqualTo(queueType)
          .sortByOrderIndex()
          .findAll();

      var insertIndex = index ?? current.length;
      if (insertIndex < 0) insertIndex = 0;
      if (insertIndex > current.length) insertIndex = current.length;

      for (final item in current.reversed) {
        if (item.orderIndex >= insertIndex) {
          item.orderIndex += 1;
          await db.queueItemEntitys.put(item);
        }
      }

      final queueItem = QueueItemEntity()
        ..queueType = queueType
        ..orderIndex = insertIndex
        ..episodeUid = episodeUid
        ..addedAt = DateTime.now();
      await db.queueItemEntitys.put(queueItem);
    });
  }

  Future<void> reorderQueue(
    List<String> episodeUids, {
    QueueType queueType = QueueType.nowPlaying,
  }) async {
    final db = await _dbService.isar;
    await db.writeTxn(() async {
      final existing = await db.queueItemEntitys
          .filter()
          .queueTypeEqualTo(queueType)
          .findAll();
      await db.queueItemEntitys
          .deleteAll(existing.map((e) => e.isarId).toList(growable: false));

      for (var i = 0; i < episodeUids.length; i++) {
        final queueItem = QueueItemEntity()
          ..queueType = queueType
          ..orderIndex = i
          ..episodeUid = episodeUids[i]
          ..addedAt = DateTime.now();
        await db.queueItemEntitys.put(queueItem);
      }
    });
  }

  Future<List<String>> getQueueEpisodeUids({
    QueueType queueType = QueueType.nowPlaying,
  }) async {
    final db = await _dbService.isar;
    final queue = await db.queueItemEntitys
        .filter()
        .queueTypeEqualTo(queueType)
        .sortByOrderIndex()
        .findAll();
    return queue.map((e) => e.episodeUid).toList(growable: false);
  }

  Future<void> addTimeSaved(Duration saved) async {
    final current = await getTotalTimeSaved();
    await _settingsRepository.setInt(
      _timeSavedKey,
      current.inMilliseconds + saved.inMilliseconds,
    );
  }

  Future<Duration> getTotalTimeSaved() async {
    final ms = await _settingsRepository.getInt(_timeSavedKey) ?? 0;
    return Duration(milliseconds: ms);
  }

  Future<void> setSkipSilenceEnabled(bool enabled) {
    return _settingsRepository.setBool(_skipSilenceKey, enabled);
  }

  Future<bool> getSkipSilenceEnabled() async {
    return await _settingsRepository.getBool(_skipSilenceKey) ?? false;
  }

  Future<String?> _ensureEpisodeUidByGuid(String guid) async {
    final existing = await _libraryRepository.findEpisodeUidByGuid(guid);
    if (existing != null) return existing;
    return null;
  }

  Future<String> _ensureEpisodeFromModel(Episode episode) async {
    final existingUid =
        await _libraryRepository.findEpisodeUidByGuid(episode.guid);
    if (existingUid != null) return existingUid;

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

  Future<EpisodeStateEntity> _ensureStateByUid(db, String episodeUid) async {
    return await db.episodeStateEntitys
            .filter()
            .episodeUidEqualTo(episodeUid)
            .findFirst() ??
        (EpisodeStateEntity()..episodeUid = episodeUid);
  }

  bool _hasFlag(int flags, int mask) => (flags & mask) != 0;

  int _setFlag(int flags, int mask, bool value) {
    if (value) {
      return flags | mask;
    }
    return flags & ~mask;
  }
}
