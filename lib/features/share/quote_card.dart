import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
      width: 340,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.indigo.withOpacity(0.3), blurRadius: 10)
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    episode.imageUrl ?? '',
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        const Icon(Icons.podcasts, color: Colors.white24),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      episode.podcastTitle,
                      style: GoogleFonts.notoSansSc(
                        color: Colors.indigoAccent,
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(
                      episode.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style:
                          const TextStyle(color: Colors.white38, fontSize: 11),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 48),
          const Opacity(
            opacity: 0.2,
            child:
                Icon(Icons.format_quote_rounded, color: Colors.white, size: 64),
          ),
          const SizedBox(height: 8),
          Text(
            quote,
            style: GoogleFonts.notoSerifSc(
              color: Colors.white,
              fontSize: 22,
              height: 1.6,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '— EchoPod AI 精选',
                    style: TextStyle(
                        color: Colors.amber.shade700,
                        fontSize: 12,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    '听见好声音，发现新世界',
                    style: TextStyle(color: Colors.white24, fontSize: 10),
                  ),
                ],
              ),
              const Opacity(
                opacity: 0.6,
                child: Icon(Icons.qr_code_2_rounded,
                    color: Colors.white, size: 40),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
