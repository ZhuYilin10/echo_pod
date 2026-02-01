import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:webfeed_plus/webfeed_plus.dart';
import '../core/models/podcast.dart';
import '../core/models/episode.dart';
import 'package:flutter/foundation.dart';
import 'xiaoyuzhou_parser_service.dart';

class PodcastService {
  final Dio _dio = Dio();
  final XiaoyuzhouParserService? xiaoyuzhouParser;

  PodcastService({this.xiaoyuzhouParser});

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
      final Map<String, dynamic> data =
          responseData is String ? jsonDecode(responseData) : responseData;
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
    // Check if it's a simulated RSS (Bilibili/YouTube pseudo-URL)
    if (feedUrl.startsWith('echopod://bilibili/')) {
      return _fetchBilibiliPseudoEpisodes(feedUrl);
    }
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
          }).toList() ??
          [];
    } catch (_) {
      return [];
    }
  }

  Future<List<Episode>> _fetchBilibiliPseudoEpisodes(String pseudoUrl) async {
    // Expected format: echopod://bilibili/user/{uid}
    final uid = pseudoUrl.split('/').last;
    try {
      // Use RSSHub as a reliable bridge for fetching Bilibili user's video list as RSS
      final rssHubUrl = 'https://rsshub.app/bilibili/user/video/$uid';
      return fetchEpisodes(rssHubUrl);
    } catch (e) {
      print('Error fetching Bilibili pseudo episodes: $e');
      return [];
    }
  }

  Future<Podcast?> fetchPodcastMetadata(String feedUrl) async {
    if (feedUrl.startsWith('echopod://bilibili/')) {
      final uid = feedUrl.split('/').last;
      final rssHubUrl = 'https://rsshub.app/bilibili/user/video/$uid';
      return fetchPodcastMetadata(rssHubUrl);
    }
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
    if (episode.audioUrl != null && episode.audioUrl!.isNotEmpty)
      return episode;

    // Check if the GUID is actually a Xiaoyuzhou link (common in XYZRank data)
    if (episode.guid.contains('xiaoyuzhoufm.com') && xiaoyuzhouParser != null) {
      try {
        final resolved = await xiaoyuzhouParser!.parseUrl(episode.guid);
        if (resolved != null) return resolved;
      } catch (e) {
        debugPrint('Xiaoyuzhou quick resolve failed: $e');
      }
    }

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
      // Fetch XYZRank Hot Episodes directly from GitHub
      final response = await _dio.get(
          'https://raw.githubusercontent.com/eddiehe99/xyzrank/main/hot_episodes.json');

      final dynamic responseData =
          response.data is String ? jsonDecode(response.data) : response.data;

      final List<dynamic> episodesData = responseData['data']['episodes'];

      return episodesData.map((item) {
        return Episode(
          guid: item['link'] ?? 'xyz_${item['title'].hashCode}',
          title: item['title'] ?? 'Unknown Title',
          podcastTitle: item['podcastName'] ?? 'Unknown Podcast',
          imageUrl: item['logoURL'],
          description: 'Play count: ${item['playCount']}',
          // These episodes lack direct audio/feed URLs, so they will need resolution
          // when the user tries to play them.
          podcastFeedUrl: '',
          audioUrl: null,
          pubDate: item['postTime'] != null
              ? DateTime.tryParse(item['postTime'])
              : null,
          duration: item['duration']?.toString(),
        );
      }).toList();
    } catch (e) {
      debugPrint('Error fetching trending episodes: $e');
      return [];
    }
  }
}
