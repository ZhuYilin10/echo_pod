import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/podcast_service.dart';
import '../../services/storage/storage_service.dart';
import '../../services/audio/audio_handler.dart';
import '../models/podcast.dart';
import '../models/episode.dart';

import '../../services/ai/ai_content_service.dart';
import '../../services/discovery_service.dart';
import '../../services/platform/live_activity_service.dart';

import '../../services/download/download_service.dart';
import '../../services/semantic_search_service.dart';
import '../../services/xiaoyuzhou_parser_service.dart';
import '../../services/freshrss_service.dart';
import '../../services/platform/widget_service.dart';
import '../../services/platform/widget_content_manager.dart';

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

final podcastServiceProvider = Provider((ref) => PodcastService(
      xiaoyuzhouParser: ref.watch(xiaoyuzhouParserServiceProvider),
      freshRssService: ref.watch(freshrssServiceProvider),
      storageService: ref.watch(storageServiceProvider),
    ));
final storageServiceProvider = Provider((ref) => StorageService());
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

final isSubscribedProvider =
    FutureProvider.family<bool, String>((ref, feedUrl) async {
  final storage = ref.watch(storageServiceProvider);
  return storage.isSubscribed(feedUrl);
});

final downloadedEpisodesProvider = FutureProvider<List<Episode>>((ref) async {
  final storage = ref.watch(storageServiceProvider);
  return storage.getDownloadedEpisodes();
});

final playHistoryProvider = FutureProvider<List<Episode>>((ref) async {
  final storage = ref.watch(storageServiceProvider);
  return storage.getPlayHistory();
});

final recentSubscribedEpisodesProvider =
    FutureProvider<List<Episode>>((ref) async {
  final storage = ref.watch(storageServiceProvider);
  final podcastService = ref.watch(podcastServiceProvider);
  final subs = await storage.getSubscriptions();

  // Fetch episodes in parallel for better performance
  final results = await Future.wait(
    subs.map((podcast) => podcastService.fetchEpisodes(podcast.feedUrl).then(
          (episodes) => episodes.take(3).toList(),
          onError: (_) =>
              <Episode>[], // Ignore failed fetches for individual podcasts
        )),
  );

  final List<Episode> allEpisodes = results.expand((e) => e).toList();

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
  final history = await ref.watch(playHistoryProvider.future);
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
