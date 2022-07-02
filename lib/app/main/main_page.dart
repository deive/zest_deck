import 'package:auto_route/auto_route.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:uuid/uuid.dart';
import 'package:zest_deck/app/main/main_provider.dart';
import 'package:zest_deck/app/main/nav_bar.dart';
import 'package:zest_deck/app/main/title_bar.dart';
import 'package:zest_deck/app/router/router_app.gr.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => PlatformScaffold(
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/logos/banner-bg.png"),
                      fit: BoxFit.cover)),
            ),
            AutoRouter(
              navigatorObservers: () =>
                  [RouteSelectionObserver(Provider.of<MainProvider>(context))],
            ),
            const TitleBar(),
            const NavBar(),
          ],
        ),
      );
}

class RouteSelectionObserver extends AutoRouterObserver {
  final MainProvider _mainProvider;

  RouteSelectionObserver(this._mainProvider);

  @override
  void didPush(Route route, Route? previousRoute) {
    _didChange(route);
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    _didChange(previousRoute);
  }

  @override
  void didRemove(Route route, Route? previousRoute) {
    _didChange(route);
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    _didChange(newRoute);
  }

  _didChange(Route? toRoute) {
    if (_checkDeckIdForRoute(toRoute)) {
      final id = _deckIdForRoute(toRoute);
      if (id == null) {
        _mainProvider.deckUnselected();
      } else {
        _mainProvider.deckSelected(id);
      }
    }
  }

  bool _checkDeckIdForRoute(Route? route) {
    if (route == null) return false;
    return route.settings is CustomPage;
  }

  UuidValue? _deckIdForRoute(Route? route) {
    if (route == null) return null;
    String? deckId;
    final args = route.settings.arguments;
    if (args is DeckDetailRouteArgs) {
      deckId = args.deckId;
    } else if (args is ResourceViewRouteArgs) {
      deckId = args.deckId;
    }
    if (deckId != null) {
      return UuidValue(deckId);
    } else {
      return null;
    }
  }
}
