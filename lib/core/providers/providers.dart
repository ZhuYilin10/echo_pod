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

final freshrssServiceProvider = Provider((ref) => FreshRssService());

final freshrssEpisodesProvider = FutureProvider<List<Episode>>((ref) async {
  final storage = ref.watch(storageServiceProvider);
  final config = await storage.getFreshRssConfig();
  if (config['url'] == null) return [];

  final service = ref.read(freshrssServiceProvider);
  service.configure(config['url']!, config['user']!, config['pass']!);
  return service.fetchRecentEpisodes();
});

import '../../services/platform/widget_service.dart';
import '../../services/platform/widget_content_manager.dart';

final podcastServiceProvider = Provider((ref) => PodcastService(
      xiaoyuzhouParser: ref.watch(xiaoyuzhouParserServiceProvider),
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
