import 'package:isar/isar.dart';

part 'episode_entity.g.dart';

@collection
class EpisodeEntity {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String uid;

  @Index(composite: [CompositeIndex('pubDate')])
  late String podcastUid;

  String? guid;

  @Index(unique: true, replace: true)
  late String fingerprint;

  late String title;
  String? subtitle;
  String? description;
  String? articleUrl;

  @Index()
  DateTime? pubDate;

  int? durationMs;
  String? imageUrl;
  String? primaryMediaUid;

  @Index()
  DateTime fetchedAt = DateTime.now();

  @Index()
  DateTime updatedAt = DateTime.now();

  String? extraJson;
}
