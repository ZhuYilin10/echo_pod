import 'dart:async';

import 'package:isar/isar.dart';

import '../../core/models/episode.dart';
import '../../core/models/podcast.dart';
import '../db/database_service.dart';
import '../db/db_utils.dart';
import '../db/entities/db_enums.dart';
import '../db/entities/episode_content_entity.dart';
import '../db/entities/episode_entity.dart';
import '../db/entities/external_ref_entity.dart';
import '../db/entities/media_asset_entity.dart';
import '../db/entities/podcast_entity.dart';
import 'models.dart';

class LibraryRepository {
  LibraryRepository({DatabaseService? dbService})
      : _dbService = dbService ?? DatabaseService.instance;

  final DatabaseService _dbService;

  Future<void> upsertPodcast(PodcastDraft draft) async {
    final db = await _dbService.isar;
    final canonicalUrl = _canonicalForInput(draft.url);
    final uid = podcastUidFromCanonicalUrl(canonicalUrl);

    await db.writeTxn(() async {
      final entity = await db.podcastEntitys
              .filter()
              .uidEqualTo(uid)
              .findFirst() ??
          PodcastEntity()
        ..uid = uid
        ..canonicalUrl = canonicalUrl;

      entity.originalUrl =
          sanitizeAndTruncate(draft.url, maxChars: 4000) ?? draft.url;
      entity.title =
          sanitizeAndTruncate(draft.title, maxChars: 500) ?? draft.title;
      entity.author = sanitizeAndTruncate(draft.author, maxChars: 500);
      entity.description =
          sanitizeAndTruncate(draft.description, maxChars: 1800);
      entity.imageUrl = sanitizeAndTruncate(draft.imageUrl, maxChars: 4000);
      entity.sourceType = draft.sourceType;
      entity.isSubscribed = draft.isSubscribed;
      entity.autoDownload = draft.autoDownload;
      entity.groupName = draft.groupName;
      entity.sortOrder = draft.sortOrder;
      entity.updatedAt = DateTime.now();
      entity.extraJson = sanitizeAndTruncate(draft.extraJson, maxChars: 20000);

      await db.podcastEntitys.put(entity);

      await _upsertExternalRef(
        db,
        ownerType: ExternalOwnerType.podcast,
        ownerUid: uid,
        source: draft.sourceType,
        externalId: canonicalUrl,
        externalUrl: draft.url,
      );
    });
  }

  Future<String> ensurePodcastUidForFeed(
    String feedUrl, {
    String? title,
    SourceType? sourceType,
    bool subscribed = false,
  }) async {
    final db = await _dbService.isar;
    final canonicalUrl = _canonicalForInput(feedUrl);
    final uid = podcastUidFromCanonicalUrl(canonicalUrl);

    final existing =
        await db.podcastEntitys.filter().uidEqualTo(uid).findFirst();
    if (existing != null) return existing.uid;

    await upsertPodcast(
      PodcastDraft(
        url: feedUrl,
        title: title?.trim().isNotEmpty == true ? title!.trim() : feedUrl,
        sourceType: sourceType ?? _inferSourceType(feedUrl),
        isSubscribed: subscribed,
      ),
    );

    return uid;
  }

  Future<void> setPodcastSubscribed(String feedUrl, bool subscribed) async {
    final db = await _dbService.isar;
    final canonicalUrl = _canonicalForInput(feedUrl);
    final uid = podcastUidFromCanonicalUrl(canonicalUrl);

    await db.writeTxn(() async {
      final entity =
          await db.podcastEntitys.filter().uidEqualTo(uid).findFirst();
      if (entity == null) {
        final created = PodcastEntity()
          ..uid = uid
          ..canonicalUrl = canonicalUrl
          ..originalUrl = feedUrl
          ..title = feedUrl
          ..sourceType = _inferSourceType(feedUrl)
          ..isSubscribed = subscribed
          ..updatedAt = DateTime.now();
        await db.podcastEntitys.put(created);
        return;
      }
      entity.isSubscribed = subscribed;
      entity.updatedAt = DateTime.now();
      await db.podcastEntitys.put(entity);
    });
  }

  Future<bool> isSubscribed(String feedUrl) async {
    final db = await _dbService.isar;
    final canonicalUrl = _canonicalForInput(feedUrl);
    final entity = await db.podcastEntitys
        .filter()
        .canonicalUrlEqualTo(canonicalUrl)
        .findFirst();
    return entity?.isSubscribed ?? false;
  }

