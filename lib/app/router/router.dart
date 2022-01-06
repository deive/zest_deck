import 'package:auto_route/auto_route.dart';
import 'package:zest_deck/app/decks/deck.dart';
import 'package:zest_deck/app/models/resource.dart';
import 'package:zest_deck/app/router/auth_guard.dart';
import 'package:zest_deck/app/router/router_app.gr.dart' as app;

class Router {
  AuthGuard get authGuard => _authGuard;
  RootStackRouter get router => _router;

  late final AuthGuard _authGuard;
  late final RootStackRouter _router;

  Router() {
    _authGuard = AuthGuard(this);
    _router = app.AppRouter(authGuard: _authGuard);
  }

  loginRoute(void Function() onLogin) => app.LoginRoute(onLogin: onLogin);

  deckListRoute() => const app.DeckListRoute();

  deckDetailRoute(Deck deck) => app.DeckDetailRoute(deckId: deck.id.uuid);

  resourceViewRoute(Deck deck, Resource resource) =>
      app.ResourceViewRoute(deckId: deck.id.uuid, resourceId: resource.id.uuid);
}
