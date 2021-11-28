import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import 'package:zest_deck/app/api_provider.dart';
import 'package:zest_deck/app/app_data.dart';
import 'package:zest_deck/app/models/company.dart';
import 'package:zest_deck/app/decks/deck.dart';
import 'package:zest_deck/app/models/resource.dart';
import 'package:zest_deck/app/models/task.dart';
import 'package:zest_deck/app/users/user.dart';

part 'api_request_response.g.dart';

/// A call to the Zest API.
class ZestCall extends APICall<ZestAPIRequestResponse, ZestAPIRequestResponse> {
  ZestCall(ZestAPIRequestResponse request) : super(request);
}

/// A GET call to the Zest API.
class ZestGetCall extends APIGetCall<ZestAPIRequestResponse> {}

/// The single API request/response model.
@HiveType(typeId: HiveDataType.response)
class ZestAPIRequestResponse extends APIRequest
    with CopyUpdateable<ZestAPIRequestResponse>
    implements APIResponse {
  @HiveField(0)
  final User? user;
  @HiveField(1)
  final List<Company>? companies;
  @HiveField(2)
  final List<Deck>? decks;
  @HiveField(3)
  final List<ResourceFile>? files;
  @HiveField(4)
  final List<Task>? tasks;
  @HiveField(5)
  final UuidValue? companyId;
  @HiveField(6)
  final UuidValue? resourceId;
  @HiveField(7)
  final List<Resource>? resources;
  @HiveField(8)
  final Map<String, String>? metadata;

  String? get authToken => metadata?["AuthToken"];

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
  ZestAPIRequestResponse copyUpdate(ZestAPIRequestResponse o) =>
      ZestAPIRequestResponse(
        user: o.user ?? user,
        companies: copyUpdateLists(companies, o.companies),
        decks: copyUpdateLists(decks, o.decks),
        files: copyUpdateLists(files, o.files),
        tasks: copyUpdateLists(tasks, o.tasks),
        companyId: o.companyId ?? companyId,
        resourceId: o.resourceId ?? resourceId,
        resources: copyUpdateLists(resources, o.resources),
        metadata: o.metadata ?? metadata,
      );

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

/// Allows a merge update.
mixin CopyUpdateable<T> {
  T copyUpdate(T o);

  List<I>? copyUpdateLists<I extends UUIDModel>(List<I>? l1, List<I>? l2) {
    if (l1 == null && l2 == null) {
      return null;
    } else if (l1 == null) {
      return l2;
    } else if (l2 == null) {
      return l1;
    } else {
      return _copyUpdateLists(l1, l2);
    }
  }

  List<I> _copyUpdateLists<I extends UUIDModel, CopyUpdateable>(
      List<I> l1, List<I> l2) {
    // TODO: Do we need to update anything really?.
    return l2;
  }
}
