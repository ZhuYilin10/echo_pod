class Episode {
  final String guid;
  final String title;
  final String? description;
  final DateTime? pubDate;
  final String? audioUrl;
  final String? duration;
  final String? imageUrl;
  final String podcastTitle;

  Episode({
    required this.guid,
    required this.title,
    this.description,
    this.pubDate,
    this.audioUrl,
    this.duration,
    this.imageUrl,
    required this.podcastTitle,
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
  };

  factory Episode.fromJson(Map<String, dynamic> json) => Episode(
    guid: json['guid'],
    title: json['title'],
    description: json['description'],
    pubDate: json['pubDate'] != null ? DateTime.parse(json['pubDate']) : null,
    audioUrl: json['audioUrl'],
    duration: json['duration'],
    imageUrl: json['imageUrl'],
    podcastTitle: json['podcastTitle'],
  );
}
