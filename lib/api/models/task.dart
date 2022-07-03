import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import 'package:zest/api/api_provider.dart';
import 'package:zest/api/api_request_response.dart';
import 'package:zest/api/models/company.dart';
import 'package:zest/api/models/resource.dart';
import 'package:zest/app/main_provider.dart';

part 'task.g.dart';

@HiveType(typeId: HiveDataType.task)
class Task extends APIRequest with UUIDModel implements APIResponse {
  @HiveField(0)
  @override
  final UuidValue id;
  @HiveField(1)
  final UuidValue? resourceId;
  @HiveField(2)
  final UuidValue? accountId;
  @HiveField(3)
  final Company? company;
  @HiveField(4)
  final Resource? resource;
  @HiveField(5)
  final String? type; // TODO: Enum?
  @HiveField(6)
  final String? progress;
  @HiveField(7)
  final UuidValue? assigned;
  @HiveField(8)
  final DateTime? assignExpiry;
  @HiveField(9)
  final Map<String, String>? error;
  @HiveField(10)
  final Map<UuidValue, ResourceFile>? binaryFiles;
  @HiveField(11)
  final Map<ResourceFileType, List<UuidValue>>? files;
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
      : id = UuidValue(json['id']),
        resourceId = UuidValue(json['resourceId']),
        accountId = UuidValue(json['accountId']),
        company = Company.fromJson(json['company']),
        resource = Resource.fromJson(json['resource']),
        type = json['type'],
        progress = json['progress'],
        assigned = UuidValue(json['assigned']),
        assignExpiry = DateTime.parse(json['assignExpiry']),
        error = json['error'],
        binaryFiles = json['binaryFiles'], // TODO
        files = json['files'], // TODO
        metadata = json['metadata'];
}
