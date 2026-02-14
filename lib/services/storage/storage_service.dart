import '../../core/models/episode.dart';
import '../../core/models/podcast.dart';
import '../../core/theme/theme_config.dart';
import '../db/entities/db_enums.dart';
import '../repositories/download_repository.dart';
import '../repositories/library_repository.dart';
import '../repositories/models.dart';
import '../repositories/playback_repository.dart';
import '../repositories/settings_repository.dart';
import '../repositories/sync_repository.dart';
import '../security/secure_credential_store.dart';

class StorageService {
  factory StorageService({
    LibraryRepository? libraryRepository,
    PlaybackRepository? playbackRepository,
    DownloadRepository? downloadRepository,
    SettingsRepository? settingsRepository,
    SyncRepository? syncRepository,
    SecureCredentialStore? credentialStore,
  }) {
    final sharedLibrary = libraryRepository ?? LibraryRepository();
    final sharedSettings = settingsRepository ?? SettingsRepository();
    return StorageService._(
      libraryRepository: sharedLibrary,
      playbackRepository: playbackRepository ??
          PlaybackRepository(
            libraryRepository: sharedLibrary,
            settingsRepository: sharedSettings,
          ),
      downloadRepository: downloadRepository ??
          DownloadRepository(
            libraryRepository: sharedLibrary,
          ),
      settingsRepository: sharedSettings,
      syncRepository: syncRepository ?? SyncRepository(),
      credentialStore: credentialStore ?? SecureCredentialStore(),
    );
  }

  StorageService._({
    required LibraryRepository libraryRepository,
    required PlaybackRepository playbackRepository,
    required DownloadRepository downloadRepository,
    required SettingsRepository settingsRepository,
    required SyncRepository syncRepository,
    required SecureCredentialStore credentialStore,
  })  : _libraryRepository = libraryRepository,
        _playbackRepository = playbackRepository,
        _downloadRepository = downloadRepository,
        _settingsRepository = settingsRepository,
        _syncRepository = syncRepository,
        _credentialStore = credentialStore;

  final LibraryRepository _libraryRepository;
  final PlaybackRepository _playbackRepository;
  final DownloadRepository _downloadRepository;
  final SettingsRepository _settingsRepository;
  final SyncRepository _syncRepository;
  final SecureCredentialStore _credentialStore;

  Future<void> saveFreshRssConfig(String url, String user, String pass) async {
    await _credentialStore.saveFreshRssCredential(
      FreshRssCredential(url: url, user: user, pass: pass),
    );
  }

  Future<void> clearFreshRssConfig() async {
    await _credentialStore.clearFreshRssCredential();
  }

  Future<Map<String, String?>> getFreshRssConfig() async {
    final credential = await _credentialStore.readFreshRssCredential();
    return {
      'url': credential?.url,
      'user': credential?.user,
      'pass': credential?.pass,
    };
  }

  Future<void> savePodcastSpeed(String feedUrl, double speed) async {
    await _playbackRepository.setPodcastSpeed(feedUrl, speed);
  }

  Future<void> removePodcastSpeed(String feedUrl) async {
    await _playbackRepository.removePodcastSpeed(feedUrl);
  }

  Future<double?> getPodcastSpeed(String feedUrl) async {
    return _playbackRepository.getPodcastSpeed(feedUrl);
  }

  Future<void> subscribe(Podcast podcast) async {
    await _libraryRepository.upsertPodcast(
      podcast.toDraft(sourceType: _inferSourceTypeFromUrl(podcast.feedUrl)),
    );
    await _libraryRepository.setPodcastSubscribed(podcast.feedUrl, true);
  }

  Future<void> unsubscribe(String feedUrl) async {
    await _libraryRepository.setPodcastSubscribed(feedUrl, false);
  }

  Future<bool> isSubscribed(String feedUrl) async {
    return _libraryRepository.isSubscribed(feedUrl);
  }

  Future<List<Podcast>> getSubscriptions() async {
    return _libraryRepository.getSubscribedPodcasts();
  }

