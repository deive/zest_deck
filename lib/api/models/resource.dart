import 'package:hive/hive.dart';
import 'package:jiffy/jiffy.dart';
import 'package:uuid/uuid.dart';
import 'package:zest/api/api_provider.dart';
import 'package:zest/api/api_request_response.dart';
import 'package:zest/api/models/task.dart';
import 'package:zest/app/app_provider.dart';

part 'resource.g.dart';

@HiveType(typeId: HiveDataType.resource)
class Resource extends APIRequest
    with UUIDModel, Metadata
    implements APIResponse {
  @HiveField(0)
  @override
  final UuidValue id;
  @HiveField(1)
  final ResourceType type;
  @HiveField(2)
  final String name;
  @HiveField(3)
  final String description;
  @HiveField(4)
  final String mime;
  @HiveField(5)
  final String filename;
  @HiveField(6)
  final List<String> tags;
  @HiveField(7)
  final DateTime? modified;
  @HiveField(8)
  final UuidValue version;
  @HiveField(9)
  final Task? task;
  @HiveField(10)
  final List<String> path;
  @HiveField(11)
  final ResourceProcessingStage stage;
  @HiveField(12)
  final List<ResourceProperty> properties;
  @HiveField(13)
  final Map<ResourceFileType, List<UuidValue>> files;
  @HiveField(14)
  @override
  final Map<String, String>? metadata;

  String get menuTitle => metadata?["menu_title"] ?? name;

  String get modifiedLongFormat =>
      Jiffy(modified).format("MMMM do yyyy, h:mm:ss a");

  Resource(
      {required this.id,
      this.type = ResourceType.unset,
      this.name = "",
      this.description = "",
      required this.mime,
      required this.filename,
      this.tags = const [],
      this.modified,
      required this.version,
      this.task,
      this.path = const [],
      this.stage = ResourceProcessingStage.pending,
      this.properties = const [],
      this.files = const {},
      this.metadata});

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type.apiValue,
        'name': name,
        'description': description,
        'mime': mime,
        'filename': filename,
        'tags': tags,
        'modified': modified,
        'version': version,
        'task': task,
        'path': path,
        'stage': stage.apiValue,
        'properties': properties,
        'files': files.map(
            (key, value) => MapEntry(key.apiValue, value.map((e) => e.uuid))),
        'metadata': metadata,
      };

  @override
  Resource.fromJson(Map<String, dynamic> json)
      : id = UuidValue(json['id']),
        type = ResourceTypeAPI.fromAPI(json['type']),
        name = json['name'],
        description = json['description'],
        mime = json['mime'],
        filename = json['filename'],
        tags = List.from(json['tags']),
        modified = DateTime.parse(json['modified']),
        version = UuidValue(json['version']),
        task = json.containsKey('task') ? Task.fromJson(json['task']) : null,
        path = List.from(json['path']),
        stage = ResourceProcessingStageAPI.fromAPI(json['stage']) ??
            ResourceProcessingStage.pending,
        properties = List.from(
            json["properties"].map((x) => ResourcePropertyAPI.fromAPI(x))),
        files = Map<String, List<dynamic>>.from(json['files']).map(
            (key, value) => MapEntry(
                ResourceFileTypeAPI.fromAPI(key) ?? ResourceFileType.content,
                value.map((e) => UuidValue(e)).toList())),
        metadata =
            json.containsKey("metadata") ? Map.from(json['metadata']) : null;

  UuidValue? get thumbnailFile => (files[ResourceFileType.thumbnail] ??
          files[ResourceFileType.chosenThumbnail] ??
          files[ResourceFileType.thumbnailUser])
      ?.first;

  UuidValue? get imageFile => (files[ResourceFileType.imageContent])?.first;
}

@HiveType(typeId: HiveDataType.resourceFile)
class ResourceFile extends APIRequest with UUIDModel implements APIResponse {
  @HiveField(0)
  @override
  final UuidValue id;
  @HiveField(1)
  final UuidValue? resourceId;
  @HiveField(2)
  final UuidValue? companyId;
  @HiveField(3)
  final String? mimeType;
  @HiveField(4)
  final String? ext;
  @HiveField(5)
  final int? size;
  @HiveField(6)
  final Map<String, String>? metadata;

  ResourceFile(
      {required this.id,
      this.resourceId,
      this.companyId,
      this.mimeType,
      this.ext,
      this.size,
      this.metadata});

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'resourceId': resourceId,
        'companyId': companyId,
        'mimeType': mimeType,
        'ext': ext,
        'size': size,
        'metadata': metadata,
      };

  @override
  ResourceFile.fromJson(Map<String, dynamic> json)
      : id = UuidValue(json['id']),
        resourceId =
            json.containsKey('task') ? UuidValue(json['resourceId']) : null,
        companyId =
            json.containsKey('task') ? UuidValue(json['companyId']) : null,
        mimeType = json['mimeType'],
        ext = json['ext'],
        size = json['size'],
        metadata =
            json.containsKey("metadata") ? Map.from(json['metadata']) : null;
}

