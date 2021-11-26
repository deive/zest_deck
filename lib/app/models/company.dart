import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import 'package:zest_deck/app/api_provider.dart';
import 'package:zest_deck/app/app_data.dart';
import 'package:zest_deck/app/models/api_request_response.dart';

part 'company.g.dart';

@HiveType(typeId: HiveDataType.company)
class Company extends APIRequest with UUIDModel implements APIResponse {
  @HiveField(0)
  @override
  final Uuid id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String? contactNumber;
  @HiveField(3)
  final String? contactEmail;
  @HiveField(4)
  final List<String>? settings;
  @HiveField(5)
  final List<Uuid>? users;
  @HiveField(6)
  final Map<String, String>? metadata;

  Company(this.id, this.name, this.contactNumber, this.contactEmail,
      this.settings, this.users, this.metadata);

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'contactNumber': contactNumber,
        'contactEmail': contactEmail,
        'settings': settings,
        'users': users,
        'metadata': metadata,
      };

  @override
  Company.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        contactNumber = json['contactNumber'],
        contactEmail = json['contactEmail'],
        settings = json['settings'],
        users = json['users'],
        metadata = json['metadata'];
}
