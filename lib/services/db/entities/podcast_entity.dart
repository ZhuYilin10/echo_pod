import 'package:isar/isar.dart';

import 'db_enums.dart';

part 'podcast_entity.g.dart';

@collection
class PodcastEntity {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String uid;

  @Index(unique: true, replace: true)
  late String canonicalUrl;

  late String originalUrl;
  late String title;
  String? author;
  String? description;
  String? imageUrl;

  @Enumerated(EnumType.ordinal)
  late SourceType sourceType;

  @Index(composite: [CompositeIndex('updatedAt')])
  bool isSubscribed = true;

  bool autoDownload = false;

  @Index(composite: [CompositeIndex('sortOrder')])
  String? groupName;

  int? sortOrder;
  String? etag;
  String? lastModified;
  DateTime? lastFetchedAt;

  @Index()
  DateTime updatedAt = DateTime.now();

  String? extraJson;
}
