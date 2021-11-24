import 'package:auto_route/auto_route.dart';
import 'package:zest_deck/app/router.gr.dart';
import 'package:zest_deck/decks/deck_detail_page.dart';
import 'package:zest_deck/decks/deck_list_page.dart';
import 'package:zest_deck/users/login_page.dart';

@AdaptiveAutoRouter(
  replaceInRouteName: 'Page,Route',
  routes: <AutoRoute>[
    AutoRoute(
        path: '/decks', page: DeckListPage, initial: true, guards: [AuthGuard]),
    AutoRoute(path: '/deck/:id', page: DeckDetailPage, guards: [AuthGuard]),
    AutoRoute<bool>(path: '/login', page: LoginPage),
    RedirectRoute(path: '*', redirectTo: '/decks')
  ],
)
class $AppRouter {}

class AuthGuard extends AutoRouteGuard {
  bool userAuthenticated = false;

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    // the navigation is paused until resolver.next() is called with either
    // true to resume/continue navigation or false to abort navigation
    if (userAuthenticated) {
      // if user is authenticated we continue
      resolver.next(true);
    } else {
      // we redirect the user to our login page
      router.push(LoginRoute(onLogin: () {
        resolver.next(true);
      }));
    }
  }
}
