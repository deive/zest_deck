import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localisations.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:provider/provider.dart';
import 'package:zest_deck/app/api_provider.dart';
import 'package:zest_deck/app/app_provider.dart';
import 'package:zest_deck/app/decks/decks_download_provider.dart';
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
          ),
          ChangeNotifierDecksProvider<DecksDownloadProvider>(
            create: (context) => DecksDownloadProvider()..init(),
            update: (context, app, api, users, decks, dl) =>
                dl!.onUpdate(app, api, users, decks),
          ),
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

/// Tie in to any provider that is an AppAndAPIProvider,
/// used to make MultiProvider app providers list much more readble.
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

/// Tie in to any provider that is an UsersAndAPIProvider,
/// used to make MultiProvider app providers list much more readble.
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

/// Tie in to any provider that is an DecksAndAPIProvider,
/// used to make MultiProvider app providers list much more readble.
class ChangeNotifierDecksProvider<R extends ChangeNotifier?>
    extends ChangeNotifierProxyProvider4<AppProvider, APIProvider,
        UsersProvider, DecksProvider, R> {
  ChangeNotifierDecksProvider({
    Key? key,
    required Create<R> create,
    required ProxyProviderBuilder4<AppProvider, APIProvider, UsersProvider,
            DecksProvider, R>
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
