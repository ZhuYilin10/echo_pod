import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:audio_service/audio_service.dart';
import '../../services/podcast_service.dart';
import '../../services/storage/storage_service.dart';
import '../../services/ai/ai_service.dart';
import '../../services/audio/audio_handler.dart';
import '../models/podcast.dart';

import '../../services/ai/ai_content_service.dart';
import '../../services/discovery_service.dart';
import '../../services/platform/live_activity_service.dart';

import '../../services/download/download_service.dart';
import '../../services/semantic_search_service.dart';

import '../../services/platform/widget_service.dart';
import '../../services/platform/widget_content_manager.dart';

final podcastServiceProvider = Provider((ref) => PodcastService());
final storageServiceProvider = Provider((ref) => StorageService());
final discoveryServiceProvider = Provider((ref) => DiscoveryService());
final downloadServiceProvider = Provider((ref) => DownloadService());
final semanticSearchServiceProvider = Provider((ref) => SemanticSearchService());
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

final isSubscribedProvider = FutureProvider.family<bool, String>((ref, feedUrl) async {
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
