import 'dart:math';
import '../storage/storage_service.dart';
import '../podcast_service.dart';
import '../ai/ai_content_service.dart';
import 'widget_service.dart';
import '../../core/models/episode.dart';

class WidgetContentManager {
  final StorageService _storage;
  final PodcastService _podcast;
  final AIContentService _ai;
  final WidgetService _widget;

  WidgetContentManager(this._storage, this._podcast, this._ai, this._widget);

  /// Selects a random episode from current subscriptions,
  /// extracts a golden sentence, and updates the iOS widget.
  Future<void> refreshWidgetContent() async {
    final subs = await _storage.getSubscriptions();
    if (subs.isEmpty) return;

    // Pick a random podcast
    final randomPodcast = subs[Random().nextInt(subs.length)];
    
    // Fetch its latest episodes
    final episodes = await _podcast.fetchEpisodes(randomPodcast.feedUrl);
    if (episodes.isEmpty) return;

    // Pick the most recent episode (or a random one from recent)
    final episode = episodes.first;

    // Extract quote using AI
    final quote = await _ai.getEpisodeSummary(
      '提取分享金句: ${episode.title}',
      '请从以下播客描述中提取或润色一句极具启发性的金句，用于桌面小组件展示。描述: ${episode.description}',
    );

    // Update the native widget
    await _widget.updateQuoteWidget(
      quote: quote,
      author: episode.podcastTitle,
      imageUrl: episode.imageUrl ?? '',
    );
  }
}
