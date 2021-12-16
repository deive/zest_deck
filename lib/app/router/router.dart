import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:zest_deck/app/decks/deck.dart';
import 'package:zest_deck/app/router/auth_guard.dart';
import 'package:zest_deck/app/router/router_app.gr.dart' as app;
import 'package:zest_deck/app/router/router_web.gr.dart' as web;

class Router {
  AuthGuard get authGuard => _authGuard;
  RootStackRouter get router => _router;

  late final AuthGuard _authGuard;
  late final RootStackRouter _router;

  Router() {
    _authGuard = AuthGuard(this);
    _router = kIsWeb
        ? web.WebRouter(authGuard: _authGuard)
        : app.AppRouter(authGuard: _authGuard);
  }

  loginRoute(void Function() onLogin) => kIsWeb
      ? web.LoginRoute(onLogin: onLogin)
      : app.LoginRoute(onLogin: onLogin);

  deckListRoute() =>
      kIsWeb ? const web.DeckListRoute() : const app.DeckListRoute();

  deckDetailRoute(Deck deck) => kIsWeb
      ? web.DeckDetailRoute(deck: deck)
      : app.DeckDetailRoute(deck: deck);
}
