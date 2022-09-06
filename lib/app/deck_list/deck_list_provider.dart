import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import 'package:zest/api/api_provider.dart';
import 'package:zest/api/api_request_response.dart';
import 'package:zest/api/models/deck.dart';
import 'package:zest/api/models/resource.dart';
import 'package:zest/app/app_provider.dart';
import 'package:zest/app/download/downloader.dart';
import 'package:zest/app/favorites/favorites_provider.dart';
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
      _automaticUpdate();
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
  set _lastDeckListFetch(DateTime? fetched) => fetched == null
      ? _app.removeValue("lastDeckListFetch")
      : _app.putDateTime("lastDeckListFetch", DateTime.now().toUtc());
  DeckUpdateCall? _updateCall;

  Deck? getDeck(UuidValue id) {
    try {
      return decks?.firstWhere((element) => element.id == id);
    } catch (_) {
      return null;
    }
  }

  ResourceAndDeck? getResource(FavoriteItem favoriteItem) {
    if (favoriteItem.fromDeckId != null) {
      final deck = getDeck(favoriteItem.fromDeckId!);
      final resource = deck?.getResource(favoriteItem.resourceId);
      if (resource != null) return ResourceAndDeck(resource, deck!);
    }
    final d = decks;
    if (d != null) {
      for (var i = 0; i < d.length; i++) {
        final deck = d[i];
        if (deck.companyId == favoriteItem.companyId) {
          final resource = deck.getResource(favoriteItem.resourceId);
          if (resource != null) return ResourceAndDeck(resource, deck);
        }
      }
    }
    return null;
  }

  Future<void> updateDecksFromAPI() async {
    if (_api.allowManualRefresh(_lastDeckListFetch)) {
      _updateDecksFromAPI();
    }
  }

  fileStorePath(UuidValue companyId, UuidValue fileId) => _api.fileStorePath(
      "file-store/bucket/object?bucket=$companyId&object=$fileId");

  fileStoreHeaders() => {"AuthToken": _auth?.loginData?.authToken ?? ""};

  Future<void> _updateDecksFromAPI() async {
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
          _auth?.onAPI403();
        } else {
          _updateCall?.onError(e);
        }
      }
    }
  }

  Future<void> _handleUpdateResponse(ZestAPIRequestResponse response) async {
    final userId = response.user?.id.toString();
    final currentUserId = _auth?.currentUserId;
    if (currentUserId != null) {
      if (kIsWeb || userId != null && userId == currentUserId) {
        await _deckData?.put(currentUserId, response);
        _updateCall?.dispose();
        _updateCall = null;
        notifyListenersIfNotDisposed();
      }
    }
  }

  void _newUpdateCall() {
    _updateCall?.dispose();
    _updateCall = DeckUpdateCall();
    _updateCall!.addListener(() {
      notifyListenersIfNotDisposed();
    });
  }

  Future<void> _init() async {
    if (_auth != null) {
      final dir = await _auth!.getDataDirectory();
      if (dir != null) {
        _deckData = await Hive.openBox<ZestAPIRequestResponse>(
          _deckBox,
          path: dir,
        );
        _initComplete = true;
        notifyListenersIfNotDisposed();
        _automaticUpdate();
      }
    }
  }

  Future<void> _automaticUpdate() async {
    if (_auth?.isCurrentUserAPISessionValid == true) {
      if (decks == null ||
          decks!.isEmpty ||
          _api.allowAutomaticRefresh(_lastDeckListFetch)) {
        _updateDecksFromAPI();
        _lastDeckListFetch = DateTime.now().toUtc();
      }
    }
  }
}

class ResourceAndDeck extends PairKeyEquals<Resource, Deck> {
  ResourceAndDeck(super.first, super.second);
}

class DeckUpdateCall extends ZestGetCall {}
