import 'package:flutter/foundation.dart';
import 'package:zest_deck/app/api_provider.dart';
import 'package:zest_deck/app/app_provider.dart';
import 'package:zest_deck/app/api_request_response.dart';
import 'package:zest_deck/app/decks/deck.dart';
import 'package:zest_deck/app/users/users_provider.dart';

class DecksProvider with ChangeNotifier, UsersAndAPIProvider {
  List<Deck>? get decks => _user.currentData?.decks;
  UpdateCall? _updateCall;

  bool isUpdatingWhileEmpty() =>
      _updateCall?.loading == true && (decks == null || decks!.isEmpty);

  update() async {
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
        // TODO: Handle forbidden, to re-login!
        // if (e.response.statusCode == 403) {}
        _updateCall!.onError(e);
      }
    }
  }

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
    await Future.delayed(const Duration(seconds: 10));
    update();
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
    if (!_startedLoading && app.appInfo != null) {
      _startedLoading = true;
      _load();
    }
  }

  _load();
}
