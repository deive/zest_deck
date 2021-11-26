import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import 'package:zest_deck/app/api_provider.dart';
import 'package:zest_deck/app/app_data.dart';
import 'package:zest_deck/app/models/api_request_response.dart';
import 'package:zest_deck/app/models/company.dart';
import 'package:zest_deck/app/models/resource.dart';

part 'task.g.dart';

@HiveType(typeId: HiveDataType.task)
class Task extends APIRequest with UUIDModel implements APIResponse {
  @HiveField(0)
  @override
  final Uuid id;
  @HiveField(1)
  final Uuid? resourceId;
  @HiveField(2)
  final Uuid? accountId;
  @HiveField(3)
  final Company? company;
  @HiveField(4)
  final Resource? resource;
  @HiveField(5)
  final String? type;
  @HiveField(6)
  final String? progress;
  @HiveField(7)
  final Uuid? assigned;
  @HiveField(8)
  final DateTime? assignExpiry;
  @HiveField(9)
  final Map<String, String>? error;
  @HiveField(10)
  final Map<Uuid, ResourceFile>? binaryFiles;
  @HiveField(11)
  final Map<ResourceFileType, List<Uuid>>? files;
  @HiveField(12)
  final Map<String, String>? metadata;

  Task(
      {required this.id,
      this.resourceId,
      this.accountId,
      this.company,
      this.resource,
      this.type,
      this.progress,
      this.assigned,
      this.assignExpiry,
      this.error,
      this.binaryFiles,
      this.files,
      this.metadata});

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'resourceId': resourceId,
        'accountId': accountId,
        'company': company,
        'resource': resource,
        'type': type,
        'progress': progress,
        'assigned': assigned,
        'assignExpiry': assignExpiry,
        'error': error,
        'binaryFiles': binaryFiles,
        'files': files,
        'metadata': metadata,
      };

  @override
  Task.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        resourceId = json['resourceId'],
        accountId = json['accountId'],
        company = json['company'],
        resource = json['resource'],
        type = json['type'],
        progress = json['progress'],
        assigned = json['assigned'],
        assignExpiry = json['assignExpiry'],
        error = json['error'],
        binaryFiles = json['binaryFiles'],
        files = json['files'],
        metadata = json['metadata'];
}
