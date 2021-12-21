import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import 'package:zest_deck/app/api/api_provider.dart';
import 'package:zest_deck/app/app_provider.dart';
import 'package:zest_deck/app/api/api_request_response.dart';
import 'package:zest_deck/app/decks/deck.dart';
import 'package:zest_deck/app/users/users_provider.dart';

class DecksProvider
    with ChangeNotifier, AppAndAPIProvider, UsersAndAPIProvider {
  List<Deck>? get decks => user.currentData?.decks;

  bool get isUpdatingWhileEmpty =>
      user.currentData == null ||
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
        await api.get(app.apiPath("content"), user.currentData, _updateCall!);
        final response = _updateCall?.response;
        if (response != null) {
          _handleUpdateResponse(response);
        }
      } on APIException catch (e) {
        if (e.response.statusCode == 403) {
          user.onAPI403();
        }
        _updateCall!.onError(e);
      }
    }
  }

  Future<String> getDataDirectory() async =>
      "${await app.getHiveDirectory()}/${app.currentUserId}";
  fileStorePath(UuidValue companyId, UuidValue fileId) =>
      "${app.appInfo!.fileStoreHost}/file-store/bucket/object?bucket=$companyId&object=$fileId";
  fileStoreHeaders() => {"AuthToken": user.currentData?.authToken ?? ""};

  _handleUpdateResponse(ZestAPIRequestResponse response) async {
    if (user.updateCurrentData(response)) {
      notifyListeners();
    }
  }

  DecksProvider onUpdate(AppProvider app, APIProvider api, UsersProvider user) {
    onUserProviderUpdate(app, api, user);
    notifyListeners();
    return this;
  }

  @override
  void onRecievedAuthToken() {
    updateDecksFromAPI();
  }

  @override
  void onLogout() {
    _updateCall?.dispose();
    _updateCall = null;
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

mixin DecksAndAPIProvider on UsersAndAPIProvider {
  @protected
  DecksProvider get decks => _decks;

  late DecksProvider _decks;

  Map<UuidValue, UuidValue>? _lastDeckIds;

  @protected
  void onDeckProviderUpdate(AppProvider app, APIProvider api,
      UsersProvider user, DecksProvider decks) {
    _decks = decks;
    onUserProviderUpdate(app, api, user);
    if (loaded) {
      final ids = decks.decks == null
          ? null
          : {for (var element in decks.decks!) element.id: element.version!};
      if ((_lastDeckIds == null && ids != null) ||
          (_lastDeckIds != null && ids == null)) {
        _lastDeckIds = ids;
        onDecksUpdated();
      } else if (_lastDeckIds != null && ids != null) {
        if (!mapEquals(_lastDeckIds, ids)) {
          _lastDeckIds = ids;
          onDecksUpdated();
        }
      }
    }
  }

  /// Called every time the list of decks from the server changes.
  @protected
  void onDecksUpdated() {}
}

class UpdateCall extends ZestGetCall {}
