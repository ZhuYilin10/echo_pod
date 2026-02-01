import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import 'package:flutter/foundation.dart';
import '../core/models/episode.dart';

class XiaoyuzhouParserService {
  Future<Episode?> parseUrl(String url) async {
    if (!url.contains('xiaoyuzhoufm.com')) return null;

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode != 200) return null;

      final document = parse(response.body);

      String? getMeta(String property) {
        final element = document.querySelector('meta[property="$property"]');
        return element?.attributes['content'];
      }

      final title = getMeta('og:title');
      final audioUrl = getMeta('og:audio');
      final imageUrl = getMeta('og:image');
      final description = getMeta('og:description') ??
          document
              .querySelector('meta[name="description"]')
              ?.attributes['content'];

      if (title != null && audioUrl != null) {
        // Try to separate podcast title from episode title if possible
        // Often format is "Podcast Name｜Episode Title" or similar
        String podcastTitle = '小宇宙播客';
        String episodeTitle = title;

        // Simple heuristic for separation (can be improved)
        if (title.contains('｜')) {
          final parts = title.split('｜');
          if (parts.length >= 2) {
            // Heuristic: Shortest part might be podcast name, or usually first part?
            // Xiaoyuzhou title format seems to vary.
            // "自我进化论｜No.78..." -> Podcast | Title
            podcastTitle = parts.first.trim();
            episodeTitle = parts.sublist(1).join('｜').trim();
          }
        }

        return Episode(
          guid: url,
          title: episodeTitle,
          podcastTitle: podcastTitle,
          description: description,
          audioUrl: audioUrl,
          imageUrl: imageUrl,
          podcastFeedUrl: '', // No RSS feed known, but we have audio!
          pubDate: DateTime.now(), // Unknown date from simple meta
        );
      }
    } catch (e) {
      debugPrint('Xiaoyuzhou parsing error: $e');
    }
    return null;
  }
}