@HiveType(typeId: HiveDataType.resourceFileType)
enum ResourceFileType {
  @HiveField(0)
  content,
  @HiveField(1)
  original,
  @HiveField(2)
  thumbnail,
  @HiveField(3)
  chosenThumbnail,
  @HiveField(4)
  thumbnailUser,
  @HiveField(5)
  logo,
  @HiveField(6)
  imageContent,
}

extension ResourceFileTypeAPI on ResourceFileType {
  String get apiValue {
    switch (this) {
      case ResourceFileType.content:
        return "content";
      case ResourceFileType.original:
        return "original";
      case ResourceFileType.thumbnail:
        return "thumbnail";
      case ResourceFileType.chosenThumbnail:
        return "chosen_thumbnail";
      case ResourceFileType.thumbnailUser:
        return "thumbnail_user";
      case ResourceFileType.logo:
        return "logo";
      case ResourceFileType.imageContent:
        return "image_content";
    }
  }

  static ResourceFileType? fromAPI(String value) {
    if (value == "content") {
      return ResourceFileType.content;
    } else if (value == "original") {
      return ResourceFileType.original;
    } else if (value == "thumbnail") {
      return ResourceFileType.thumbnail;
    } else if (value == "chosen_thumbnail") {
      return ResourceFileType.chosenThumbnail;
    } else if (value == "thumbnail_user") {
      return ResourceFileType.thumbnailUser;
    } else if (value == "logo") {
      return ResourceFileType.logo;
    } else if (value == "image_content") {
      return ResourceFileType.imageContent;
    } else {
      return null;
    }
  }
}

@HiveType(typeId: HiveDataType.resourceProcessingStage)
enum ResourceProcessingStage {
  @HiveField(0)
  pending,
  @HiveField(1)
  processing,
  @HiveField(2)
  processing25,
  @HiveField(3)
  processing50,
  @HiveField(4)
  processing75,
  @HiveField(5)
  complete,
}

extension ResourceProcessingStageAPI on ResourceProcessingStage {
  String get apiValue {
    switch (this) {
      case ResourceProcessingStage.pending:
        return "Pending";
      case ResourceProcessingStage.processing:
        return "Processing";
      case ResourceProcessingStage.processing25:
        return "Processing25";
      case ResourceProcessingStage.processing50:
        return "Processing50";
      case ResourceProcessingStage.processing75:
        return "Processing75";
      case ResourceProcessingStage.complete:
        return "Complete";
    }
  }

  static ResourceProcessingStage? fromAPI(String value) {
    if (value == "Pending") {
      return ResourceProcessingStage.pending;
    } else if (value == "Processing") {
      return ResourceProcessingStage.processing;
    } else if (value == "Processing25") {
      return ResourceProcessingStage.processing25;
    } else if (value == "Processing50") {
      return ResourceProcessingStage.processing50;
    } else if (value == "Processing75") {
      return ResourceProcessingStage.processing75;
    } else if (value == "Complete") {
      return ResourceProcessingStage.complete;
    } else {
      return null;
    }
  }
}

@HiveType(typeId: HiveDataType.resourceProperty)
enum ResourceProperty {
  @HiveField(0)
  canEmail,
  @HiveField(1)
  allowOpen,
}

extension ResourcePropertyAPI on ResourceProperty {
  String get apiValue {
    switch (this) {
      case ResourceProperty.canEmail:
        return "can_email";
      case ResourceProperty.allowOpen:
        return "allow_open";
    }
  }

  static ResourceProperty? fromAPI(String value) {
    if (value == "can_email") {
      return ResourceProperty.canEmail;
    } else if (value == "allow_open") {
      return ResourceProperty.allowOpen;
    } else {
      return null;
    }
  }
}

@HiveType(typeId: HiveDataType.resourceType)
enum ResourceType {
  @HiveField(0)
  document,
  @HiveField(1)
  image,
  @HiveField(2)
  video,
  @HiveField(3)
  microsite,
  @HiveField(4)
  link,
  @HiveField(5)
  folder,
  @HiveField(6)
  unset,
}

extension ResourceTypeAPI on ResourceType {
  String get apiValue {
    switch (this) {
      case ResourceType.document:
        return "document";
      case ResourceType.image:
        return "image";
      case ResourceType.video:
        return "video";
      case ResourceType.microsite:
        return "microsite";
      case ResourceType.link:
        return "link";
      case ResourceType.folder:
        return "folder";
      case ResourceType.unset:
        return "";
    }
  }

  static ResourceType fromAPI(String value) {
    if (value == "document") {
      return ResourceType.document;
    } else if (value == "image") {
      return ResourceType.image;
    } else if (value == "video") {
      return ResourceType.video;
    } else if (value == "microsite") {
      return ResourceType.microsite;
    } else if (value == "link") {
      return ResourceType.link;
    } else if (value == "folder") {
      return ResourceType.folder;
    } else {
      return ResourceType.unset;
    }
  }
}
