import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import 'package:zest_deck/app/api_provider.dart';
import 'package:zest_deck/app/app_provider.dart';
import 'package:zest_deck/app/api_request_response.dart';
import 'package:zest_deck/app/decks/deck.dart';
import 'package:zest_deck/app/users/users_provider.dart';

class DecksProvider with ChangeNotifier, UsersAndAPIProvider {
  List<Deck>? get decks => _user.currentData?.decks;

  bool get isUpdatingWhileEmpty =>
      _user.currentData == null ||
      _updateCall?.loading == true && (decks == null || decks!.isEmpty);
  bool get hasUpdateErrorWhileEmpty =>
      _updateCall?.error != null && (decks == null || decks!.isEmpty);
  bool get isUpdatingWhileNotEmpty =>
      _updateCall?.loading == true && decks?.isNotEmpty == true;
  Exception? get updateError => _updateCall?.error;

  UpdateCall? _updateCall;

  updateDecksFromAPI() async {
    if (_updateCall?.loading != true) {
      _newUpdateCall();
      try {
        await _api.get(
            _app.apiPath("content"), _user.currentData, _updateCall!);
        final response = _updateCall?.response;
        if (response != null) {
          _handleUpdateResponse(response);
        }
      } on APIException catch (e) {
        if (e.response.statusCode == 403) {
          _user.logout();
        } else {
          _updateCall!.onError(e);
        }
      }
    }
  }

  fileStorePath(UuidValue companyId, UuidValue fileId) =>
      "${_app.appInfo!.fileStoreHost}/file-store/bucket/object?bucket=$companyId&object=$fileId";
  fileStoreHeaders() => {"AuthToken": _user.currentData?.authToken ?? ""};

  _handleUpdateResponse(ZestAPIRequestResponse response) async {
    if (_user.updateCurrentData(response)) {
      notifyListeners();
    }
  }

  DecksProvider onUpdate(AppProvider app, APIProvider api, UsersProvider user) {
    _onUpdate(app, api, user);
    notifyListeners();
    return this;
  }

  @override
  _load() async {
    updateDecksFromAPI();
  }

  _newUpdateCall() {
    _updateCall?.dispose();
    _updateCall = UpdateCall();
    _updateCall!.addListener(() {
      if (!_disposed) {
        notifyListeners();
      }
    });
  }

  bool _disposed = false;
  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}

class UpdateCall extends ZestGetCall {}

mixin UsersAndAPIProvider {
  late AppProvider _app;
  late APIProvider _api;
  late UsersProvider _user;
  bool _startedLoading = false;

  _onUpdate(AppProvider app, APIProvider api, UsersProvider user) {
    _app = app;
    _api = api;
    _user = user;
    if (!_startedLoading &&
        app.appInfo != null &&
        user.currentData?.authToken != null) {
      _startedLoading = true;
      _load();
    }
  }

  _load();
}
