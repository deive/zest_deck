// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************
//
// ignore_for_file: type=lint

import 'package:auto_route/auto_route.dart' as _i8;
import 'package:flutter/material.dart' as _i9;
import 'package:flutter/widgets.dart' as _i11;

import '../decks/deck_detail_page.dart' as _i6;
import '../decks/deck_list_page.dart' as _i3;
import '../favorites/favorites_page.dart' as _i5;
import '../main/main_page.dart' as _i1;
import '../resources/resource_view_page.dart' as _i7;
import '../settings/settings_page.dart' as _i4;
import '../users/login_page.dart' as _i2;
import 'auth_guard.dart' as _i10;

class AppRouter extends _i8.RootStackRouter {
  AppRouter(
      {_i9.GlobalKey<_i9.NavigatorState>? navigatorKey,
      required this.authGuard})
      : super(navigatorKey);

  final _i10.AuthGuard authGuard;

  @override
  final Map<String, _i8.PageFactory> pagesMap = {
    MainRoute.name: (routeData) {
      return _i8.CustomPage<dynamic>(
          routeData: routeData,
          child: const _i1.MainPage(),
          opaque: true,
          barrierDismissible: false);
    },
    LoginRoute.name: (routeData) {
      final args = routeData.argsAs<LoginRouteArgs>();
      return _i8.CustomPage<bool>(
          routeData: routeData,
          child: _i2.LoginPage(key: args.key, onLogin: args.onLogin),
          transitionsBuilder: _i8.TransitionsBuilders.fadeIn,
          opaque: true,
          barrierDismissible: false);
    },
    DeckListRoute.name: (routeData) {
      return _i8.CustomPage<dynamic>(
          routeData: routeData,
          child: const _i3.DeckListPage(),
          transitionsBuilder: _i8.TransitionsBuilders.fadeIn,
          opaque: true,
          barrierDismissible: false);
    },
    SettingsRoute.name: (routeData) {
      return _i8.CustomPage<dynamic>(
          routeData: routeData,
          child: const _i4.SettingsPage(),
          transitionsBuilder: _i8.TransitionsBuilders.fadeIn,
          opaque: true,
          barrierDismissible: false);
    },
    FavoritesRoute.name: (routeData) {
      return _i8.CustomPage<dynamic>(
          routeData: routeData,
          child: const _i5.FavoritesPage(),
          transitionsBuilder: _i8.TransitionsBuilders.fadeIn,
          opaque: true,
          barrierDismissible: false);
    },
    DeckDetailRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<DeckDetailRouteArgs>(
          orElse: () =>
              DeckDetailRouteArgs(deckId: pathParams.getString('deckId')));
      return _i8.CustomPage<dynamic>(
          routeData: routeData,
          child: _i6.DeckDetailPage(key: args.key, deckId: args.deckId),
          transitionsBuilder: _i8.TransitionsBuilders.fadeIn,
          opaque: true,
          barrierDismissible: false);
    },
    ResourceViewRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<ResourceViewRouteArgs>(
          orElse: () => ResourceViewRouteArgs(
              deckId: pathParams.getString('deckId'),
              resourceId: pathParams.getString('resourceId')));
      return _i8.CustomPage<dynamic>(
          routeData: routeData,
          child: _i7.ResourceViewPage(
              key: args.key, deckId: args.deckId, resourceId: args.resourceId),
          transitionsBuilder: _i8.TransitionsBuilders.fadeIn,
          opaque: true,
          barrierDismissible: false);
    }
  };

  @override
  List<_i8.RouteConfig> get routes => [
        _i8.RouteConfig(MainRoute.name, path: '/', guards: [
          authGuard
        ], children: [
          _i8.RouteConfig('#redirect',
              path: '',
              parent: MainRoute.name,
              redirectTo: 'decks',
              fullMatch: true),
          _i8.RouteConfig(DeckListRoute.name,
              path: 'decks', parent: MainRoute.name),
          _i8.RouteConfig(SettingsRoute.name,
              path: 'settings', parent: MainRoute.name),
          _i8.RouteConfig(FavoritesRoute.name,
              path: 'favorites', parent: MainRoute.name),
          _i8.RouteConfig(DeckDetailRoute.name,
              path: 'deck/:deckId', parent: MainRoute.name),
          _i8.RouteConfig(ResourceViewRoute.name,
              path: 'resource/:deckId/:resourceId', parent: MainRoute.name)
        ]),
        _i8.RouteConfig(LoginRoute.name, path: '/login')
      ];
}

