import 'package:isar/isar.dart';

import 'db_enums.dart';

part 'queue_item_entity.g.dart';

@collection
class QueueItemEntity {
  Id isarId = Isar.autoIncrement;

  @Enumerated(EnumType.ordinal)
  @Index(unique: true, replace: true, composite: [CompositeIndex('orderIndex')])
  late QueueType queueType;

  int orderIndex = 0;

  @Index()
  late String episodeUid;

  DateTime addedAt = DateTime.now();
  String? extraJson;
}
