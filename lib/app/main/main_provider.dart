import 'package:flutter/foundation.dart';
import 'package:zest/api/models/deck.dart';
import 'package:zest/app/app_provider.dart';
import 'package:zest/app/deck_list/deck_list_provider.dart';
import 'package:zest/app/main/auth_provider.dart';
import 'package:zest/app/navigation/app_router.gr.dart';

/// Main provider.
class MainProvider with ChangeNotifier {
  MainProvider(this._appProvider, this._authProvider, this._deckListProvider,
      MainProvider? previous) {
    if (previous?._initComplete != true) {
      _init();
    } else {
      this._currentlySelectedDeck = previous!._currentlySelectedDeck;
      this._lastSelectedDeck = previous._lastSelectedDeck;
      this._showNavigation = previous._showNavigation;
    }
  }

  final AppProvider _appProvider;
  final AuthProvider? _authProvider;
  final DeckListProvider? _deckListProvider;

  bool get showNavigation => _showNavigation;
  Deck? get currentlySelectedDeck => _currentlySelectedDeck;
  Deck? get lastSelectedDeck => _lastSelectedDeck;

  bool _initComplete = false;
  Deck? _currentlySelectedDeck;
  Deck? _lastSelectedDeck;
  bool _showNavigation = true;

  Future<void> navigateTo(MainNavigation dest) async {
    switch (dest) {
      case MainNavigation.decks:
        _appProvider.router.replace(const DeckListRoute());
        break;
      case MainNavigation.favorites:
        _appProvider.router.replace(const FavoritesRoute());
        break;
      case MainNavigation.selectedDeck:
        if (_currentlySelectedDeck != null) {
          _appProvider.router.replace(
              DeckDetailRoute(deckId: _currentlySelectedDeck!.id.toString()));
        }
        break;
      case MainNavigation.settings:
        _appProvider.router.replace(const SettingsRoute());
        break;
    }
  }

  Future<void> navigateToDeck(Deck deck) async {
    _setSelectedDeck(deck);
    _appProvider.router.push(DeckDetailRoute(deckId: deck.id.toString()));
  }

  Future<void> _setSelectedDeck(Deck deck) async {
    _currentlySelectedDeck = deck;
    final deckId = deck.id.toString();
    final key = _currentlySelectedDeckKey();
    _appProvider.putString(key, deckId);
    // TODO: Deck display info.
    // _showNavigation = deck.showNavigation;
  }

  Future<void> _init() async {
    final userId = _authProvider?.currentUserId;
    final decks = _deckListProvider?.decks;
    if (userId != null && decks != null && decks.isNotEmpty) {
      final key = _currentlySelectedDeckKey();
      final deckId = _appProvider.getString(key);
      if (deckId != null) {
        try {
          final deck =
              decks.firstWhere((element) => element.id.toString() == deckId);
          _setSelectedDeck(deck);
        } on StateError {
          // Deck no longer avaliable to user.
          _appProvider.removeValue(key);
        }
      }
    }
    _initComplete = true;
  }

  String _currentlySelectedDeckKey() =>
      "currentlySelectedDeck_${_authProvider!.currentUserId}";
}

enum MainNavigation { decks, favorites, selectedDeck, settings }
