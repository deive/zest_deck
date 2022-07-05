import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import 'package:zest/api/api_provider.dart';
import 'package:zest/api/api_request_response.dart';
import 'package:zest/app/main/main_provider.dart';

part 'company.g.dart';

@HiveType(typeId: HiveDataType.company)
class Company extends APIRequest with UUIDModel implements APIResponse {
  @HiveField(0)
  @override
  final UuidValue id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String? contactNumber;
  @HiveField(3)
  final String? contactEmail;
  @HiveField(4)
  final bool? accountSuspendBilling;
  @HiveField(5)
  final String? accountType;
  @HiveField(6)
  final String? accountPackage;
  @HiveField(7)
  final int? accountGraceBalance;
  @HiveField(8)
  final List<String>? settings;
  @HiveField(9)
  final List<UuidValue>? users;
  @HiveField(10)
  final Map<String, String>? metadata;

  Company(
      this.id,
      this.name,
      this.contactNumber,
      this.contactEmail,
      this.accountSuspendBilling,
      this.accountType,
      this.accountPackage,
      this.accountGraceBalance,
      this.settings,
      this.users,
      this.metadata);

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'contactNumber': contactNumber,
        'contactEmail': contactEmail,
        'accountSuspendBilling': accountSuspendBilling,
        'accountType': accountType,
        'accountPackage': accountPackage,
        'accountGraceBalance': accountGraceBalance,
        'settings': settings,
        'users': users,
        'metadata': metadata,
      };

  @override
  Company.fromJson(Map<String, dynamic> json)
      : id = UuidValue(json['id']),
        name = json['name'],
        contactNumber = json['contactNumber'],
        contactEmail = json['contactEmail'],
        accountSuspendBilling = json['accountSuspendBilling'],
        accountType = json['accountType'],
        accountPackage = json['accountPackage'],
        accountGraceBalance = json['accountGraceBalance'],
        settings =
            json.containsKey("settings") ? List.from(json['settings']) : null,
        users = json.containsKey("users")
            ? List.from(json["users"].map((x) => UuidValue(x)))
            : null,
        metadata =
            json.containsKey("metadata") ? Map.from(json['metadata']) : null;
}
