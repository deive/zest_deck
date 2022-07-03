import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:zest/app/app.gr.dart';
import 'package:zest/app/app_page.dart';
import 'package:zest/generated/l10n.dart';

class App extends StatelessWidget {
  App({Key? key}) : super(key: key);

  final router = AppRouter();

  @override
  Widget build(BuildContext context) => WidgetsApp.router(
        color: const Color.fromARGB(255, 0, 0, 0),
        restorationScopeId: 'app',
        onGenerateTitle: (BuildContext context) => S.of(context).appName,
        localizationsDelegates: const [S.delegate],
        supportedLocales: S.delegate.supportedLocales,
        routeInformationParser: router.defaultRouteParser(),
        routerDelegate: router.delegate(),
      );
}

@CustomAutoRouter(
    replaceInRouteName: 'Page,Route',
    routes: [CustomRoute(path: '/', page: AppPage, initial: true)])
class $AppRouter {}


  // routes: <CustomRoute>[
  //   CustomRoute(path: '/', page: AppScreen, initial: true, 
  //   // children: [
  //   //   CustomRoute(
  //   //       path: 'decks',
  //   //       page: DeckListPage,
  //   //       initial: true,
  //   //       transitionsBuilder: TransitionsBuilders.fadeIn),
  //   //   CustomRoute(
  //   //       path: 'settings',
  //   //       page: SettingsPage,
  //   //       transitionsBuilder: TransitionsBuilders.fadeIn),
  //   //   CustomRoute(
  //   //       path: 'favorites',
  //   //       page: FavoritesPage,
  //   //       transitionsBuilder: TransitionsBuilders.fadeIn),
  //   //   CustomRoute(
  //   //       path: 'deck/:deckId',
  //   //       page: DeckDetailPage,
  //   //       transitionsBuilder: TransitionsBuilders.fadeIn),
  //   //   CustomRoute(
  //   //       path: 'resource/:deckId/:resourceId',
  //   //       page: ResourceViewPage,
  //   //       transitionsBuilder: TransitionsBuilders.fadeIn),
  //   // ]),
  // ]);