  Future<List<Podcast>> getSubscribedPodcasts() async {
    final db = await _dbService.isar;
    final entities = await db.podcastEntitys
        .filter()
        .isSubscribedEqualTo(true)
        .sortByUpdatedAtDesc()
        .findAll();
    return entities.map(_toPodcastModel).toList();
  }

  Stream<List<Podcast>> watchSubscribedPodcasts() async* {
    final db = await _dbService.isar;
    final query = db.podcastEntitys
        .filter()
        .isSubscribedEqualTo(true)
        .sortByUpdatedAtDesc()
        .build();
    yield* query.watch(fireImmediately: true).map(
          (entities) => entities.map(_toPodcastModel).toList(),
        );
  }

  Future<void> upsertEpisodes(
      String podcastUid, List<EpisodeDraft> episodes) async {
    final db = await _dbService.isar;
    final now = DateTime.now();

    await db.writeTxn(() async {
      for (final draft in episodes) {
        final normalizedAudio =
            draft.audioUrl == null || draft.audioUrl!.isEmpty
                ? null
                : normalizeUrl(draft.audioUrl!);
        final fingerprint = buildEpisodeFingerprint(
          podcastUid: podcastUid,
          guid: draft.guid,
          normalizedEnclosureUrl: normalizedAudio,
          title: draft.title,
          pubDate: draft.pubDate,
        );
        final episodeUid = episodeUidFromFingerprint(fingerprint);

        final entity = await db.episodeEntitys
                .filter()
                .uidEqualTo(episodeUid)
                .findFirst() ??
            EpisodeEntity()
          ..uid = episodeUid
          ..fingerprint = fingerprint
          ..podcastUid = podcastUid;

        entity.guid = sanitizeAndTruncate(draft.guid, maxChars: 1000);
        entity.title =
            sanitizeAndTruncate(draft.title, maxChars: 500) ?? draft.title;
        entity.subtitle = sanitizeAndTruncate(draft.subtitle, maxChars: 500);
        entity.description =
            sanitizeAndTruncate(draft.description, maxChars: 1800);
        entity.articleUrl =
            sanitizeAndTruncate(draft.articleUrl, maxChars: 4000);
        entity.pubDate = draft.pubDate;
        entity.durationMs = draft.durationMs;
        entity.imageUrl = sanitizeAndTruncate(draft.imageUrl, maxChars: 4000);
        entity.fetchedAt = now;
        entity.updatedAt = now;
        entity.extraJson =
            sanitizeAndTruncate(draft.extraJson, maxChars: 20000);

        if (normalizedAudio != null) {
          final mediaUid = mediaUidFromUrl(episodeUid, normalizedAudio);
          entity.primaryMediaUid = mediaUid;

          final media = await db.mediaAssetEntitys
                  .filter()
                  .uidEqualTo(mediaUid)
                  .findFirst() ??
              MediaAssetEntity()
            ..uid = mediaUid
            ..episodeUid = episodeUid
            ..mediaType = MediaType.audio;

          media.urlOriginal =
              sanitizeAndTruncate(draft.audioUrl, maxChars: 4000) ??
                  draft.audioUrl!;
          media.urlNormalized = normalizedAudio;
          media.mimeType = sanitizeAndTruncate(draft.mimeType, maxChars: 255);
          media.isPreferred = true;
          media.updatedAt = now;
          await db.mediaAssetEntitys.put(media);

          await _upsertExternalRef(
            db,
            ownerType: ExternalOwnerType.media,
            ownerUid: mediaUid,
            source: SourceType.rss,
            externalId: normalizedAudio,
            externalUrl: sanitizeAndTruncate(draft.audioUrl, maxChars: 4000),
          );
        }

        await db.episodeEntitys.put(entity);

        final content = await db.episodeContentEntitys
                .filter()
                .episodeUidEqualTo(episodeUid)
                .findFirst() ??
            EpisodeContentEntity()
          ..episodeUid = episodeUid;
        final sanitizedContent = sanitizeAndTruncate(
          draft.description,
          maxChars: 120000,
        );
        content.shownotesHtml = sanitizedContent;
        content.shownotesText = sanitizedContent;
        content.updatedAt = now;
        await db.episodeContentEntitys.put(content);

        await _upsertExternalRef(
          db,
          ownerType: ExternalOwnerType.episode,
          ownerUid: episodeUid,
          source: SourceType.rss,
          externalId:
              sanitizeAndTruncate(draft.guid, maxChars: 1000) ?? fingerprint,
          externalUrl: sanitizeAndTruncate(draft.articleUrl, maxChars: 4000),
        );
      }

      final podcast =
          await db.podcastEntitys.filter().uidEqualTo(podcastUid).findFirst();
      if (podcast != null) {
        podcast.lastFetchedAt = now;
        podcast.updatedAt = now;
        await db.podcastEntitys.put(podcast);
      }
    });
  }

