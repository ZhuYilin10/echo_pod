class Podcast {
  final String feedUrl;
  final String title;
  final String? artist;
  final String? imageUrl;

  Podcast({
    required this.feedUrl,
    required this.title,
    this.artist,
    this.imageUrl,
  });

  Map<String, dynamic> toJson() => {
    'feedUrl': feedUrl,
    'title': title,
    'artist': artist,
    'imageUrl': imageUrl,
  };

  factory Podcast.fromJson(Map<String, dynamic> json) => Podcast(
    feedUrl: json['feedUrl'],
    title: json['title'],
    artist: json['artist'],
    imageUrl: json['imageUrl'],
  );
}
