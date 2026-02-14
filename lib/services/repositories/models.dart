import '../../core/models/episode.dart';
import '../../core/models/podcast.dart';
import '../db/db_utils.dart';
import '../db/entities/db_enums.dart';

class PodcastDraft {
  PodcastDraft({
    required this.url,
    required this.title,
    this.author,
    this.description,
    this.imageUrl,
    this.sourceType = SourceType.rss,
    this.isSubscribed = true,
    this.autoDownload = false,
    this.groupName,
    this.sortOrder,
    this.extraJson,
  });

  final String url;
  final String title;
  final String? author;
  final String? description;
  final String? imageUrl;
  final SourceType sourceType;
  final bool isSubscribed;
  final bool autoDownload;
  final String? groupName;
  final int? sortOrder;
  final String? extraJson;
}

class EpisodeDraft {
  EpisodeDraft({
    required this.podcastUid,
    required this.title,
    this.guid,
    this.subtitle,
    this.description,
    this.pubDate,
    this.durationMs,
    this.imageUrl,
    this.audioUrl,
    this.articleUrl,
    this.mimeType,
    this.extraJson,
  });

  final String podcastUid;
  final String title;
  final String? guid;
  final String? subtitle;
  final String? description;
  final DateTime? pubDate;
  final int? durationMs;
  final String? imageUrl;
  final String? audioUrl;
  final String? articleUrl;
  final String? mimeType;
  final String? extraJson;
}

class EpisodeView {
  EpisodeView({
    required this.episode,
    this.isFavorite = false,
    this.progressMs = 0,
    this.lastPlayedAt,
    this.downloadStatus = DownloadStatus.none,
  });

  final Episode episode;
  final bool isFavorite;
  final int progressMs;
  final DateTime? lastPlayedAt;
  final DownloadStatus downloadStatus;
}

extension PodcastToDraft on Podcast {
  PodcastDraft toDraft({SourceType sourceType = SourceType.rss}) {
    return PodcastDraft(
      url: feedUrl,
      title: title,
      author: artist,
      description: description,
      imageUrl: imageUrl,
      sourceType: sourceType,
      isSubscribed: true,
    );
  }
}

extension EpisodeToDraft on Episode {
  EpisodeDraft toDraft({required String podcastUid}) {
    return EpisodeDraft(
      podcastUid: podcastUid,
      title: title,
      guid: guid,
      description: description,
      pubDate: pubDate,
      durationMs: parseDurationToMs(duration),
      imageUrl: imageUrl,
      audioUrl: audioUrl,
      articleUrl: articleUrl,
    );
  }
}
