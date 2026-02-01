import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class BilibiliVideoInfo {
  final String title;
  final String? coverUrl;
  final String? videoUrl;
  final String? description;
  final String? author;
  final String? authorAvatar;

  BilibiliVideoInfo({
    required this.title,
    this.coverUrl,
    required this.videoUrl,
    this.description,
    this.author,
    this.authorAvatar,
  });
}

class BilibiliParserService {
  // TODO: Re-enable when SCF parsing is stable
  // static const String _scfApiUrl = 'https://1301934614-ecwzvhn1w2.ap-shanghai.tencentscf.com/';
  static const String _fallbackApiUrl = 'https://api.mir6.com/api/bzjiexi';

  static const Map<String, String> _headers = {
    'User-Agent':
        'Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1',
  };

  Future<String> resolveShortUrl(String url) async {
    if (!url.contains('b23.tv')) return url;

    try {
      final client = http.Client();
      final request = http.Request('GET', Uri.parse(url))
        ..followRedirects = false
        ..headers.addAll(_headers);
      final response = await client.send(request);

      final location = response.headers['location'];
      if (location != null) {
        return location.split('?').first; // Strip tracking params
      }
    } catch (e) {
      debugPrint('Error resolving short URL: $e');
    }
    return url;
  }

  Future<BilibiliVideoInfo> parse(String url) async {
    try {
      final resolvedUrl = await resolveShortUrl(url);

      // ... (SCF code commented out) ...

      // Fallback to legacy API if SCF fails or is not yet configured
      final uri = Uri.parse(_fallbackApiUrl).replace(queryParameters: {
        'url': resolvedUrl,
        'type': 'json',
      });

      debugPrint('BilibiliParser: Fetching $uri');
      final response = await http.get(uri, headers: _headers);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['code'] == 200 &&
            data['data'] != null &&
            (data['data'] as List).isNotEmpty) {
          final videoData = data['data'][0];

          return BilibiliVideoInfo(
            title: data['title'] ?? 'Unknown Title',
            coverUrl: data['imgurl'],
            videoUrl: videoData['video_url'],
            description: data['desc'],
            author: data['user']?['name'],
            authorAvatar: data['user']?['user_img'],
          );
        } else {
          throw Exception('未找到有效的视频流地址');
        }
      } else {
        throw Exception('HTTP Error: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('BilibiliParser Error: $e');
      rethrow;
    }
  }
}
