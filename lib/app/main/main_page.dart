import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:zest/api/api_provider.dart';
import 'package:zest/app/deck_list/deck_list_provider.dart';
import 'package:zest/app/favorites/favorites_provider.dart';
import 'package:zest/app/main/auth_provider.dart';
import 'package:zest/app/main/login_dialog.dart';
import 'package:zest/app/main/main_provider.dart';
import 'package:zest/app/main/theme_provider.dart';
import 'package:zest/app/navigation/nav_bar.dart';
import 'package:zest/app/download/download_provider.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: _providers(context),
      child: Builder(
        builder: (context) => _mainPage(context),
      ),
    );
  }

  List<SingleChildWidget> _providers(BuildContext context) {
    return [
      // APIProvider
      Provider(
        create: (context) => APIProvider(),
      ),
      // AuthProvider
      ChangeNotifierProvider(
        create: (context) => AuthProvider(
          context.read(),
          context.read(),
        ),
      ),
      // DeckListProvider
      ChangeNotifierProxyProvider<AuthProvider, DeckListProvider>(
        create: (context) => DeckListProvider(
          context.read(),
          context.read(),
          context.read(),
          null,
        ),
        update: (BuildContext context, value, previous) => DeckListProvider(
          context.read(),
          context.read(),
          value,
          previous,
        ),
      ),
      // MainProvider
      ChangeNotifierProxyProvider2<AuthProvider, DeckListProvider,
          MainProvider>(
        create: (context) => MainProvider(
          context.read(),
          context.read(),
          context.read(),
          null,
        ),
        update: (context, value, value2, previous) => MainProvider(
          context.read(),
          value,
          value2,
          previous,
        ),
      ),
      // DownloadProvider
      ChangeNotifierProxyProvider<AuthProvider, FavoritesProvider>(
        create: (context) => FavoritesProvider(
          context.read(),
          null,
        ),
        update: (context, value, previous) => FavoritesProvider(
          value,
          previous,
        ),
      ),
      if (!kIsWeb)
        // DownloadProvider
        ChangeNotifierProxyProvider<AuthProvider, DownloadProvider>(
          create: (context) => DownloadProvider(
            context.read(),
            null,
          ),
          update: (context, value, previous) => DownloadProvider(
            value,
            previous,
          ),
        ),
      // ThemeProvider
      ChangeNotifierProxyProvider<MainProvider, ThemeProvider>(
        create: (context) => ThemeProvider(
          null,
        ),
        update: (context, value, previous) => ThemeProvider(
          value,
        ),
      ),
    ];
  }

  Widget _mainPage(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final authProvider = context.watch<AuthProvider>();
    final opacity = !authProvider.initComplete || authProvider.showLoginDialog
        ? authProvider.reloginRequested
            ? 0.1
            : 0.0
        : 1.0;
    return WillPopScope(
      onWillPop: () async {
        final authProvider = context.read<AuthProvider>();
        if (authProvider.reloginRequested) {
          authProvider.cancelRelogin();
          return false;
        } else {
          return true;
        }
      },
      child: PlatformScaffold(
        material: (context, platform) =>
            MaterialScaffoldData(resizeToAvoidBottomInset: false),
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/banner-bg.png"),
                      fit: BoxFit.cover)),
            ),
            AnimatedOpacity(
                duration: themeProvider.fadeTransitionDuration,
                opacity: opacity,
                child: const AutoRouter()),
            AnimatedOpacity(
                duration: themeProvider.fadeTransitionDuration,
                opacity: opacity,
                child: const NavBar()),
            AnimatedSwitcher(
                duration: themeProvider.fadeTransitionDuration,
                child: authProvider.showLoginDialog
                    ? const LoginDialog()
                    : const SizedBox.shrink()),
          ],
        ),
      ),
    );
  }
}