  Future<List<Episode>> getEpisodesByPodcastUid(
    String podcastUid, {
    int? limit,
    int offset = 0,
  }) async {
    final db = await _dbService.isar;
    final podcast =
        await db.podcastEntitys.filter().uidEqualTo(podcastUid).findFirst();
    if (podcast == null) return [];

    final entities = await db.episodeEntitys
        .filter()
        .podcastUidEqualTo(podcastUid)
        .sortByPubDateDesc()
        .findAll();

    final sliced = _slice(entities, offset: offset, limit: limit);

    return Future.wait(
        sliced.map((e) => _toEpisodeModel(db, e, podcast: podcast)));
  }

  Stream<List<EpisodeView>> watchPodcastEpisodes(
    String podcastUid, {
    int limit = 50,
    int offset = 0,
  }) async* {
    final db = await _dbService.isar;
    final query = db.episodeEntitys
        .filter()
        .podcastUidEqualTo(podcastUid)
        .sortByPubDateDesc()
        .build();

    yield* query.watch(fireImmediately: true).asyncMap((entities) async {
      final podcast =
          await db.podcastEntitys.filter().uidEqualTo(podcastUid).findFirst();
      if (podcast == null) return const <EpisodeView>[];
      final sliced = _slice(entities, offset: offset, limit: limit);
      final views = <EpisodeView>[];
      for (final entity in sliced) {
        final episode = await _toEpisodeModel(db, entity, podcast: podcast);
        views.add(EpisodeView(episode: episode));
      }
      return views;
    });
  }

  Future<Episode?> findEpisodeByGuid(String guid) async {
    final db = await _dbService.isar;
    final entities = await db.episodeEntitys
        .filter()
        .guidEqualTo(guid)
        .sortByUpdatedAtDesc()
        .findAll();
    if (entities.isEmpty) return null;

    final entity = entities.first;
    final podcast = await db.podcastEntitys
        .filter()
        .uidEqualTo(entity.podcastUid)
        .findFirst();
    if (podcast == null) return null;

    return _toEpisodeModel(db, entity, podcast: podcast);
  }

  Future<Episode?> findEpisodeByUid(String episodeUid) async {
    final db = await _dbService.isar;
    final entity =
        await db.episodeEntitys.filter().uidEqualTo(episodeUid).findFirst();
    if (entity == null) return null;
    final podcast = await db.podcastEntitys
        .filter()
        .uidEqualTo(entity.podcastUid)
        .findFirst();
    if (podcast == null) return null;
    return _toEpisodeModel(db, entity, podcast: podcast);
  }

  Future<String?> findEpisodeUidByGuid(String guid) async {
    final db = await _dbService.isar;
    final entity =
        await db.episodeEntitys.filter().guidEqualTo(guid).findFirst();
    return entity?.uid;
  }

