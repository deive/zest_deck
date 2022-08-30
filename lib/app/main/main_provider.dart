import 'package:flutter/foundation.dart';
import 'package:zest/api/models/deck.dart';
import 'package:zest/api/models/resource.dart';
import 'package:zest/app/app_provider.dart';
import 'package:zest/app/deck_list/deck_list_provider.dart';
import 'package:zest/app/main/auth_provider.dart';
import 'package:zest/app/navigation/app_router.gr.dart';

/// Main provider.
class MainProvider with ChangeNotifier {
  MainProvider(
    this._appProvider,
    this._authProvider,
    this._deckListProvider,
    MainProvider? previous,
  ) {
    if (previous?._initComplete != true) {
      _init();
    } else {
      _currentlySelectedDeck = previous!._currentlySelectedDeck;
      _lastSelectedDeck = previous._lastSelectedDeck;
      _showNavigation = previous._showNavigation;
      if (_lastSelectedDeck == null) {
        _loadLastSelectedDeck();
      }
    }
  }

  final AppProvider _appProvider;
  final AuthProvider? _authProvider;
  final DeckListProvider? _deckListProvider;

  bool get showNavigation => _showNavigation;
  Deck? get currentlySelectedDeck => _currentlySelectedDeck;
  Deck? get lastSelectedDeck => _lastSelectedDeck;
  DeckWindowStyle get windowStyle =>
      _currentlySelectedDeck?.windowStyle ?? DeckWindowStyle.compact;

  bool _initComplete = false;
  Deck? _currentlySelectedDeck;
  Deck? _lastSelectedDeck;
  bool _showNavigation = true;

  navigateBack() => _appProvider.router.navigateBack();

  Future<void> navigateTo(MainNavigation dest) async {
    switch (dest) {
      case MainNavigation.decks:
        _currentlySelectedDeck = null;
        _appProvider.router.replace(const DeckListRoute());
        break;
      case MainNavigation.favorites:
        _currentlySelectedDeck = null;
        _appProvider.router.replace(const FavoritesRoute());
        break;
      case MainNavigation.selectedDeck:
        if (_lastSelectedDeck != null) {
          final topRoute = _appProvider.router.topRoute;
          if (topRoute.name != DeckDetailRoute.name) {
            if ([DeckListRoute.name, FavoritesRoute.name, SettingsRoute.name]
                .contains(topRoute.name)) {
              _appProvider.router.push(
                DeckDetailRoute(deckId: _lastSelectedDeck!.id.toString()),
              );
            } else {
              _appProvider.router.replaceAll(
                [
                  const DeckListRoute(),
                  DeckDetailRoute(deckId: _lastSelectedDeck!.id.toString()),
                ],
              );
            }
          }
        }
        break;
      case MainNavigation.settings:
        _currentlySelectedDeck = null;
        _appProvider.router.replace(const SettingsRoute());
        break;
    }
  }

  Future<void> navigateToDeck(Deck deck) async {
    _setSelectedDeck(deck);
    _appProvider.router.push(DeckDetailRoute(deckId: deck.id.toString()));
  }

  Future<void> navigateToResource(Deck deck, Resource resource) async {
    _setSelectedDeck(deck);
    _appProvider.router.push(ResourceViewRoute(
      deckId: deck.id.toString(),
      resourceId: resource.id.toString(),
    ));
  }

  Future<void> onNavigatedToDeck(Deck deck) async {
    // This is called from a build method to enforce a selected deck.
    // e.g. on web navigation or debug reload, so we need to force async.
    await Future.delayed(Duration.zero);
    _setSelectedDeck(deck);
  }

  Future<void> toggleShowNavigation() async {
    _showNavigation = !_showNavigation;
    notifyListeners();
  }

  Future<void> _setSelectedDeck(Deck deck) async {
    if (_currentlySelectedDeck != deck) {
      _currentlySelectedDeck = deck;
      _lastSelectedDeck = deck;
      final deckId = deck.id.toString();
      final key = _lastSelectedDeckKey();
      _appProvider.putString(key, deckId);
      if (deck.windowStyle == DeckWindowStyle.wide) {
        _showNavigation = false;
      }
      notifyListeners();
    }
  }

  Future<void> _init() async {
    await _loadLastSelectedDeck();
    _initComplete = true;
  }

  Future<void> _loadLastSelectedDeck() async {
    final userId = _authProvider?.currentUserId;
    final decks = _deckListProvider?.decks;
    if (userId != null && decks != null && decks.isNotEmpty) {
      final key = _lastSelectedDeckKey();
      final deckId = _appProvider.getString(key);
      if (deckId != null) {
        try {
          final deck =
              decks.firstWhere((element) => element.id.toString() == deckId);
          _lastSelectedDeck = deck;
          notifyListeners();
        } on StateError {
          // Deck no longer avaliable to user.
          _appProvider.removeValue(key);
        }
      }
    }
  }

  String _lastSelectedDeckKey() =>
      "lastSelectedDeck_${_authProvider!.currentUserId}";
}

enum MainNavigation { decks, favorites, selectedDeck, settings }
