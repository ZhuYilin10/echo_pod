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
  // Replace with your Tencent Cloud SCF URL after deployment
  static const String _scfApiUrl = 'https://service-xxxx.gz.apigw.tencentcs.com/release/parse';
  static const String _fallbackApiUrl = 'https://api.mir6.com/api/bzjiexi';

  Future<String> resolveShortUrl(String url) async {
    if (!url.contains('b23.tv')) return url;

    try {
      final client = http.Client();
      final request = http.Request('GET', Uri.parse(url))..followRedirects = false;
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
      
      // Attempt to use Tencent Cloud SCF first
      try {
        final scfUri = Uri.parse(_scfApiUrl).replace(queryParameters: {
          'url': resolvedUrl,
        });
        
        debugPrint('BilibiliParser: Requesting SCF $scfUri');
        final response = await http.get(scfUri).timeout(const Duration(seconds: 15));
        
        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          if (data['status'] == 'success') {
            return BilibiliVideoInfo(
              title: data['title'] ?? 'Unknown Title',
              coverUrl: data['cover_url'],
              videoUrl: data['video_url'],
              description: data['description'],
              author: data['author'],
            );
          }
        }
      } catch (e) {
        debugPrint('SCF Error, falling back to backup API: $e');
      }

      // Fallback to legacy API if SCF fails or is not yet configured
      final uri = Uri.parse(_fallbackApiUrl).replace(queryParameters: {
        'url': resolvedUrl,
        'type': 'json',
      });

      debugPrint('BilibiliParser: Fetching $uri');
      final response = await http.get(uri);

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
