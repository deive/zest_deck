import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import 'package:zest_deck/app/api_provider.dart';
import 'package:zest_deck/app/app_data.dart';
import 'package:zest_deck/app/models/api_request_response.dart';
import 'package:zest_deck/app/models/resource.dart';
import 'package:zest_deck/app/models/section.dart';

part 'deck.g.dart';

@HiveType(typeId: HiveDataType.deck)
class Deck extends APIRequest with UUIDModel implements APIResponse {
  @HiveField(0)
  @override
  final Uuid id;
  @HiveField(1)
  final Uuid? companyId;
  @HiveField(2)
  final Uuid? version;
  @HiveField(3)
  final List<Resource> resources;
  @HiveField(4)
  final List<ResourceFile> files;
  @HiveField(5)
  final Uuid? thumbnail;
  @HiveField(6)
  final Uuid? thumbnailFile;
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
  final List<Uuid>? permissions;
  @HiveField(13)
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
      : id = json['id'],
        companyId = json['companyId'],
        version = json['version'],
        resources = json['resources'],
        files = json['files'],
        thumbnail = json['thumbnail'],
        thumbnailFile = json['thumbnailFile'],
        rank = json['rank'],
        title = json['title'],
        subtitle = json['subtitle'],
        modified = json['modified'],
        sections = json['sections'],
        permissions = json['permissions'],
        metadata = json['metadata'];
}
