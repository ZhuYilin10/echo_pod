class Episode {
  final String guid;
  final String title;
  final String? description;
  final DateTime? pubDate;
  final String? audioUrl;
  final String? duration;
  final String? imageUrl;
  final String podcastTitle;
  final String podcastFeedUrl;

  Episode({
    required this.guid,
    required this.title,
    this.description,
    this.pubDate,
    this.audioUrl,
    this.duration,
    this.imageUrl,
    required this.podcastTitle,
    required this.podcastFeedUrl,
  });

  Map<String, dynamic> toJson() => {
        'guid': guid,
        'title': title,
        'description': description,
        'pubDate': pubDate?.toIso8601String(),
        'audioUrl': audioUrl,
        'duration': duration,
        'imageUrl': imageUrl,
        'podcastTitle': podcastTitle,
        'podcastFeedUrl': podcastFeedUrl,
      };

  factory Episode.fromJson(Map<String, dynamic> json) => Episode(
        guid: json['guid'],
        title: json['title'],
        description: json['description'],
        pubDate:
            json['pubDate'] != null ? DateTime.parse(json['pubDate']) : null,
        audioUrl: json['audioUrl'],
        duration: json['duration'],
        imageUrl: json['imageUrl'],
        podcastTitle: json['podcastTitle'],
        podcastFeedUrl: json['podcastFeedUrl'] ?? '',
      );
  Episode copyWith({
    String? guid,
    String? title,
    String? description,
    DateTime? pubDate,
    String? audioUrl,
    String? duration,
    String? imageUrl,
    String? podcastTitle,
    String? podcastFeedUrl,
  }) {
    return Episode(
      guid: guid ?? this.guid,
      title: title ?? this.title,
      description: description ?? this.description,
      pubDate: pubDate ?? this.pubDate,
      audioUrl: audioUrl ?? this.audioUrl,
      duration: duration ?? this.duration,
      imageUrl: imageUrl ?? this.imageUrl,
      podcastTitle: podcastTitle ?? this.podcastTitle,
      podcastFeedUrl: podcastFeedUrl ?? this.podcastFeedUrl,
    );
  }
}
