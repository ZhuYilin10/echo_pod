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
}
