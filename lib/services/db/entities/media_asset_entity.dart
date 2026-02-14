import 'package:isar/isar.dart';

import 'db_enums.dart';

part 'media_asset_entity.g.dart';

@collection
class MediaAssetEntity {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String uid;

  @Index(composite: [CompositeIndex('isPreferred')])
  late String episodeUid;

  @Enumerated(EnumType.ordinal)
  late MediaType mediaType;

  late String urlOriginal;

  @Index()
  late String urlNormalized;

  String? mimeType;
  int? bitrate;
  int? sizeBytes;
  bool isPreferred = false;

  @Enumerated(EnumType.ordinal)
  ResolverType resolvedBy = ResolverType.unknown;

  DateTime? expiresAt;
  String? headersJson;
  String? localPath;

  @Index()
  DateTime updatedAt = DateTime.now();
}
