import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localisations.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:provider/provider.dart';
import 'package:zest_deck/app/api_provider.dart';
import 'package:zest_deck/app/app_provider.dart';
import 'package:zest_deck/app/decks/decks_provider.dart';
import 'package:zest_deck/app/theme_provider.dart';
import 'package:zest_deck/app/users/users_provider.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: [
          Provider(create: (context) => ThemeProvider()),
          Provider(create: (context) => APIProvider()),
          ChangeNotifierProvider(create: (context) => AppProvider()..init()),
          ChangeNotifierAppProvider<UsersProvider>(
            create: (context) => UsersProvider()..init(),
            update: (context, app, api, users) => users!.onUpdate(app, api),
          ),
          ChangeNotifierUsersProvider<DecksProvider>(
            create: (context) => DecksProvider(),
            update: (context, app, api, users, decks) =>
                decks!.onUpdate(app, api, users),
          )
        ],
        builder: (context, child) {
          final appProvider = Provider.of<AppProvider>(context);
          if (appProvider.appInfo == null) {
            return _buildLoadingUI(context);
          } else {
            return _buildApp(context, appProvider);
          }
        },
      );

  Widget _buildLoadingUI(BuildContext context) =>
      Center(child: PlatformCircularProgressIndicator());

  Widget _buildApp(BuildContext context, AppProvider appProvider) =>
      PlatformApp.router(
        restorationScopeId: 'app',
        onGenerateTitle: (BuildContext context) =>
            AppLocalizations.of(context)!.appName,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        material: (context, platform) =>
            Provider.of<ThemeProvider>(context).createThemeForMaterial(),
        cupertino: (context, platform) =>
            Provider.of<ThemeProvider>(context).createThemeForCupertino(),
        routeInformationParser: appProvider.routeInformationParser(),
        routerDelegate: appProvider.routerDelegate(),
      );
}

class ChangeNotifierAppProvider<R extends ChangeNotifier?>
    extends ChangeNotifierProxyProvider2<AppProvider, APIProvider, R> {
  ChangeNotifierAppProvider({
    Key? key,
    required Create<R> create,
    required ProxyProviderBuilder2<AppProvider, APIProvider, R> update,
    bool? lazy,
    TransitionBuilder? builder,
    Widget? child,
  }) : super(
          key: key,
          create: create,
          update: update,
          lazy: lazy,
          builder: builder,
          child: child,
        );
}

class ChangeNotifierUsersProvider<R extends ChangeNotifier?>
    extends ChangeNotifierProxyProvider3<AppProvider, APIProvider,
        UsersProvider, R> {
  ChangeNotifierUsersProvider({
    Key? key,
    required Create<R> create,
    required ProxyProviderBuilder3<AppProvider, APIProvider, UsersProvider, R>
        update,
    bool? lazy,
    TransitionBuilder? builder,
    Widget? child,
  }) : super(
          key: key,
          create: create,
          update: update,
          lazy: lazy,
          builder: builder,
          child: child,
        );
}

mixin AppAndAPIProvider {
  @protected
  AppProvider get app => _app;
  @protected
  APIProvider get api => _api;

  late AppProvider _app;
  late APIProvider _api;

  String? _lastUserId;
  bool _loaded = false;

  @protected
  void onAppProviderUpdate(AppProvider app, APIProvider api) async {
    _app = app;
    _api = api;
    if (checkForLoaded()) {
      _loaded = true;
      await load();
    }
    if (_loaded) {
      if (_lastUserId == null && _app.currentUserId != null) {
        _lastUserId = _app.currentUserId;
        onLogin();
      } else if (_lastUserId != null && _app.currentUserId == null) {
        _lastUserId = null;
        onLogout();
      } else if (_lastUserId != _app.currentUserId) {
        _lastUserId = _app.currentUserId;
        onLoginChanged();
      }
    }
  }

  /// Called once for 1st time load functionality, e.g. registering Hive adapters.
  @protected
  load() {
    log("load()");
  }

  /// Called every time a user is set as logged in.
  @protected
  void onLogin() {
    log("onLogin()");
  }

  /// Called every time users are set as logged out.
  @protected
  void onLogout() {
    log("onLogout()");
  }

  /// Called if the logged in user has changed to a new user.
  @protected
  void onLoginChanged() {
    log("onLoginChanged()");
  }

  @protected
  checkForLoaded() => !_loaded && app.appInfo != null;
}

mixin UsersAndAPIProvider on AppAndAPIProvider {
  @protected
  UsersProvider get user => _user;
  @protected
  String? get currentAuthToken => user.currentData?.authToken;

  late UsersProvider _user;

  String? _lastAuthToken;

  @protected
  void onUserProviderUpdate(
      AppProvider app, APIProvider api, UsersProvider user) {
    _user = user;
    onAppProviderUpdate(app, api);
    if (_loaded) {
      if (_lastAuthToken == null && currentAuthToken != null) {
        _lastAuthToken = currentAuthToken;
        onRecievedAuthToken();
      } else if (_lastAuthToken != null && currentAuthToken == null) {
        _lastAuthToken = null;
        onLostAuthToken();
      } else if (_lastAuthToken != currentAuthToken) {
        _lastAuthToken = currentAuthToken;
        onRecievedAuthToken();
      }
    }
  }

  /// Called every time the logged in user has a new auth token.
  @protected
  void onRecievedAuthToken() {
    log("onRecievedAuthToken()");
  }

  /// Called every time the logged user's auth token is emptied/expired.
  @protected
  void onLostAuthToken() {
    log("onLostAuthToken()");
  }
}