  Future<void> saveDownload(Episode episode) async {
    await _downloadRepository.markDownloaded(episode);
  }

  Future<void> removeDownload(String guid) async {
    await _downloadRepository.markDownloadRemovedByGuid(guid);
  }

  Future<List<Episode>> getDownloadedEpisodes() async {
    return _downloadRepository.getDownloadedEpisodes();
  }

  Future<void> addToHistory(Episode episode) async {
    await _playbackRepository.recordHistory(episode);
  }

  Future<List<Episode>> getPlayHistory() async {
    return _playbackRepository.getHistory(limit: 300);
  }

  Future<void> savePosition(String guid, Duration position) async {
    await _playbackRepository.savePositionByGuid(guid, position);
  }

  Future<Duration> getPosition(String guid) async {
    return _playbackRepository.getPositionByGuid(guid);
  }

  Future<void> addTimeSaved(Duration duration) async {
    await _playbackRepository.addTimeSaved(duration);
  }

  Future<Duration> getTotalTimeSaved() async {
    return _playbackRepository.getTotalTimeSaved();
  }

  Future<void> saveSkipSilenceEnabled(bool enabled) async {
    await _playbackRepository.setSkipSilenceEnabled(enabled);
  }

  Future<bool> getSkipSilenceEnabled() async {
    return _playbackRepository.getSkipSilenceEnabled();
  }

  Future<String> exportToOpml() async {
    final subs = await getSubscriptions();
    final buffer = StringBuffer();
    buffer.writeln('<?xml version="1.0" encoding="UTF-8"?>');
    buffer.writeln('<opml version="1.0">');
    buffer.writeln('  <head>');
    buffer.writeln('    <title>EchoPod Subscriptions</title>');
    buffer.writeln('  </head>');
    buffer.writeln('  <body>');
    for (final podcast in subs) {
      final title = _escapeXml(podcast.title);
      final xmlUrl = _escapeXml(podcast.feedUrl);
      buffer
          .writeln('    <outline text="$title" type="rss" xmlUrl="$xmlUrl" />');
    }
    buffer.writeln('  </body>');
    buffer.writeln('</opml>');
    return buffer.toString();
  }

  String _escapeXml(String str) {
    return str
        .replaceAll('&', '&amp;')
        .replaceAll('<', '&lt;')
        .replaceAll('>', '&gt;')
        .replaceAll('"', '&quot;')
        .replaceAll("'", '&apos;');
  }

  Future<void> saveTheme(AppThemeConfig theme) async {
    await _settingsRepository.saveTheme(theme);
  }

  Future<AppThemeConfig?> loadTheme() async {
    return _settingsRepository.loadTheme();
  }

  Future<void> addFavorite(Episode episode) async {
    await _playbackRepository.addFavorite(episode);
  }

  Future<void> removeFavorite(String guid) async {
    await _playbackRepository.removeFavoriteByGuid(guid);
  }

  Future<bool> isFavorite(String guid) async {
    return _playbackRepository.isFavoriteByGuid(guid);
  }

  Future<List<Episode>> getFavorites() async {
    return _playbackRepository.getFavorites();
  }

  Future<void> saveFeedCache(String url, List<Episode> episodes) async {
    await _libraryRepository.saveFeedCache(url, episodes);
  }

  Future<List<Episode>?> getFeedCache(String url) async {
    return _libraryRepository.getFeedCache(url);
  }

  Future<DateTime?> getFeedCacheTime(String url) async {
    return _libraryRepository.getFeedCacheTime(url);
  }

  SyncRepository get syncRepository => _syncRepository;

  SourceType _inferSourceTypeFromUrl(String url) {
    if (url.startsWith('freshrss://')) return SourceType.freshRss;
    if (url.startsWith('echopod://bilibili/')) return SourceType.bilibili;
    if (url.contains('youtube.com') || url.contains('youtu.be')) {
      return SourceType.youtube;
    }
    return SourceType.rss;
  }
}
