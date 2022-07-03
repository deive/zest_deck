import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zest/app/app_provider.dart';
import 'package:zest/app/deck_detail/deck_detail_page.dart';
import 'package:zest/app/main_page.dart';
import 'package:zest/app/deck_list/deck_list_page.dart';
import 'package:zest/app/favorites/favorites_page.dart';
import 'package:zest/app/resource/resource_view_page.dart';
import 'package:zest/app/settings/settings_page.dart';
import 'package:zest/generated/l10n.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Provider(
        create: (context) => AppProvider(),
        child: Builder(builder: (context) {
          return WidgetsApp.router(
            color: const Color.fromARGB(255, 0, 0, 0),
            restorationScopeId: 'app',
            onGenerateTitle: (BuildContext context) => S.of(context).appName,
            localizationsDelegates: const [S.delegate],
            supportedLocales: S.delegate.supportedLocales,
            routeInformationParser:
                Provider.of<AppProvider>(context, listen: false)
                    .getRouteInformationParser(),
            routerDelegate: Provider.of<AppProvider>(context, listen: false)
                .getRouterDelegate(),
          );
        }),
      );
}

@CustomAutoRouter(replaceInRouteName: 'Page,Route', routes: [
  CustomRoute(path: '/', page: MainPage, initial: true, children: [
    CustomRoute(
        path: 'decks',
        page: DeckListPage,
        initial: true,
        transitionsBuilder: TransitionsBuilders.fadeIn),
    CustomRoute(
        path: 'favorites',
        page: FavoritesPage,
        transitionsBuilder: TransitionsBuilders.fadeIn),
    CustomRoute(
        path: 'settings',
        page: SettingsPage,
        transitionsBuilder: TransitionsBuilders.fadeIn),
    CustomRoute(
        path: 'deck/:deckId',
        page: DeckDetailPage,
        transitionsBuilder: TransitionsBuilders.fadeIn),
    CustomRoute(
        path: 'resource/:deckId/:resourceId',
        page: ResourceViewPage,
        transitionsBuilder: TransitionsBuilders.fadeIn),
  ])
])
class $AppRouter {}
