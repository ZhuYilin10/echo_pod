import 'package:isar/isar.dart';

part 'episode_content_entity.g.dart';

@collection
class EpisodeContentEntity {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String episodeUid;

  String? shownotesHtml;
  String? shownotesText;
  String? transcriptText;

  @Index()
  DateTime updatedAt = DateTime.now();
}
