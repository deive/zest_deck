import 'package:auto_route/auto_route.dart';
import 'package:zest_deck/app/decks/deck_detail_page.dart';
import 'package:zest_deck/app/decks/deck_list_page.dart';
import 'package:zest_deck/app/resources/resource_view_page.dart';
import 'package:zest_deck/app/router/auth_guard.dart';
import 'package:zest_deck/app/users/login_page.dart';

@AdaptiveAutoRouter(
  replaceInRouteName: 'Page,Route',
  routes: <AutoRoute>[
    AutoRoute(
        path: '/decks', page: DeckListPage, initial: true, guards: [AuthGuard]),
    AutoRoute(path: '/deck/:deckId', page: DeckDetailPage, guards: [AuthGuard]),
    AutoRoute(
        path: '/resource/:deckId/:resourceId',
        page: ResourceViewPage,
        guards: [AuthGuard]),
    AutoRoute<bool>(path: '/login', page: LoginPage),
    RedirectRoute(path: '*', redirectTo: '/decks')
  ],
)
class $AppRouter {}
