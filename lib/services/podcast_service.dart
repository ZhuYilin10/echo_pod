import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:webfeed_plus/webfeed_plus.dart';
import '../core/models/podcast.dart';
import '../core/models/episode.dart';
import 'package:flutter/foundation.dart';
import 'xiaoyuzhou_parser_service.dart';

import '../services/freshrss_service.dart';
import '../services/storage/storage_service.dart';

class PodcastService {
  final Dio _dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    headers: {
      'User-Agent':
          'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
    },
  ));
  final XiaoyuzhouParserService? xiaoyuzhouParser;
  final FreshRssService? freshRssService;
  final StorageService? storageService;

  PodcastService({
    this.xiaoyuzhouParser,
    this.freshRssService,
    this.storageService,
  });

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
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Episode>> fetchEpisodes(String feedUrl) async {
    // Check if it's a simulated RSS (Bilibili/YouTube pseudo-URL)
    if (feedUrl.startsWith('echopod://bilibili/')) {
      return _fetchBilibiliPseudoEpisodes(feedUrl);
    }

    if (feedUrl.startsWith('freshrss://') &&
        freshRssService != null &&
        storageService != null) {
      final config = await storageService!.getFreshRssConfig();
      if (config['url'] != null &&
          config['user'] != null &&
          config['pass'] != null) {
        freshRssService!
            .configure(config['url']!, config['user']!, config['pass']!);
        // Pass the full URL, let service handle stripping if needed, or strip here
        // Since FreshRssService.fetchEpisodes expects feedId or freshrss://feedId
        return freshRssService!.fetchEpisodes(feedUrl);
      }
      return [];
    }

    try {
      final response = await _dio.get(feedUrl);
      final xmlString = response.data.toString();

      // Try to parse as Atom first if it looks like Atom
      if (xmlString.contains('<feed') &&
          xmlString.contains('http://www.w3.org/2005/Atom')) {
        try {
          final feed = AtomFeed.parse(xmlString);
          return feed.items?.map((item) {
                String? audioUrl;
                // Find enclosure if exists
                // Use where loop to avoid AtomLink construction lints
                final enclosure = item.links
                    ?.where((l) => l.rel == 'enclosure')
                    .firstOrNull
                    ?.href;

                if (enclosure != null) {
                  audioUrl = enclosure;
                } else {
                  // Fallback: Check for Bilibili/YouTube links
                  final link = item.links
                      ?.where((l) =>
                          l.rel == 'alternate' ||
                          l.rel == null) // standard link
                      .firstOrNull
                      ?.href;

                  if (link != null &&
                      (link.contains('bilibili.com') ||
                          link.contains('youtube.com'))) {
                    audioUrl = link;
                  }
                }

                return Episode(
                  guid: item.id ?? item.title ?? '',
                  title: item.title ?? 'No Title',
                  description: item.summary ?? item.content,
                  pubDate: item.updated, // Atom uses updated or published
                  audioUrl: audioUrl,
                  duration:
                      null, // Atom standard doesn't strictly have duration
                  imageUrl: feed.logo ?? feed.icon,
                  podcastTitle: feed.title ?? '',
                  podcastFeedUrl: feedUrl,
                );
              }).toList() ??
              [];
        } catch (e) {
          debugPrint('Failed to parse as Atom: $e');
          // Fallthrough to RSS
        }
      }

      final feed = RssFeed.parse(response.data);

      return feed.items?.map((item) {
            String? audioUrl = item.enclosure?.url;

            // Fallback for RSS items without enclosure but with recognized video link
            if (audioUrl == null) {
              if (item.link != null &&
                  (item.link!.contains('bilibili.com') ||
                      item.link!.contains('youtube.com'))) {
                audioUrl = item.link;
              }
            }

            return Episode(
              guid: item.guid ?? item.link ?? item.title ?? '',
              title: item.title ?? 'No Title',
              description: item.description,
              pubDate: item.pubDate,
              audioUrl: audioUrl,
              duration: item.itunes?.duration?.toString(),
              imageUrl: item.itunes?.image?.href ?? feed.image?.url,
              podcastTitle: feed.title ?? '',
              podcastFeedUrl: feedUrl,
            );
          }).toList() ??
          [];
    } catch (e) {
      debugPrint('Error fetching episodes: $e');
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

  /// 批量获取本地订阅的最新剧集
  Future<List<Episode>> fetchRecentEpisodesFromLocal(List<Podcast> localSubs,
      {int episodesPerPodcast = 5}) async {
    final List<Future<List<Episode>>> futures = localSubs.map((podcast) async {
      try {
        final episodes = await fetchEpisodes(podcast.feedUrl);
        return episodes.take(episodesPerPodcast).toList();
      } catch (e) {
        debugPrint('Error fetching episodes for ${podcast.title}: $e');
        return <Episode>[];
      }
    }).toList();

    final results = await Future.wait(futures);
    return results.expand((element) => element).toList();
  }

  Future<Podcast?> fetchPodcastMetadata(String feedUrl) async {
    if (feedUrl.startsWith('echopod://bilibili/')) {
      final uid = feedUrl.split('/').last;
      final rssHubUrl = 'https://rsshub.app/bilibili/user/video/$uid';
      return fetchPodcastMetadata(rssHubUrl);
    }
    try {
      final response = await _dio.get(feedUrl);
      final xmlString = response.data.toString();

      if (xmlString.contains('<feed') &&
          xmlString.contains('http://www.w3.org/2005/Atom')) {
        try {
          final feed = AtomFeed.parse(xmlString);
          return Podcast(
            title: feed.title ?? '未知播客',
            artist: feed.authors?.firstOrNull?.name ?? '未知主播',
            feedUrl: feedUrl,
            imageUrl: feed.logo ?? feed.icon,
            description: feed.subtitle,
          );
        } catch (e) {
          debugPrint('Failed to parse Podcast Metadata as Atom: $e');
        }
      }

      final feed = RssFeed.parse(response.data);

      return Podcast(
        title: feed.title ?? '未知播客',
        artist: feed.itunes?.author ?? feed.author ?? '未知主播',
        feedUrl: feedUrl,
        imageUrl: feed.itunes?.image?.href ?? feed.image?.url,
        description: feed.description,
      );
    } catch (e) {
      debugPrint('Error fetching podcast metadata: $e');
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
        if (resolved != null && resolved.audioUrl != null) {
          return episode.copyWith(
            audioUrl: resolved.audioUrl,
            // reliable metadata from parser if missing in original (though original is usually better from API)
            description: episode.description ?? resolved.description,
          );
        }
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
    int attempts = 0;
    while (attempts < 3) {
      try {
        attempts++;
        debugPrint(
            'TrendingEpisodes: Fetching (Attempt $attempts) from https://xyzrank.com/api/episodes?offset=0&limit=50');
        // Fetch XYZRank Hot Episodes directly from API
        final response = await _dio
            .get('https://xyzrank.com/api/episodes?offset=0&limit=50');

        debugPrint(
            'TrendingEpisodes: Response received. Status: ${response.statusCode}');

        final dynamic responseData =
            response.data is String ? jsonDecode(response.data) : response.data;

        debugPrint(
            'TrendingEpisodes: Response data type: ${responseData.runtimeType}');

        if (responseData['items'] == null) {
          debugPrint('TrendingEpisodes: "items" field is null');
          return [];
        }
        final List<dynamic> episodesData = responseData['items'];

        debugPrint(
            'TrendingEpisodes: Raw data items count: ${episodesData.length}');

        final results = episodesData
            .map((item) {
              try {
                final title = item['title'] ?? 'Unknown Title';
                final link = item['link'];
                final guid = link ?? 'xyz_${title.hashCode}';

                return Episode(
                  guid: guid,
                  title: title,
                  podcastTitle: item['podcastName'] ?? 'Unknown Podcast',
                  imageUrl: item['logoURL'],
                  description: 'Play count: ${item['playCount'] ?? 0}',
                  podcastFeedUrl: '',
                  audioUrl: null,
                  pubDate: item['postTime'] != null
                      ? DateTime.tryParse(item['postTime'])
                      : null,
                  duration: item['duration']?.toString(),
                );
              } catch (e) {
                debugPrint(
                    'TrendingEpisodes: Error parsing item: $item. Error: $e');
                return null;
              }
            })
            .whereType<Episode>()
            .toList();

        debugPrint('TrendingEpisodes: Parsed ${results.length} valid episodes');
        return results;
      } catch (e) {
        debugPrint('Error fetching trending episodes (Attempt $attempts): $e');
        if (attempts >= 3) {
          rethrow;
        }
        // Wait before retrying (1 second)
        await Future.delayed(const Duration(seconds: 1));
      }
    }
    return [];
  }
}