/// generated route for
/// [_i1.MainPage]
class MainRoute extends _i8.PageRouteInfo<void> {
  const MainRoute({List<_i8.PageRouteInfo>? children})
      : super(MainRoute.name, path: '/', initialChildren: children);

  static const String name = 'MainRoute';
}

/// generated route for
/// [_i2.LoginPage]
class LoginRoute extends _i8.PageRouteInfo<LoginRouteArgs> {
  LoginRoute({_i11.Key? key, required void Function() onLogin})
      : super(LoginRoute.name,
            path: '/login', args: LoginRouteArgs(key: key, onLogin: onLogin));

  static const String name = 'LoginRoute';
}

class LoginRouteArgs {
  const LoginRouteArgs({this.key, required this.onLogin});

  final _i11.Key? key;

  final void Function() onLogin;

  @override
  String toString() {
    return 'LoginRouteArgs{key: $key, onLogin: $onLogin}';
  }
}

/// generated route for
/// [_i3.DeckListPage]
class DeckListRoute extends _i8.PageRouteInfo<void> {
  const DeckListRoute() : super(DeckListRoute.name, path: 'decks');

  static const String name = 'DeckListRoute';
}

/// generated route for
/// [_i4.SettingsPage]
class SettingsRoute extends _i8.PageRouteInfo<void> {
  const SettingsRoute() : super(SettingsRoute.name, path: 'settings');

  static const String name = 'SettingsRoute';
}

/// generated route for
/// [_i5.FavoritesPage]
class FavoritesRoute extends _i8.PageRouteInfo<void> {
  const FavoritesRoute() : super(FavoritesRoute.name, path: 'favorites');

  static const String name = 'FavoritesRoute';
}

/// generated route for
/// [_i6.DeckDetailPage]
class DeckDetailRoute extends _i8.PageRouteInfo<DeckDetailRouteArgs> {
  DeckDetailRoute({_i11.Key? key, required String deckId})
      : super(DeckDetailRoute.name,
            path: 'deck/:deckId',
            args: DeckDetailRouteArgs(key: key, deckId: deckId),
            rawPathParams: {'deckId': deckId});

  static const String name = 'DeckDetailRoute';
}

class DeckDetailRouteArgs {
  const DeckDetailRouteArgs({this.key, required this.deckId});

  final _i11.Key? key;

  final String deckId;

  @override
  String toString() {
    return 'DeckDetailRouteArgs{key: $key, deckId: $deckId}';
  }
}

/// generated route for
/// [_i7.ResourceViewPage]
class ResourceViewRoute extends _i8.PageRouteInfo<ResourceViewRouteArgs> {
  ResourceViewRoute(
      {_i11.Key? key, required String deckId, required String resourceId})
      : super(ResourceViewRoute.name,
            path: 'resource/:deckId/:resourceId',
            args: ResourceViewRouteArgs(
                key: key, deckId: deckId, resourceId: resourceId),
            rawPathParams: {'deckId': deckId, 'resourceId': resourceId});

  static const String name = 'ResourceViewRoute';
}

class ResourceViewRouteArgs {
  const ResourceViewRouteArgs(
      {this.key, required this.deckId, required this.resourceId});

  final _i11.Key? key;

  final String deckId;

  final String resourceId;

  @override
  String toString() {
    return 'ResourceViewRouteArgs{key: $key, deckId: $deckId, resourceId: $resourceId}';
  }
}
