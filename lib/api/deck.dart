import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import 'package:zest/api/api_provider.dart';
import 'package:zest/api/api_request_response.dart';
import 'package:zest/api/resource.dart';
import 'package:zest/api/section.dart';
import 'package:zest/app/app_provider.dart';

part 'deck.g.dart';

@HiveType(typeId: HiveDataType.deck)
class Deck extends APIRequest with UUIDModel, Metadata implements APIResponse {
  @HiveField(0)
  @override
  final UuidValue id;
  @HiveField(1)
  final UuidValue? companyId;
  @HiveField(2)
  final UuidValue? version;
  @HiveField(3)
  final List<Resource> resources;
  @HiveField(4)
  final List<ResourceFile> files;
  @HiveField(5)
  final UuidValue? thumbnail;
  @HiveField(6)
  final UuidValue? thumbnailFile;
  @HiveField(7)
  final int rank;
  @HiveField(8)
  final String title;
  @HiveField(9)
  final String subtitle;
  @HiveField(10)
  final DateTime? modified;
  @HiveField(11)
  final List<Section> sections;
  @HiveField(12)
  final List<UuidValue>? permissions;
  @HiveField(13)
  @override
  final Map<String, String>? metadata;

  Deck(
      {required this.id,
      this.companyId,
      this.version,
      this.resources = const [],
      this.files = const [],
      this.thumbnail,
      this.thumbnailFile,
      this.rank = 0,
      this.title = "",
      this.subtitle = "",
      this.modified,
      this.sections = const [],
      this.permissions,
      this.metadata});

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'companyId': companyId,
        'version': version,
        'resources': resources,
        'files': files,
        'thumbnail': thumbnail,
        'thumbnailFile': thumbnailFile,
        'rank': rank,
        'title': title,
        'subtitle': subtitle,
        'modified': modified,
        'sections': sections,
        'permissions': permissions,
        'metadata': metadata,
      };

  @override
  Deck.fromJson(Map<String, dynamic> json)
      : id = UuidValue(json['id']),
        companyId =
            json.containsKey("companyId") ? UuidValue(json['companyId']) : null,
        version =
            json.containsKey("version") ? UuidValue(json['version']) : null,
        resources =
            List.from(json["resources"].map((x) => Resource.fromJson(x))),
        files = List.from(json["files"].map((x) => ResourceFile.fromJson(x))),
        thumbnail =
            json.containsKey("thumbnail") ? UuidValue(json['thumbnail']) : null,
        thumbnailFile = json.containsKey("thumbnailFile")
            ? UuidValue(json['thumbnailFile'])
            : null,
        rank = json['rank'],
        title = json['title'],
        subtitle = json['subtitle'],
        modified = json.containsKey("modified")
            ? DateTime.parse(json['modified'])
            : null,
        sections = List.from(json["sections"].map((x) => Section.fromJson(x))),
        permissions = json.containsKey("permissions")
            ? List.from(json["permissions"].map((x) => UuidValue(x)))
            : null,
        metadata =
            json.containsKey("metadata") ? Map.from(json['metadata']) : null;

  UuidValue? get logoImageId => getMetadataUUID("logo-image");
  UuidValue? get backgroundImageId => getMetadataUUID("background-image");

  DeckWindowStyle get windowStyle =>
      DeckWindowStyleAPI.fromAPI(metadata?["deck-window-style"]) ??
      DeckWindowStyle.compact;
  DeckFlow get flow =>
      DeckFlowAPI.fromAPI(metadata?["deck-flow"]) ?? DeckFlow.horizontal;

  Color? get headerColour => getMetadataColor("header-colour");
  Color? get headerTextColour => getMetadataColor("header-text-colour");
  Color? get sectionTitleColour => getMetadataColor("section-title-colour");
  Color? get sectionSubtitleColour =>
      getMetadataColor("section-subtitle-colour");
}

enum DeckWindowStyle {
  compact,
  wide,
  fullScreen,
  noTitle,
}

extension DeckWindowStyleAPI on DeckWindowStyle {
  String get apiValue {
    switch (this) {
      case DeckWindowStyle.compact:
        return "Compact";
      case DeckWindowStyle.wide:
        return "Wide";
      case DeckWindowStyle.fullScreen:
        return "Full Screen";
      case DeckWindowStyle.noTitle:
        return "No Title";
    }
  }

  static DeckWindowStyle? fromAPI(String? value) {
    if (value == "Compact") {
      return DeckWindowStyle.compact;
    } else if (value == "Wide") {
      return DeckWindowStyle.wide;
    } else if (value == "Full Screen") {
      return DeckWindowStyle.fullScreen;
    } else if (value == "No Title") {
      return DeckWindowStyle.noTitle;
    } else {
      return null;
    }
  }
}

enum DeckFlow {
  horizontal,
  vertical,
}

extension DeckFlowAPI on DeckFlow {
  String get apiValue {
    switch (this) {
      case DeckFlow.horizontal:
        return "Horizontal";
      case DeckFlow.vertical:
        return "Vertical";
    }
  }

  static DeckFlow? fromAPI(String? value) {
    if (value == "Horizontal") {
      return DeckFlow.horizontal;
    } else if (value == "Vertical") {
      return DeckFlow.vertical;
    } else {
      return null;
    }
  }
}
