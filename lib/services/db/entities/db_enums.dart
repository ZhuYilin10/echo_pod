enum SourceType {
  rss,
  bilibili,
  youtube,
  webHtml,
  freshRss,
  itunes,
  xyzrank,
  manual,
  cache,
}

enum MediaType {
  audio,
  video,
}

enum ResolverType {
  rss,
  bilibiliApi,
  parser,
  rssHub,
  web,
  unknown,
}

enum ExternalOwnerType {
  podcast,
  episode,
  media,
}

enum DownloadStatus {
  none,
  queued,
  downloading,
  completed,
  failed,
}

enum QueueType {
  nowPlaying,
  manual,
  auto,
}

enum SyncStatus {
  idle,
  running,
  error,
}

class EpisodeStatusFlags {
  static const int favorite = 1 << 0;
  static const int read = 1 << 1;
  static const int played = 1 << 2;
  static const int skipped = 1 << 3;
}
