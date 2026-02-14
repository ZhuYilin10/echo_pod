import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/podcast_service.dart';
import '../../services/storage/storage_service.dart';
import '../../services/audio/audio_handler.dart';
import '../../services/db/database_service.dart';
import '../models/podcast.dart';
import '../models/episode.dart';

import '../../services/ai/ai_content_service.dart';
import '../../services/discovery_service.dart';
import '../../services/platform/live_activity_service.dart';

import '../../services/download/download_service.dart';
import '../../services/repositories/download_repository.dart';
import '../../services/repositories/library_repository.dart';
import '../../services/repositories/playback_repository.dart';
import '../../services/repositories/settings_repository.dart';
import '../../services/repositories/sync_repository.dart';
import '../../services/semantic_search_service.dart';
import '../../services/xiaoyuzhou_parser_service.dart';
import '../../services/freshrss_service.dart';
import '../../services/platform/widget_service.dart';
import '../../services/platform/widget_content_manager.dart';
import '../../services/security/secure_credential_store.dart';

final freshrssServiceProvider = Provider((ref) => FreshRssService());

final freshrssEpisodesProvider = FutureProvider<List<Episode>>((ref) async {
  final storage = ref.watch(storageServiceProvider);
  final config = await storage.getFreshRssConfig();
  if (config['url'] == null) return [];

  final service = ref.read(freshrssServiceProvider);
  service.configure(config['url']!, config['user']!, config['pass']!);
  return service.fetchRecentEpisodes(50);
});

final freshrssSubscriptionsProvider =
    FutureProvider<List<Podcast>>((ref) async {
  final storage = ref.watch(storageServiceProvider);
  final config = await storage.getFreshRssConfig();
  if (config['url'] == null) return [];

  final service = ref.read(freshrssServiceProvider);
  // Configure is idempotent and safe to call multiple times or if already configured
  service.configure(config['url']!, config['user']!, config['pass']!);
  return service.fetchSubscriptions();
});

final databaseServiceProvider = Provider((ref) => DatabaseService.instance);
final secureCredentialStoreProvider =
    Provider((ref) => SecureCredentialStore());
final settingsRepositoryProvider = Provider((ref) => SettingsRepository(
      dbService: ref.watch(databaseServiceProvider),
    ));
final libraryRepositoryProvider = Provider((ref) => LibraryRepository(
      dbService: ref.watch(databaseServiceProvider),
    ));
final playbackRepositoryProvider = Provider((ref) => PlaybackRepository(
      libraryRepository: ref.watch(libraryRepositoryProvider),
      settingsRepository: ref.watch(settingsRepositoryProvider),
      dbService: ref.watch(databaseServiceProvider),
    ));
final downloadRepositoryProvider = Provider((ref) => DownloadRepository(
      libraryRepository: ref.watch(libraryRepositoryProvider),
      dbService: ref.watch(databaseServiceProvider),
    ));
final syncRepositoryProvider = Provider((ref) => SyncRepository(
      dbService: ref.watch(databaseServiceProvider),
    ));

final podcastServiceProvider = Provider((ref) => PodcastService(
      xiaoyuzhouParser: ref.watch(xiaoyuzhouParserServiceProvider),
      freshRssService: ref.watch(freshrssServiceProvider),
      storageService: ref.watch(storageServiceProvider),
    ));
final storageServiceProvider = Provider((ref) => StorageService(
      libraryRepository: ref.watch(libraryRepositoryProvider),
      playbackRepository: ref.watch(playbackRepositoryProvider),
      downloadRepository: ref.watch(downloadRepositoryProvider),
      settingsRepository: ref.watch(settingsRepositoryProvider),
      syncRepository: ref.watch(syncRepositoryProvider),
      credentialStore: ref.watch(secureCredentialStoreProvider),
    ));
final discoveryServiceProvider = Provider((ref) => DiscoveryService());
final downloadServiceProvider = Provider((ref) => DownloadService());
final activeDownloadsProvider = StreamProvider<Map<String, double>>((ref) {
  final downloadService = ref.watch(downloadServiceProvider);
  return downloadService.downloadProgressStream;
});
final semanticSearchServiceProvider =
    Provider((ref) => SemanticSearchService());
final xiaoyuzhouParserServiceProvider =
    Provider((ref) => XiaoyuzhouParserService());
final widgetServiceProvider = Provider((ref) => WidgetService());

final widgetContentManagerProvider = Provider((ref) => WidgetContentManager(
      ref.watch(storageServiceProvider),
      ref.watch(podcastServiceProvider),
      ref.watch(aiServiceProvider),
      ref.watch(widgetServiceProvider),
    ));
final liveActivityServiceProvider = Provider((ref) => LiveActivityService());
final aiServiceProvider = Provider((ref) {
  const apiKey = String.fromEnvironment('OPENAI_API_KEY', defaultValue: '');
  return AIContentService(apiKey: apiKey);
});

final audioHandlerProvider = Provider<EchoPodAudioHandler>((ref) {
  throw UnimplementedError(); // Initialized in main
});

