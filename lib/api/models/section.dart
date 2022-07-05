import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import 'package:zest/api/api_provider.dart';
import 'package:zest/api/api_request_response.dart';
import 'package:zest/app/main/main_provider.dart';

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
      this.type = SectionType.iconMedium,
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
        type = SectionTypeAPI.fromAPI(json['type']) ?? SectionType.iconMedium,
        resources =
            List<UuidValue>.from(json["resources"].map((x) => UuidValue(x))),
        path = json['path'];
}

@HiveType(typeId: HiveDataType.sectionType)
enum SectionType {
  @HiveField(0)
  iconMedium,
  @HiveField(1)
  iconLarge,
  @HiveField(2)
  iconSmall,
  @HiveField(3)
  cardFull,
  @HiveField(4)
  cardCompact,
}

extension SectionTypeAPI on SectionType {
  String get apiValue {
    switch (this) {
      case SectionType.iconMedium:
        return "Icon - Medium";
      case SectionType.iconLarge:
        return "Icon - Large";
      case SectionType.iconSmall:
        return "Icon - Small";
      case SectionType.cardFull:
        return "Card - Full";
      case SectionType.cardCompact:
        return "Card - Compact";
    }
  }

  static SectionType? fromAPI(String value) {
    if (value == "Icon - Medium") {
      return SectionType.iconMedium;
    } else if (value == "Icon - Large") {
      return SectionType.iconLarge;
    } else if (value == "Icon - Small") {
      return SectionType.iconSmall;
    } else if (value == "Card - Full") {
      return SectionType.cardFull;
    } else if (value == "Card - Compact") {
      return SectionType.cardCompact;
    } else {
      return null;
    }
  }
}
