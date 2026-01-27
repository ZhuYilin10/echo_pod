import 'package:flutter/material.dart';
import '../../core/models/episode.dart';

class QuoteCard extends StatelessWidget {
  final Episode episode;
  final String quote;
  final String author;

  const QuoteCard({
    super.key,
    required this.episode,
    required this.quote,
    required this.author,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  episode.imageUrl ?? '',
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Icon(Icons.podcasts),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      episode.podcastTitle,
                      style: const TextStyle(
                        color: Colors.deepPurpleAccent,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      episode.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.grey, fontSize: 10),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          const Icon(Icons.format_quote_rounded, color: Colors.deepPurpleAccent, size: 40),
          const SizedBox(height: 12),
          Text(
            quote,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              height: 1.6,
              fontWeight: FontWeight.w500,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 24),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              '— $author',
              style: const TextStyle(color: Colors.amber, fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 40),
          Center(
            child: Opacity(
              opacity: 0.5,
              child: Column(
                children: [
                  const Icon(Icons.qr_code_2, color: Colors.white, size: 48),
                  const SizedBox(height: 4),
                  Text(
                    '长按扫码在 EchoPod 听这集',
                    style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 8),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
