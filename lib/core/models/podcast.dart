class Podcast {
  final String feedUrl;
  final String title;
  final String? artist;
  final String? imageUrl;
  final String? description;

  Podcast({
    required this.feedUrl,
    required this.title,
    this.artist,
    this.imageUrl,
    this.description,
  });

  Map<String, dynamic> toJson() => {
    'feedUrl': feedUrl,
    'title': title,
    'artist': artist,
    'imageUrl': imageUrl,
    'description': description,
  };

  factory Podcast.fromJson(Map<String, dynamic> json) => Podcast(
    feedUrl: json['feedUrl'],
    title: json['title'],
    artist: json['artist'],
    imageUrl: json['imageUrl'],
    description: json['description'],
  );
}
