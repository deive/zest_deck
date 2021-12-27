import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import 'package:zest_deck/app/api/api_provider.dart';
import 'package:zest_deck/app/app_data.dart';
import 'package:zest_deck/app/api/api_request_response.dart';

part 'section.g.dart';

@HiveType(typeId: HiveDataType.section)
class Section extends APIRequest with UUIDModel implements APIResponse {
  @HiveField(0)
  @override
  final UuidValue id;
  @HiveField(1)
  final int index;
  @HiveField(2)
  final String title;
  @HiveField(3)
  final String subtitle;
  @HiveField(4)
  final SectionType type;
  @HiveField(5)
  final List<UuidValue> resources;
  @HiveField(6)
  final String? path;

  Section(
      {required this.id,
      this.index = 0,
      this.title = "",
      this.subtitle = "",
      this.type = SectionType.normal,
      this.resources = const [],
      this.path});

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'index': index,
        'title': title,
        'subtitle': subtitle,
        'type': type.apiValue,
        'resources': resources,
        'path': path,
      };

  @override
  Section.fromJson(Map<String, dynamic> json)
      : id = UuidValue(json['id']),
        index = json['index'],
        title = json['title'],
        subtitle = json['subtitle'],
        type = SectionTypeAPI.fromAPI(json['type']) ?? SectionType.normal,
        resources =
            List<UuidValue>.from(json["resources"].map((x) => UuidValue(x))),
        path = json['path'];
}

@HiveType(typeId: HiveDataType.sectionType)
enum SectionType {
  @HiveField(0)
  headline,
  @HiveField(1)
  normal,
  @HiveField(2)
  minor,
}

extension SectionTypeAPI on SectionType {
  String get apiValue {
    switch (this) {
      case SectionType.headline:
        return "Headline";
      case SectionType.normal:
        return "Normal";
      case SectionType.minor:
        return "Minor";
    }
  }

  static SectionType? fromAPI(String value) {
    if (value == "Headline") {
      return SectionType.headline;
    } else if (value == "Normal") {
      return SectionType.normal;
    } else if (value == "Minor") {
      return SectionType.minor;
    } else {
      return null;
    }
  }
}