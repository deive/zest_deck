import 'package:auto_route/auto_route.dart';
import 'package:zest_deck/app/router/router.dart';

class AuthGuard extends AutoRouteGuard {
  bool userAuthenticated = false;
  final Router _router;

  AuthGuard(this._router);

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    // the navigation is paused until resolver.next() is called with either
    // true to resume/continue navigation or false to abort navigation
    if (userAuthenticated) {
      // if user is authenticated we continue
      resolver.next(true);
    } else {
      // we redirect the user to our login page
      router.push(_router.loginRoute(() {
        resolver.next(true);
      }));
    }
  }
}
