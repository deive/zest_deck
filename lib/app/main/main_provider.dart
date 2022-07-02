import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';
import 'package:zest_deck/app/api/api_provider.dart';
import 'package:zest_deck/app/app_provider.dart';
import 'package:zest_deck/app/decks/deck.dart';
import 'package:zest_deck/app/decks/decks_provider.dart';
import 'package:zest_deck/app/users/users_provider.dart';

/// Main provider.
class MainProvider
    with
        ChangeNotifier,
        AppAndAPIProvider,
        UsersAndAPIProvider,
        DecksAndAPIProvider {
  bool get showNavigation => _showNavigation;
  Deck? get currentlySelectedDeck => _currentlySelectedDeck;
  Deck? get lastSelectedDeck => _lastSelectedDeck;

  bool _showNavigation = true;
  Deck? _currentlySelectedDeck;
  Deck? _lastSelectedDeck;

  MainProvider onUpdate(AppProvider app, APIProvider api, UsersProvider user,
      DecksProvider deck) {
    onDeckProviderUpdate(app, api, user, deck);
    return this;
  }

  toggleShowNavigation() async {
    _showNavigation = !_showNavigation;
    notifyListeners();
  }

  deckSelected(UuidValue deckId) async {
    final deck = decks.getDeckById(deckId);
    if (deck != null && deck != _currentlySelectedDeck) {
      _currentlySelectedDeck = deck;
      _lastSelectedDeck = deck;
      await Future.delayed(const Duration(milliseconds: 1));
      notifyListeners();
    }
  }

  deckUnselected() async {
    if (_currentlySelectedDeck != null) {
      _currentlySelectedDeck = null;
      await Future.delayed(const Duration(milliseconds: 1));
      notifyListeners();
    }
  }
}
