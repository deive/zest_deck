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
  final Uuid? companyId;
  final Uuid? resourceId;
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
      : user = json['user'],
        companies = json['companies'],
        decks = json['decks'],
        files = json['files'],
        tasks = json['tasks'],
        companyId = json['companyId'],
        resourceId = json['resourceId'],
        resources = json['resources'],
        metadata = json['metadata'];
}

/// Adds id as UUID, and use's that for equality checking.
mixin UUIDModel {
  Uuid get id;

  @override
  int get hashCode => id.hashCode;

  @override
  bool operator ==(Object? other) =>
      identical(this, other) ||
      other is User && runtimeType == other.runtimeType && id == other.id;
}