class PlayHistoryNotifier extends StateNotifier<AsyncValue<List<Episode>>> {
  final StorageService _storage;
  PlayHistoryNotifier(this._storage) : super(const AsyncValue.loading()) {
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    try {
      final history = await _storage.getPlayHistory();
      state = AsyncValue.data(history);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  void refresh() {
    _loadHistory();
  }
}

final playHistoryNotifierProvider =
    StateNotifierProvider<PlayHistoryNotifier, AsyncValue<List<Episode>>>(
        (ref) {
  final storage = ref.watch(storageServiceProvider);
  return PlayHistoryNotifier(storage);
});

class FavoritesNotifier extends StateNotifier<AsyncValue<List<Episode>>> {
  final StorageService _storage;
  FavoritesNotifier(this._storage) : super(const AsyncValue.loading()) {
    _load();
  }

  Future<void> _load() async {
    try {
      final list = await _storage.getFavorites();
      state = AsyncValue.data(list);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> toggle(Episode episode) async {
    final current = state.valueOrNull ?? [];
    final isFav = current.any((e) => e.guid == episode.guid);
    if (isFav) {
      await _storage.removeFavorite(episode.guid);
    } else {
      await _storage.addFavorite(episode);
    }
    await _load();
  }

  void refresh() => _load();
}

final favoritesNotifierProvider =
    StateNotifierProvider<FavoritesNotifier, AsyncValue<List<Episode>>>((ref) {
  final storage = ref.watch(storageServiceProvider);
  return FavoritesNotifier(storage);
});

final subscriptionsProvider = FutureProvider<List<Podcast>>((ref) async {
  final storage = ref.watch(storageServiceProvider);
  return storage.getSubscriptions();
});

final recommendationsProvider = FutureProvider<List<Podcast>>((ref) async {
  final discovery = ref.watch(discoveryServiceProvider);
  return discovery.fetchDailyRecommendations();
});

final genrePodcastsProvider =
    FutureProvider.family<List<Podcast>, String>((ref, genreId) async {
  final discovery = ref.watch(discoveryServiceProvider);
  if (genreId == 'all') {
    return discovery.fetchDailyRecommendations();
  }
  return discovery.fetchByGenre(genreId);
});

final recentSubscribedEpisodesProvider =
    FutureProvider<List<Episode>>((ref) async {
  final storage = ref.watch(storageServiceProvider);
  final podcastService = ref.watch(podcastServiceProvider);
  final subs = await storage.getSubscriptions();

  // Use the service method which handles caching
  final allEpisodes = await podcastService.fetchRecentEpisodesFromLocal(subs,
      episodesPerPodcast: 3);

  // Sort by date descending
  allEpisodes.sort((a, b) {
    if (a.pubDate == null || b.pubDate == null) return 0;
    return b.pubDate!.compareTo(a.pubDate!);
  });

  return allEpisodes.take(30).toList();
});

final trendingEpisodesProvider = FutureProvider<List<Episode>>((ref) async {
  final podcastService = ref.watch(podcastServiceProvider);
  return podcastService.fetchTrendingEpisodes();
});

final searchQueryProvider = StateProvider<String>((ref) => '');

final searchResultsProvider = FutureProvider<List<Podcast>>((ref) async {
  final query = ref.watch(searchQueryProvider);
  if (query.isEmpty) return [];

  final podcastService = ref.watch(podcastServiceProvider);
  return podcastService.searchPodcasts(query);
});

final downloadedEpisodesProvider = FutureProvider<List<Episode>>((ref) async {
  final storage = ref.watch(storageServiceProvider);
  return storage.getDownloadedEpisodes();
});

final isSubscribedProvider =
    FutureProvider.family<bool, String>((ref, feedUrl) async {
  final storage = ref.watch(storageServiceProvider);
  return storage.isSubscribed(feedUrl);
});

/// 统一的动态 Provider：合并本地订阅和 FreshRSS，过滤近 7 天并排除已播放
final unifiedRecentEpisodesProvider =
    FutureProvider<List<Episode>>((ref) async {
  final podcastService = ref.watch(podcastServiceProvider);
  final storage = ref.watch(storageServiceProvider);

  // 1. 获取本地订阅剧集
  final localSubs = await storage.getSubscriptions();
  final localRecentFuture =
      podcastService.fetchRecentEpisodesFromLocal(localSubs);

  // 2. 获取 FreshRSS 动态
  final freshRssRecentFuture = ref.watch(freshrssEpisodesProvider.future);

  // 3. 并行等待数据
  final results = await Future.wait([localRecentFuture, freshRssRecentFuture]);
  final List<Episode> allRawEpisodes = results.expand((e) => e).toList();

  // 4. 获取播放历史用于过滤
  final history = await storage.getPlayHistory();
  final historyGuids = history.map((e) => e.guid).toSet();

  // 5. 过滤逻辑
  final now = DateTime.now();
  final sevenDaysAgo = now.subtract(const Duration(days: 7));
  final Map<String, Episode> uniqueEpisodes = {};

  for (final episode in allRawEpisodes) {
    // 过滤：已播放的单集不再显示
    if (historyGuids.contains(episode.guid)) continue;

    // 过滤：仅限过去 7 天
    if (episode.pubDate != null && episode.pubDate!.isBefore(sevenDaysAgo))
      continue;

    // 去重：以 guid 为准
    if (!uniqueEpisodes.containsKey(episode.guid)) {
      uniqueEpisodes[episode.guid] = episode;
    }
  }

  final List<Episode> filteredEpisodes = uniqueEpisodes.values.toList();

  // 6. 排序：按发布时间倒序
  filteredEpisodes.sort((a, b) {
    if (a.pubDate == null || b.pubDate == null) return 0;
    return b.pubDate!.compareTo(a.pubDate!);
  });

  return filteredEpisodes;
});
