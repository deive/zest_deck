import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import 'package:zest_deck/app/api_provider.dart';
import 'package:zest_deck/app/app_data.dart';
import 'package:zest_deck/app/api_request_response.dart';

part 'user.g.dart';

@HiveType(typeId: HiveDataType.user)
class User extends APIRequest with UUIDModel implements APIResponse {
  @HiveField(0)
  @override
  final UuidValue id;
  @HiveField(1)
  final List<UuidValue> companies;
  @HiveField(2)
  final String? forename;
  @HiveField(3)
  final String? surname;
  @HiveField(4)
  final String? email;
  @HiveField(5)
  final DateTime? lastAuth;
  @HiveField(6)
  final String? token;
  @HiveField(7)
  final String? resetToken;
  @HiveField(8)
  final String? magicToken;
  @HiveField(9)
  final Map<UuidValue, List<String>>? userGrants; // TODO: Enum
  @HiveField(10)
  final bool validated;
  @HiveField(11)
  final Map<String, String>? metadata;

  String get displayName {
    final hasFN = forename?.isNotEmpty ?? false;
    final hasSN = surname?.isNotEmpty ?? false;
    final hasEM = email?.isNotEmpty ?? false;
    if (hasFN && hasSN && hasEM) {
      return "$forename $surname ($email)";
    } else if (hasFN && hasSN) {
      return "$forename $surname";
    } else if (hasFN && hasEM) {
      return "$forename ($email)";
    } else if (hasSN && hasEM) {
      return "$surname ($email)";
    } else if (hasFN) {
      return forename!;
    } else if (hasSN) {
      return surname!;
    } else if (hasEM) {
      return email!;
    } else {
      return "No name specified";
    }
  }

  User(
      {required this.id,
      required this.companies,
      this.forename,
      this.surname,
      this.email,
      this.lastAuth,
      this.token,
      this.resetToken,
      this.magicToken,
      this.userGrants,
      this.validated = false,
      this.metadata});

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'companies': companies,
        'forename': forename,
        'surname': surname,
        'email': email,
        'lastAuth': lastAuth,
        'token': token,
        'resetToken': resetToken,
        'magicToken': magicToken,
        // 'userGrants': userGrants,
        'validated': validated,
        'metadata': metadata,
      };

  @override
  User.fromJson(Map<String, dynamic> json)
      : id = UuidValue(json['id']),
        companies =
            List<UuidValue>.from(json["companies"].map((x) => UuidValue(x))),
        forename = json['forename'],
        surname = json['surname'],
        email = json['email'],
        lastAuth = json.containsKey("lastAuth")
            ? DateTime.parse(json['lastAuth'])
            : null,
        token = json['token'],
        resetToken = json['resetToken'],
        magicToken = json['magicToken'],
        // TODO: This is an array, but should be a Map of company Id -> list of grants, see Resource.filesFromJson.
        // userGrants = json['userGrants'],
        userGrants = null,
        validated = json['validated'],
        metadata =
            json.containsKey("metadata") ? Map.from(json['metadata']) : null;
}
