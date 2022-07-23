import 'package:flutter/foundation.dart';
import 'package:zest/api/models/deck.dart';
import 'package:zest/app/app_provider.dart';
import 'package:zest/app/main/auth_provider.dart';
import 'package:zest/app/navigation/app_router.gr.dart';

/// Main provider.
class MainProvider with ChangeNotifier {
  MainProvider(AppProvider appProvider, AuthProvider? authProvider)
      : _appProvider = appProvider,
        _authProvider = authProvider;

  final AppProvider _appProvider;
  final AuthProvider? _authProvider;

  bool get showNavigation => _showNavigation;
  Deck? get currentlySelectedDeck => _currentlySelectedDeck;
  Deck? get lastSelectedDeck => _lastSelectedDeck;

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
    _currentlySelectedDeck = deck;
    // TODO: Deck display info.
    // _showNavigation = deck.showNavigation;
    _appProvider.router.push(DeckDetailRoute(deckId: deck.id.toString()));
  }
}

enum MainNavigation { decks, favorites, selectedDeck, settings }
