// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

import 'package:auto_route/auto_route.dart' as _i4;
import 'package:flutter/material.dart' as _i5;
import 'package:zest_deck/app/decks/deck.dart' as _i7;
import 'package:zest_deck/app/decks/deck_detail_page.dart' as _i2;
import 'package:zest_deck/app/decks/deck_list_page.dart' as _i1;
import 'package:zest_deck/app/router/auth_guard.dart' as _i6;
import 'package:zest_deck/app/users/login_page.dart' as _i3;

class AppRouter extends _i4.RootStackRouter {
  AppRouter(
      {_i5.GlobalKey<_i5.NavigatorState>? navigatorKey,
      required this.authGuard})
      : super(navigatorKey);

  final _i6.AuthGuard authGuard;

  @override
  final Map<String, _i4.PageFactory> pagesMap = {
    DeckListRoute.name: (routeData) {
      return _i4.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i1.DeckListPage());
    },
    DeckDetailRoute.name: (routeData) {
      final args = routeData.argsAs<DeckDetailRouteArgs>();
      return _i4.AdaptivePage<dynamic>(
          routeData: routeData,
          child: _i2.DeckDetailPage(key: args.key, deck: args.deck));
    },
    LoginRoute.name: (routeData) {
      final args = routeData.argsAs<LoginRouteArgs>();
      return _i4.AdaptivePage<bool>(
          routeData: routeData,
          child: _i3.LoginPage(key: args.key, onLogin: args.onLogin));
    }
  };

  @override
  List<_i4.RouteConfig> get routes => [
        _i4.RouteConfig('/#redirect',
            path: '/', redirectTo: '/decks', fullMatch: true),
        _i4.RouteConfig(DeckListRoute.name,
            path: '/decks', guards: [authGuard]),
        _i4.RouteConfig(DeckDetailRoute.name,
            path: '/deck/:id', guards: [authGuard]),
        _i4.RouteConfig(LoginRoute.name, path: '/login'),
        _i4.RouteConfig('*#redirect',
            path: '*', redirectTo: '/decks', fullMatch: true)
      ];
}

/// generated route for [_i1.DeckListPage]
class DeckListRoute extends _i4.PageRouteInfo<void> {
  const DeckListRoute() : super(name, path: '/decks');

  static const String name = 'DeckListRoute';
}

/// generated route for [_i2.DeckDetailPage]
class DeckDetailRoute extends _i4.PageRouteInfo<DeckDetailRouteArgs> {
  DeckDetailRoute({_i5.Key? key, required _i7.Deck deck})
      : super(name,
            path: '/deck/:id', args: DeckDetailRouteArgs(key: key, deck: deck));

  static const String name = 'DeckDetailRoute';
}

class DeckDetailRouteArgs {
  const DeckDetailRouteArgs({this.key, required this.deck});

  final _i5.Key? key;

  final _i7.Deck deck;

  @override
  String toString() {
    return 'DeckDetailRouteArgs{key: $key, deck: $deck}';
  }
}

/// generated route for [_i3.LoginPage]
class LoginRoute extends _i4.PageRouteInfo<LoginRouteArgs> {
  LoginRoute({_i5.Key? key, required void Function() onLogin})
      : super(name,
            path: '/login', args: LoginRouteArgs(key: key, onLogin: onLogin));

  static const String name = 'LoginRoute';
}

class LoginRouteArgs {
  const LoginRouteArgs({this.key, required this.onLogin});

  final _i5.Key? key;

  final void Function() onLogin;

  @override
  String toString() {
    return 'LoginRouteArgs{key: $key, onLogin: $onLogin}';
  }
}
