import 'package:auto_route/auto_route.dart';
import 'package:zest/app/deck_detail/deck_detail_page.dart';
import 'package:zest/app/main_page.dart';
import 'package:zest/app/deck_list/deck_list_page.dart';
import 'package:zest/app/favorites/favorites_page.dart';
import 'package:zest/app/resource/resource_view_page.dart';
import 'package:zest/app/settings/settings_page.dart';

@CustomAutoRouter(replaceInRouteName: 'Page,Route', routes: [
  CustomRoute(path: '/', page: MainPage, initial: true, children: [
    CustomRoute(
        path: 'decks',
        page: DeckListPage,
        initial: true,
        transitionsBuilder: TransitionsBuilders.slideLeft),
    CustomRoute(
        path: 'favorites',
        page: FavoritesPage,
        transitionsBuilder: TransitionsBuilders.slideLeft),
    CustomRoute(
        path: 'settings',
        page: SettingsPage,
        transitionsBuilder: TransitionsBuilders.slideLeft),
    CustomRoute(
        path: 'deck/:deckId',
        page: DeckDetailPage,
        transitionsBuilder: TransitionsBuilders.slideLeft),
    CustomRoute(
        path: 'resource/:deckId/:resourceId',
        page: ResourceViewPage,
        transitionsBuilder: TransitionsBuilders.slideLeft),
  ])
])
class $AppRouter {}
