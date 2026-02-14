import 'package:isar/isar.dart';

import 'db_enums.dart';

part 'external_ref_entity.g.dart';

@collection
class ExternalRefEntity {
  Id isarId = Isar.autoIncrement;

  @Enumerated(EnumType.ordinal)
  @Index(composite: [CompositeIndex('ownerUid')])
  late ExternalOwnerType ownerType;

  late String ownerUid;

  @Enumerated(EnumType.ordinal)
  @Index(unique: true, replace: true, composite: [CompositeIndex('externalId')])
  late SourceType source;

  late String externalId;
  String? externalUrl;
  int priority = 0;

  @Index()
  DateTime fetchedAt = DateTime.now();

  String? extraJson;
}
