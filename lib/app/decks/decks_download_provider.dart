import 'package:flutter/foundation.dart';
import 'package:zest_deck/app/app_provider.dart';
import 'package:zest_deck/app/decks/decks_provider.dart';
import 'package:zest_deck/app/users/users_provider.dart';

class DecksDownloadProvider with ChangeNotifier, UsersAndDecksProvider {
  update() async {}

  DecksDownloadProvider onUpdate(
      AppProvider app, UsersProvider user, DecksProvider deck) {
    _onUpdate(app, user, deck);
    notifyListeners();
    return this;
  }

  @override
  _load() async {
    await Future.delayed(const Duration(seconds: 10));
    update();
  }

  bool _disposed = false;
  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}

mixin UsersAndDecksProvider {
  late AppProvider _app;
  late UsersProvider _user;
  late DecksProvider _deck;
  bool _startedLoading = false;

  _onUpdate(AppProvider app, UsersProvider user, DecksProvider deck) {
    _app = app;
    _user = user;
    _deck = deck;
    if (!_startedLoading && app.appInfo != null) {
      _startedLoading = true;
      _load();
    }
  }

  _load();
}
