import 'package:flutter/foundation.dart';
import 'package:zest/api/api_provider.dart';
import 'package:zest/api/api_request_response.dart';
import 'package:zest/api/models/deck.dart';
import 'package:zest/app/app_provider.dart';
import 'package:zest/app/main/auth_provider.dart';
import 'package:zest/app/shared/provider.dart';

class DeckListProvider with ChangeNotifier, Disposable {
  DeckListProvider(this._api, this._app, this._auth) {
    _init();
  }

  List<Deck>? get decks => _auth.loginData?.decks;

  bool get isFirstFetch => _lastDeckListFetch == null;

  final APIProvider _api;
  final AppProvider _app;
  final AuthProvider _auth;

  DateTime? get _lastDeckListFetch => _app.getDateTime("lastDeckListFetch");
  UpdateCall? _updateCall;

  Future<void> updateDecksFromAPI() async {
    if (_api.allowManualRefresh(_lastDeckListFetch)) {
      _updateDecksFromAPI();
    }
  }

  Future<void> _init() async {
    if (_api.allowAutomaticRefresh(_lastDeckListFetch)) {
      _updateDecksFromAPI();
    }
  }

  Future<void> _updateDecksFromAPI() async {
    if (_updateCall?.running != true) {
      _newUpdateCall();
      await _api.get(_api.apiPath("content"), _auth.loginData, _updateCall!);
      final response = _updateCall?.response;
      if (response != null) {
        _handleUpdateResponse(response);
      }
    }
  }

  _handleUpdateResponse(ZestAPIRequestResponse response) async {
    if (_auth.updateCurrentData(response)) {
      notifyListeners();
    }
  }

  void _newUpdateCall() {
    _updateCall?.dispose();
    _updateCall = UpdateCall();
    _updateCall!.addListener(() {
      if (!disposed) {
        notifyListeners();
      }
    });
  }
}

class UpdateCall extends ZestGetCall {}
