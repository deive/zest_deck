import 'package:uuid/uuid.dart';
import 'package:zest_deck/app/api_provider.dart';
import 'package:zest_deck/app/models/company.dart';
import 'package:zest_deck/app/models/deck.dart';
import 'package:zest_deck/app/models/resource.dart';
import 'package:zest_deck/app/models/task.dart';
import 'package:zest_deck/app/models/user.dart';

/// A call to the Zest API.
class ZestCall extends APICall<ZestAPIRequestResponse, ZestAPIRequestResponse> {
  ZestCall(ZestAPIRequestResponse request) : super(request);
}

/// A GET call to the Zest API.
class ZestGetCall extends APIGetCall<ZestAPIRequestResponse> {}

/// The single API request/response model.
class ZestAPIRequestResponse extends APIRequest implements APIResponse {
  final User? user;
  final List<Company>? companies;
  final List<Deck>? decks;
  final List<ResourceFile>? files;
  final List<Task>? tasks;
  final UuidValue? companyId;
  final UuidValue? resourceId;
  final List<Resource>? resources;
  final Map<String, String>? metadata;

  ZestAPIRequestResponse(
      {this.user,
      this.companies,
      this.decks,
      this.files,
      this.tasks,
      this.companyId,
      this.resourceId,
      this.resources,
      this.metadata});

  @override
  Map<String, dynamic> toJson() => {
        'user': user,
        'companies': companies,
        'decks': decks,
        'files': files,
        'tasks': tasks,
        'companyId': companyId,
        'resourceId': resourceId,
        'resources': resources,
        'metadata': metadata,
      };

  @override
  ZestAPIRequestResponse.fromJson(Map<String, dynamic> json)
      : user = json.containsKey("user") ? User.fromJson(json["user"]) : null,
        companies = json.containsKey("companies")
            ? List.from(json["companies"].map((x) => Company.fromJson(x)))
            : null,
        decks = json.containsKey("decks")
            ? List.from(json["decks"].map((x) => Deck.fromJson(x)))
            : null,
        files = json.containsKey("files")
            ? List.from(json["files"].map((x) => ResourceFile.fromJson(x)))
            : null,
        tasks = json.containsKey("tasks")
            ? List.from(json["tasks"].map((x) => Task.fromJson(x)))
            : null,
        companyId =
            json.containsKey("companyId") ? UuidValue(json['companyId']) : null,
        resourceId = json.containsKey("resourceId")
            ? UuidValue(json['resourceId'])
            : null,
        resources = json.containsKey("resources")
            ? List.from(json["resources"].map((x) => Resource.fromJson(x)))
            : null,
        metadata =
            json.containsKey("metadata") ? Map.from(json['metadata']) : null;
}

/// Adds id as UUID, and use's that for equality checking.
mixin UUIDModel {
  UuidValue get id;

  @override
  int get hashCode => id.hashCode;

  @override
  bool operator ==(Object? other) =>
      identical(this, other) ||
      other is User && runtimeType == other.runtimeType && id == other.id;
}
