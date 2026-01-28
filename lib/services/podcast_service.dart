import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:webfeed_plus/webfeed_plus.dart';
import '../core/models/podcast.dart';
import '../core/models/episode.dart';

class PodcastService {
  final Dio _dio = Dio();

  Future<List<Podcast>> searchPodcasts(String term, {String? genre}) async {
    try {
      final queryParams = {
        'term': term,
        'media': 'podcast',
        'country': 'CN',
        'lang': 'zh_cn',
        'limit': 20,
      };
      if (genre != null) {
        queryParams['genreId'] = genre;
      }

      final response = await _dio.get(
        'https://itunes.apple.com/search',
        queryParameters: queryParams,
      );

      final dynamic responseData = response.data;
      final Map<String, dynamic> data = responseData is String 
          ? jsonDecode(responseData) 
          : responseData;
      final results = data['results'] as List;
      return results.map((item) {
        return Podcast(
          title: item['collectionName'] ?? 'Unknown',
          artist: item['artistName'],
          feedUrl: item['feedUrl'],
          imageUrl: item['artworkUrl600'] ?? item['artworkUrl100'],
        );
      }).toList();
    } catch (_) {
      return [];
    }
  }

  Future<List<Episode>> fetchEpisodes(String feedUrl) async {
    try {
      final response = await _dio.get(feedUrl);
      final feed = RssFeed.parse(response.data);
      
      return feed.items?.map((item) {
        return Episode(
          guid: item.guid ?? item.link ?? item.title ?? '',
          title: item.title ?? 'No Title',
          description: item.description,
          pubDate: item.pubDate,
          audioUrl: item.enclosure?.url,
          duration: item.itunes?.duration?.toString(),
          imageUrl: item.itunes?.image?.href ?? feed.image?.url,
          podcastTitle: feed.title ?? '',
          podcastFeedUrl: feedUrl,
        );
      }).toList() ?? [];
    } catch (_) {
      return [];
    }
  }

  Future<Podcast?> fetchPodcastMetadata(String feedUrl) async {
    try {
      final response = await _dio.get(feedUrl);
      final feed = RssFeed.parse(response.data);
      
      return Podcast(
        title: feed.title ?? '未知播客',
        artist: feed.itunes?.author ?? feed.author ?? '未知主播',
        feedUrl: feedUrl,
        imageUrl: feed.itunes?.image?.href ?? feed.image?.url,
        description: feed.description,
      );
    } catch (_) {
      return null;
    }
  }

  Future<Episode?> resolveEpisodeUrl(Episode episode) async {
    if (episode.audioUrl != null && episode.audioUrl!.isNotEmpty) return episode;
    
    // Search for the podcast to get the feed URL
    final podcasts = await searchPodcasts(episode.podcastTitle);
    if (podcasts.isNotEmpty) {
      final feedUrl = podcasts.first.feedUrl;
      final episodes = await fetchEpisodes(feedUrl);
      // Try to find the matching episode by title
      final match = episodes.where((e) => e.title == episode.title).firstOrNull;
      if (match != null) return match;
    }
    return null;
  }

  Future<List<Episode>> fetchTrendingEpisodes() async {
    try {
      // 1. Fetch iTunes Top Podcasts (CN)
      final itunesResponse = await _dio.get(
        'https://itunes.apple.com/cn/rss/toppodcasts/limit=50/json'
      );
      final dynamic itunesData = itunesResponse.data is String ? jsonDecode(itunesResponse.data) : itunesResponse.data;
      final itunesEntries = itunesData['feed']['entry'] as List;

      // 2. Fetch XYZRank Top Episodes
      final xyzResponse = await _dio.get('https://xyzrank.com/api/episodes');
      final dynamic xyzData = xyzResponse.data is String ? jsonDecode(xyzResponse.data) : xyzResponse.data;
      final xyzItems = xyzData['items'] as List;

      final Map<String, Episode> mergedMap = {};
      final Map<String, double> scores = {};

      // Process XYZRank (Priority 1.5x)
      for (int i = 0; i < xyzItems.length && i < 50; i++) {
        final item = xyzItems[i];
        final episode = Episode(
          guid: item['link'] ?? '',
          title: item['title'] ?? '',
          podcastTitle: item['podcastName'] ?? '',
          imageUrl: item['logoURL'],
          podcastFeedUrl: '', // Will need to resolve if played
        );
        mergedMap[episode.title] = episode;
        scores[episode.title] = (50 - i) * 1.5;
      }

      // Process iTunes (Priority 1.0x)
      for (int i = 0; i < itunesEntries.length; i++) {
        final entry = itunesEntries[i];
        final String? feedUrl = entry['link']['attributes']['href'];
        
        if (i < 10 && feedUrl != null) {
          final episodes = await fetchEpisodes(feedUrl);
          if (episodes.isNotEmpty) {
            final ep = episodes.first;
            if (mergedMap.containsKey(ep.title)) {
              scores[ep.title] = (scores[ep.title] ?? 0) + (50 - i);
            } else {
              mergedMap[ep.title] = ep;
              scores[ep.title] = (50 - i).toDouble();
            }
          }
        }
      }

      // Sort by score
      final sortedTitles = scores.keys.toList()
        ..sort((a, b) => scores[b]!.compareTo(scores[a]!));

      return sortedTitles.take(50).map((t) => mergedMap[t]!).toList();
    } catch (e) {
      print('Error fetching weighted trending episodes: $e');
      return [];
    }
  }
}
