import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:zest/api/api_provider.dart';
import 'package:zest/api/api_request_response.dart';
import 'package:zest/api/models/deck.dart';
import 'package:zest/app/app_provider.dart';
import 'package:zest/app/main/auth_provider.dart';
import 'package:zest/app/shared/provider.dart';

class DeckListProvider with ChangeNotifier, Disposable {
  DeckListProvider(
      this._api, this._app, this._auth, DeckListProvider? previous) {
    if (previous?._initComplete != true) {
      _init();
    } else {
      _deckData = previous!._deckData;
      _initComplete = true;
    }
  }

  bool get initComplete => _initComplete;
  ZestAPIRequestResponse? get loginData => _loginData;
  List<Deck>? get decks => loginData?.decks;
  DeckUpdateCall? get updateCall => _updateCall;
  bool get isUpdating => _updateCall?.running ?? false;

  bool get isFirstFetch => _lastDeckListFetch == null;

  final APIProvider _api;
  final AppProvider _app;
  final AuthProvider? _auth;
  bool _initComplete = false;

  static const _deckBox = 'deck';
  Box<ZestAPIRequestResponse>? _deckData;
  ZestAPIRequestResponse? get _loginData {
    final currentUserId = _auth?.currentUserId;
    if (currentUserId == null) return null;
    return _deckData?.get(currentUserId);
  }

  DateTime? get _lastDeckListFetch => _app.getDateTime("lastDeckListFetch");
  DeckUpdateCall? _updateCall;

  Future<void> updateDecksFromAPI() async {
    if (_api.allowManualRefresh(_lastDeckListFetch)) {
      _updateDecksFromAPI();
    }
  }

  Future<void> _updateDecksFromAPI() async {
    // TODO: Client-side check for valid token before running API.
    if (_auth?.isCurrentUserAPISessionValid == true &&
        _updateCall?.running != true) {
      final loginData = _auth!.loginData!;
      _newUpdateCall();
      try {
        await _api.get(_api.apiPath("content"), loginData, _updateCall!);
        final response = _updateCall?.response;
        if (response != null) {
          _handleUpdateResponse(response);
        }
      } on APIException catch (e) {
        if (e.response.statusCode == 403) {
          // TODO: Mark user as no valid API session
        } else {
          _updateCall?.onError(e);
        }
      }
    }
  }

  Future<void> _handleUpdateResponse(ZestAPIRequestResponse response) async {
    final userId = response.user?.id.toString();
    if (userId != null && userId == _auth?.currentUserId) {
      await _deckData?.put(userId, response);
      _updateCall?.dispose();
      _updateCall = null;
      _notifyListenersIfNotDisposed();
    }
  }

  void _newUpdateCall() {
    _updateCall?.dispose();
    _updateCall = DeckUpdateCall();
    _updateCall!.addListener(() {
      _notifyListenersIfNotDisposed();
    });
  }

  void _notifyListenersIfNotDisposed() {
    if (!disposed) notifyListeners();
  }

  Future<void> _init() async {
    _deckData = await Hive.openBox<ZestAPIRequestResponse>(_deckBox);
    _initComplete = true;
    _notifyListenersIfNotDisposed();
    if (_auth?.isCurrentUserAPISessionValid == true &&
        _api.allowAutomaticRefresh(_lastDeckListFetch)) {
      _updateDecksFromAPI();
      _app.putDateTime("lastDeckListFetch", DateTime.now().toUtc());
    }
  }
}

class DeckUpdateCall extends ZestGetCall {}
