// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

import 'package:auto_route/auto_route.dart' as _i4;
import 'package:flutter/material.dart' as _i5;

import '../decks/deck_detail_page.dart' as _i2;
import '../decks/deck_list_page.dart' as _i1;
import '../users/login_page.dart' as _i3;
import 'auth_guard.dart' as _i6;

class WebRouter extends _i4.RootStackRouter {
  WebRouter(
      {_i5.GlobalKey<_i5.NavigatorState>? navigatorKey,
      required this.authGuard})
      : super(navigatorKey);

  final _i6.AuthGuard authGuard;

  @override
  final Map<String, _i4.PageFactory> pagesMap = {
    DeckListRoute.name: (routeData) {
      return _i4.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i1.DeckListPage());
    },
    DeckDetailRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<DeckDetailRouteArgs>(
          orElse: () =>
              DeckDetailRouteArgs(deckId: pathParams.getString('deckId')));
      return _i4.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i2.DeckDetailPage(key: args.key, deckId: args.deckId));
    },
    LoginRoute.name: (routeData) {
      final args = routeData.argsAs<LoginRouteArgs>();
      return _i4.MaterialPageX<bool>(
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
            path: '/deck/:deckId', guards: [authGuard]),
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
  DeckDetailRoute({_i5.Key? key, required String deckId})
      : super(name,
            path: '/deck/:deckId',
            args: DeckDetailRouteArgs(key: key, deckId: deckId),
            rawPathParams: {'deckId': deckId});

  static const String name = 'DeckDetailRoute';
}

class DeckDetailRouteArgs {
  const DeckDetailRouteArgs({this.key, required this.deckId});

  final _i5.Key? key;

  final String deckId;

  @override
  String toString() {
    return 'DeckDetailRouteArgs{key: $key, deckId: $deckId}';
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
