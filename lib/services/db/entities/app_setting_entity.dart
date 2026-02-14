import 'package:isar/isar.dart';

part 'app_setting_entity.g.dart';

@collection
class AppSettingEntity {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String key;

  String? stringValue;
  int? intValue;
  double? doubleValue;
  bool? boolValue;

  @Index()
  DateTime updatedAt = DateTime.now();
}
