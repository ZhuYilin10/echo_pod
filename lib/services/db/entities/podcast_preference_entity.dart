import 'package:isar/isar.dart';

part 'podcast_preference_entity.g.dart';

@collection
class PodcastPreferenceEntity {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String podcastUid;

  double? speed;
  bool? skipSilenceOverride;
  bool? loudnessNormalize;

  @Index()
  DateTime updatedAt = DateTime.now();
}
