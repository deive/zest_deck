import 'package:auto_route/auto_route.dart';
import 'package:zest_deck/app/decks/deck_detail_page.dart';
import 'package:zest_deck/app/decks/deck_list_page.dart';
import 'package:zest_deck/app/favorites/favorites_page.dart';
import 'package:zest_deck/app/main/main_page.dart';
import 'package:zest_deck/app/resources/resource_view_page.dart';
import 'package:zest_deck/app/router/auth_guard.dart';
import 'package:zest_deck/app/settings/settings_page.dart';
import 'package:zest_deck/app/users/login_page.dart';

@CustomAutoRouter(
  replaceInRouteName: 'Page,Route',
  routes: <CustomRoute>[
    CustomRoute(path: '/', page: MainPage, initial: true, guards: [
      AuthGuard
    ], children: [
      CustomRoute(
          path: 'decks',
          page: DeckListPage,
          initial: true,
          transitionsBuilder: TransitionsBuilders.fadeIn),
      CustomRoute(
          path: 'settings',
          page: SettingsPage,
          transitionsBuilder: TransitionsBuilders.fadeIn),
      CustomRoute(
          path: 'favorites',
          page: FavoritesPage,
          transitionsBuilder: TransitionsBuilders.fadeIn),
      CustomRoute(
          path: 'deck/:deckId',
          page: DeckDetailPage,
          transitionsBuilder: TransitionsBuilders.fadeIn),
      CustomRoute(
          path: 'resource/:deckId/:resourceId',
          page: ResourceViewPage,
          transitionsBuilder: TransitionsBuilders.fadeIn),
    ]),
    CustomRoute<bool>(
        path: '/login',
        page: LoginPage,
        transitionsBuilder: TransitionsBuilders.fadeIn),
  ],
)
class $AppRouter {}
