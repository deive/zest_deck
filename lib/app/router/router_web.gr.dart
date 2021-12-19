// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

import 'package:auto_route/auto_route.dart' as _i5;
import 'package:flutter/material.dart' as _i6;

import '../decks/deck_detail_page.dart' as _i2;
import '../decks/deck_list_page.dart' as _i1;
import '../resources/resource_view_page.dart' as _i3;
import '../users/login_page.dart' as _i4;
import 'auth_guard.dart' as _i7;

class WebRouter extends _i5.RootStackRouter {
  WebRouter(
      {_i6.GlobalKey<_i6.NavigatorState>? navigatorKey,
      required this.authGuard})
      : super(navigatorKey);

  final _i7.AuthGuard authGuard;

  @override
  final Map<String, _i5.PageFactory> pagesMap = {
    DeckListRoute.name: (routeData) {
      return _i5.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i1.DeckListPage());
    },
    DeckDetailRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<DeckDetailRouteArgs>(
          orElse: () =>
              DeckDetailRouteArgs(deckId: pathParams.getString('deckId')));
      return _i5.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i2.DeckDetailPage(key: args.key, deckId: args.deckId));
    },
    ResourceViewRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<ResourceViewRouteArgs>(
          orElse: () => ResourceViewRouteArgs(
              deckId: pathParams.getString('deckId'),
              resourceId: pathParams.getString('resourceId')));
      return _i5.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i3.ResourceViewPage(
              key: args.key, deckId: args.deckId, resourceId: args.resourceId));
    },
    LoginRoute.name: (routeData) {
      final args = routeData.argsAs<LoginRouteArgs>();
      return _i5.MaterialPageX<bool>(
          routeData: routeData,
          child: _i4.LoginPage(key: args.key, onLogin: args.onLogin));
    }
  };

  @override
  List<_i5.RouteConfig> get routes => [
        _i5.RouteConfig('/#redirect',
            path: '/', redirectTo: '/decks', fullMatch: true),
        _i5.RouteConfig(DeckListRoute.name,
            path: '/decks', guards: [authGuard]),
        _i5.RouteConfig(DeckDetailRoute.name,
            path: '/deck/:deckId', guards: [authGuard]),
        _i5.RouteConfig(ResourceViewRoute.name,
            path: '/resource/:deckId/:resourceId', guards: [authGuard]),
        _i5.RouteConfig(LoginRoute.name, path: '/login'),
        _i5.RouteConfig('*#redirect',
            path: '*', redirectTo: '/decks', fullMatch: true)
      ];
}

/// generated route for [_i1.DeckListPage]
class DeckListRoute extends _i5.PageRouteInfo<void> {
  const DeckListRoute() : super(name, path: '/decks');

  static const String name = 'DeckListRoute';
}

/// generated route for [_i2.DeckDetailPage]
class DeckDetailRoute extends _i5.PageRouteInfo<DeckDetailRouteArgs> {
  DeckDetailRoute({_i6.Key? key, required String deckId})
      : super(name,
            path: '/deck/:deckId',
            args: DeckDetailRouteArgs(key: key, deckId: deckId),
            rawPathParams: {'deckId': deckId});

  static const String name = 'DeckDetailRoute';
}

class DeckDetailRouteArgs {
  const DeckDetailRouteArgs({this.key, required this.deckId});

  final _i6.Key? key;

  final String deckId;

  @override
  String toString() {
    return 'DeckDetailRouteArgs{key: $key, deckId: $deckId}';
  }
}

/// generated route for [_i3.ResourceViewPage]
class ResourceViewRoute extends _i5.PageRouteInfo<ResourceViewRouteArgs> {
  ResourceViewRoute(
      {_i6.Key? key, required String deckId, required String resourceId})
      : super(name,
            path: '/resource/:deckId/:resourceId',
            args: ResourceViewRouteArgs(
                key: key, deckId: deckId, resourceId: resourceId),
            rawPathParams: {'deckId': deckId, 'resourceId': resourceId});

  static const String name = 'ResourceViewRoute';
}

class ResourceViewRouteArgs {
  const ResourceViewRouteArgs(
      {this.key, required this.deckId, required this.resourceId});

  final _i6.Key? key;

  final String deckId;

  final String resourceId;

  @override
  String toString() {
    return 'ResourceViewRouteArgs{key: $key, deckId: $deckId, resourceId: $resourceId}';
  }
}

/// generated route for [_i4.LoginPage]
class LoginRoute extends _i5.PageRouteInfo<LoginRouteArgs> {
  LoginRoute({_i6.Key? key, required void Function() onLogin})
      : super(name,
            path: '/login', args: LoginRouteArgs(key: key, onLogin: onLogin));

  static const String name = 'LoginRoute';
}

class LoginRouteArgs {
  const LoginRouteArgs({this.key, required this.onLogin});

  final _i6.Key? key;

  final void Function() onLogin;

  @override
  String toString() {
    return 'LoginRouteArgs{key: $key, onLogin: $onLogin}';
  }
}