  Future<void> saveFeedCache(String feedUrl, List<Episode> episodes) async {
    final sourceType =
        feedUrl.startsWith('cache://') || !feedUrl.contains('://')
            ? SourceType.cache
            : _inferSourceType(feedUrl);
    final podcastUid = await ensurePodcastUidForFeed(
      feedUrl,
      title: episodes.isNotEmpty ? episodes.first.podcastTitle : feedUrl,
      sourceType: sourceType,
      subscribed: false,
    );

    final drafts = episodes
        .map(
          (episode) => EpisodeDraft(
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
        )
        .toList();

    await upsertEpisodes(podcastUid, drafts);
  }

  Future<List<Episode>?> getFeedCache(String feedUrl) async {
    final db = await _dbService.isar;
    final canonicalUrl = _canonicalForInput(feedUrl);
    final podcastUid = podcastUidFromCanonicalUrl(canonicalUrl);
    final podcast =
        await db.podcastEntitys.filter().uidEqualTo(podcastUid).findFirst();
    if (podcast == null) return null;

    final episodes = await getEpisodesByPodcastUid(podcastUid);
    return episodes.isEmpty ? null : episodes;
  }

  Future<DateTime?> getFeedCacheTime(String feedUrl) async {
    final db = await _dbService.isar;
    final canonicalUrl = _canonicalForInput(feedUrl);
    final podcastUid = podcastUidFromCanonicalUrl(canonicalUrl);
    final podcast =
        await db.podcastEntitys.filter().uidEqualTo(podcastUid).findFirst();
    return podcast?.lastFetchedAt;
  }

  Future<Podcast?> getPodcastByFeedUrl(String feedUrl) async {
    final db = await _dbService.isar;
    final canonicalUrl = _canonicalForInput(feedUrl);
    final podcast = await db.podcastEntitys
        .filter()
        .canonicalUrlEqualTo(canonicalUrl)
        .findFirst();
    if (podcast == null) return null;
    return _toPodcastModel(podcast);
  }

  Podcast _toPodcastModel(PodcastEntity entity) {
    return Podcast(
      feedUrl: entity.originalUrl,
      title: entity.title,
      artist: entity.author,
      imageUrl: entity.imageUrl,
      description: entity.description,
      unreadCount: 0,
    );
  }

  Future<Episode> _toEpisodeModel(
    Isar db,
    EpisodeEntity entity, {
    required PodcastEntity podcast,
  }) async {
    String? audioUrl;
    if (entity.primaryMediaUid != null) {
      final media = await db.mediaAssetEntitys
          .filter()
          .uidEqualTo(entity.primaryMediaUid!)
          .findFirst();
      audioUrl = media?.urlOriginal;
    }

    return Episode(
      guid: entity.guid ?? entity.uid,
      title: entity.title,
      description: entity.description,
      pubDate: entity.pubDate,
      audioUrl: audioUrl,
      duration: entity.durationMs == null
          ? null
          : (entity.durationMs! / 1000).round().toString(),
      imageUrl: entity.imageUrl ?? podcast.imageUrl,
      podcastTitle: podcast.title,
      podcastFeedUrl: podcast.originalUrl,
      articleUrl: entity.articleUrl,
    );
  }

  Future<void> _upsertExternalRef(
    Isar db, {
    required ExternalOwnerType ownerType,
    required String ownerUid,
    required SourceType source,
    required String externalId,
    String? externalUrl,
    int priority = 0,
    String? extraJson,
  }) async {
    final existing = await db.externalRefEntitys
        .filter()
        .sourceEqualTo(source)
        .and()
        .externalIdEqualTo(externalId)
        .findFirst();

    final ref = existing ?? ExternalRefEntity();
    ref.ownerType = ownerType;
    ref.ownerUid = ownerUid;
    ref.source = source;
    ref.externalId =
        sanitizeAndTruncate(externalId, maxChars: 2000) ?? externalId;
    ref.externalUrl = sanitizeAndTruncate(externalUrl, maxChars: 4000);
    ref.priority = priority;
    ref.fetchedAt = DateTime.now();
    ref.extraJson = sanitizeAndTruncate(extraJson, maxChars: 20000);
    await db.externalRefEntitys.put(ref);
  }

  SourceType _inferSourceType(String url) {
    if (url.startsWith('freshrss://')) return SourceType.freshRss;
    if (url.startsWith('echopod://bilibili/')) return SourceType.bilibili;
    if (url.contains('youtube.com') || url.contains('youtu.be')) {
      return SourceType.youtube;
    }
    if (url.startsWith('cache://') || !url.contains('://')) {
      return SourceType.cache;
    }
    return SourceType.rss;
  }

  String _canonicalForInput(String input) {
    if (input.startsWith('cache://')) return input;
    if (!input.contains('://')) {
      return cacheCanonicalUrl(input);
    }
    return normalizeUrl(input);
  }

  List<T> _slice<T>(List<T> source, {required int offset, int? limit}) {
    if (offset >= source.length) return const [];
    final start = offset < 0 ? 0 : offset;
    if (limit == null) return source.sublist(start);
    final end = (start + limit).clamp(0, source.length);
    return source.sublist(start, end);
  }
}
