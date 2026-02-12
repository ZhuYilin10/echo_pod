import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../core/models/podcast.dart';
import '../core/models/episode.dart';

class FreshRssService {
  final Dio _dio = Dio(BaseOptions(
    validateStatus: (status) {
      return status != null && status < 500;
    },
    headers: {
      'User-Agent': 'EchoPod/1.0',
    },
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 10),
  ));

  String? _baseUrl;
  String? _username;
  String? _password;
  String? _authToken;

  void configure(String baseUrl, String username, String password) {
    _baseUrl = baseUrl.endsWith('/') ? baseUrl : '$baseUrl/';
    _username = username;
    _password = password;
  }

  Future<bool> login() async {
    if (_baseUrl == null || _username == null || _password == null)
      return false;

    try {
      debugPrint(
          'FreshRSS: Attempting login to $_baseUrl with user $_username');
      final response = await _dio.post(
        '${_baseUrl}api/greader.php/accounts/ClientLogin',
        queryParameters: {
          'Email': _username,
          'Passwd': _password,
        },
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data.toString();
        final authMatch = RegExp(r'Auth=(.*)').firstMatch(data);
        if (authMatch != null) {
          _authToken = authMatch.group(1);
          debugPrint('FreshRSS: Login successful');
          return true;
        } else {
          debugPrint(
              'FreshRSS: Login successful (200) but no Auth token found in response');
        }
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        debugPrint(
            'FreshRSS Login Failed: Unauthorized (${response.statusCode}). Please checks your API Password in FreshRSS settings.');
      } else {
        debugPrint(
            'FreshRSS Login Failed: ${response.statusCode} - ${response.statusMessage}');
        debugPrint('Response Data: ${response.data}');
      }
      return false;
    } catch (e) {
      if (e is DioException) {
        debugPrint(
            'FreshRSS Login Error: DioException [${e.type}]: ${e.message}');
        if (e.response != null) {
          debugPrint('Response Status: ${e.response?.statusCode}');
          debugPrint('Response Data: ${e.response?.data}');
        }
      } else {
        debugPrint('FreshRSS Login Error: $e');
      }
      return false;
    }
  }

  Future<Map<String, int>> fetchUnreadCounts() async {
    if (_authToken == null) await login();
    if (_authToken == null) return {};

    try {
      final response = await _dio.get(
        '${_baseUrl}api/greader.php/reader/api/0/unread-count',
        queryParameters: {'output': 'json'},
        options: Options(headers: {
          'Authorization': 'GoogleLogin auth=$_authToken',
        }),
      );

      if (response.statusCode == 200) {
        final List unreadcounts = response.data['unreadcounts'] ?? [];
        final Map<String, int> counts = {};
        for (var item in unreadcounts) {
          final id = item['id'] as String?;
          final count = item['count'] as int?;
          if (id != null && count != null) {
            // Clean up ID to match feed URL format if needed
            // GReader IDs look like 'feed/http://...'
            final cleanId = id.replaceFirst('feed/', '');
            counts[cleanId] = count;
          }
        }
        return counts;
      }
      return {};
    } catch (e) {
      debugPrint('FreshRSS Fetch Unread Counts Error: $e');
      return {};
    }
  }

  Future<List<Podcast>> fetchSubscriptions() async {
    if (_authToken == null) await login();
    if (_authToken == null) return [];

    try {
      // Fetch unread counts first or concurrently
      final unreadCounts = await fetchUnreadCounts();

      final response = await _dio.get(
        '${_baseUrl}api/greader.php/reader/api/0/subscription/list',
        queryParameters: {'output': 'json'},
        options: Options(headers: {
          'Authorization': 'GoogleLogin auth=$_authToken',
        }),
      );

      if (response.statusCode == 200) {
        final List subscriptions = response.data['subscriptions'] ?? [];
        if (subscriptions.isNotEmpty) {
          debugPrint(
              'FreshRSS Subscriptions Data Sample (First Item): ${subscriptions.first}');
        }
        return subscriptions.map((s) {
          // GReader API (FreshRSS implementation) uses 'iconUrl'
          // We also handle 'visualUrl' if present (some extensions)
          String? imageUrl = s['iconUrl'] ?? s['visualUrl'] ?? s['url'];

          // Handle relative URLs if necessary (though FreshRSS tries to give absolute)
          if (imageUrl != null &&
              !imageUrl.startsWith('http') &&
              _baseUrl != null) {
            imageUrl = Uri.parse(_baseUrl!).resolve(imageUrl).toString();
          }

          final feedId = s['id']?.replaceFirst('feed/', '') ?? '';

          return Podcast(
            title: s['title'] ?? 'Unknown',
            feedUrl: 'freshrss://$feedId',
            imageUrl: imageUrl,
            artist: null,
            unreadCount: unreadCounts[feedId] ?? 0,
          );
        }).toList();
      }
      return [];
    } catch (e) {
      debugPrint('FreshRSS Fetch Subscriptions Error: $e');
      return [];
    }
  }

  Future<List<Episode>> fetchEpisodes(String feedId, {int limit = 50}) async {
    if (_authToken == null) await login();
    if (_authToken == null) return [];

    // Ensure feedId doesn't have the protocol prefix if it was passed with one
    final cleanFeedId = feedId.replaceFirst('freshrss://', '');

    try {
      final response = await _dio.get(
        '${_baseUrl}api/greader.php/reader/api/0/stream/contents/feed/$cleanFeedId',
        queryParameters: {
          'output': 'json',
          'n': limit,
        },
        options: Options(headers: {
          'Authorization': 'GoogleLogin auth=$_authToken',
        }),
      );

      if (response.statusCode == 200) {
        final List items = response.data['items'] ?? [];
        debugPrint(
            'FreshRSS: Fetched ${items.length} items for feed $cleanFeedId');
        return items.map((item) {
          final enclosures = item['enclosure'] as List?;

          // Check if there's an audio enclosure
          String? audioUrl;
          if (enclosures != null) {
            for (var enc in enclosures) {
              if (enc['type']?.toString().startsWith('audio/') == true) {
                audioUrl = enc['href'];
                break;
              }
            }
          }

          // For non-audio content, get the article URL from canonical or alternate
          String? articleUrl;
          if (audioUrl == null) {
            final canonical = (item['canonical'] as List?)?.firstOrNull;
            articleUrl = canonical?['href'];
            if (articleUrl == null) {
              final alternate = (item['alternate'] as List?)?.firstOrNull;
              articleUrl = alternate?['href'];
            }
          }

          String? imageUrl = item['visualUrl'];
          if (imageUrl == null &&
              item['thumbnail'] is List &&
              (item['thumbnail'] as List).isNotEmpty) {
            imageUrl = item['thumbnail'][0]['url'];
          }
          if (imageUrl == null && enclosures != null) {
            for (var enc in enclosures) {
              if (enc['type']?.toString().startsWith('image/') == true) {
                imageUrl = enc['href'];
                break;
              }
            }
          }
          if (imageUrl == null) {
            final content =
                item['content']?['content'] ?? item['summary']?['content'];
            if (content is String) {
              final imgMatch =
                  RegExp(r'<img[^>]+src="([^">]+)"').firstMatch(content);
              if (imgMatch != null) {
                imageUrl = imgMatch.group(1);
              }
            }
          }

          if (imageUrl != null &&
              !imageUrl.startsWith('http') &&
              _baseUrl != null) {
            imageUrl = Uri.parse(_baseUrl!).resolve(imageUrl).toString();
          }

          return Episode(
            guid: item['id'] ?? '',
            title: item['title'] ?? 'No Title',
            description:
                item['summary']?['content'] ?? item['content']?['content'],
            pubDate: DateTime.fromMillisecondsSinceEpoch(
                (item['published'] ?? 0) * 1000),
            audioUrl: audioUrl,
            imageUrl: imageUrl,
            podcastTitle: item['origin']?['title'] ?? '',
            podcastFeedUrl:
                'freshrss://${item['origin']?['streamId']?.replaceFirst('feed/', '') ?? ''}',
            articleUrl: articleUrl,
          );
        }).toList();
      }
      return [];
    } catch (e) {
      debugPrint('FreshRSS Fetch Episodes Error: $e');
      return [];
    }
  }

  Future<bool> markAsRead(String episodeId) async {
    if (_authToken == null) await login();
    if (_authToken == null) return false;

    try {
      final response = await _dio.post(
        '${_baseUrl}api/greader.php/reader/api/0/edit-tag',
        queryParameters: {
          'a': 'user/-/state/com.google/read',
          'i': episodeId,
          'T':
              _authToken, // GReader often requires the token in T param for POST
        },
        options: Options(headers: {
          'Authorization': 'GoogleLogin auth=$_authToken',
        }),
      );
      return response.statusCode == 200;
    } catch (e) {
      debugPrint('FreshRSS Mark As Read Error: $e');
      return false;
    }
  }

  Future<List<Episode>> fetchRecentEpisodes(int limit) async {
    if (_authToken == null) await login();
    if (_authToken == null) return [];

    try {
      final response = await _dio.get(
        '${_baseUrl}api/greader.php/reader/api/0/stream/contents/reading-list',
        queryParameters: {
          'output': 'json',
          'n': limit,
          // 'xt': 'user/-/state/com.google/read', // Uncomment to exclude read items (default usually includes them or depends on server)
        },
        options: Options(headers: {
          'Authorization': 'GoogleLogin auth=$_authToken',
        }),
      );

      if (response.statusCode == 200) {
        final List items = response.data['items'] ?? [];
        debugPrint('FreshRSS: Fetched ${items.length} items from reading list');
        if (items.isNotEmpty) {
          debugPrint(
              'FreshRSS Stream Item Data Sample (First Item): ${items.first}');
        }
        return items.map((item) {
          final enclosures = item['enclosure'] as List?;

          // Check if there's an audio enclosure
          String? audioUrl;
          if (enclosures != null) {
            for (var enc in enclosures) {
              if (enc['type']?.toString().startsWith('audio/') == true) {
                audioUrl = enc['href'];
                break;
              }
            }
          }

          // For non-audio content, get the article URL from canonical or alternate
          String? articleUrl;
          if (audioUrl == null) {
            final canonical = (item['canonical'] as List?)?.firstOrNull;
            articleUrl = canonical?['href'];
            if (articleUrl == null) {
              final alternate = (item['alternate'] as List?)?.firstOrNull;
              articleUrl = alternate?['href'];
            }
          }

          // Try to find an image URL from various potential fields
          // 1. Check for specific extension fields first
          String? imageUrl = item['visualUrl'];

          // 2. Check thumbnails
          if (imageUrl == null &&
              item['thumbnail'] is List &&
              (item['thumbnail'] as List).isNotEmpty) {
            imageUrl = item['thumbnail'][0]['url'];
          }

          // 3. Check enclosures (podcasts often use this for cover art)
          if (imageUrl == null && enclosures != null) {
            for (var enc in enclosures) {
              if (enc['type']?.toString().startsWith('image/') == true) {
                imageUrl = enc['href'];
                break;
              }
            }
          }

          // 4. Fallback: Parse content HTML for first image tag
          // This is standard practice for RSS readers using Google Reader API
          if (imageUrl == null) {
            final content =
                item['content']?['content'] ?? item['summary']?['content'];
            if (content is String) {
              final imgMatch =
                  RegExp(r'<img[^>]+src="([^">]+)"').firstMatch(content);
              if (imgMatch != null) {
                imageUrl = imgMatch.group(1);
              }
            }
          }

          // Handle relative URLs
          if (imageUrl != null &&
              !imageUrl.startsWith('http') &&
              _baseUrl != null) {
            imageUrl = Uri.parse(_baseUrl!).resolve(imageUrl).toString();
          }

          return Episode(
            guid: item['id'] ?? '',
            title: item['title'] ?? 'No Title',
            description:
                item['summary']?['content'] ?? item['content']?['content'],
            pubDate: DateTime.fromMillisecondsSinceEpoch(
                (item['published'] ?? 0) * 1000),
            audioUrl: audioUrl,
            imageUrl: imageUrl,
            podcastTitle: item['origin']?['title'] ?? '',
            podcastFeedUrl:
                'freshrss://${item['origin']?['streamId']?.replaceFirst('feed/', '') ?? ''}',
            articleUrl: articleUrl,
          );
        }).toList();
      }
      return [];
    } catch (e) {
      debugPrint('FreshRSS Fetch Episodes Error: $e');
      return [];
    }
  }
}
