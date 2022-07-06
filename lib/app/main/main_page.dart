import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:zest/app/app_provider.dart';
import 'package:zest/app/main/auth_provider.dart';
import 'package:zest/app/main/login_dialog.dart';
import 'package:zest/app/main/main_provider.dart';
import 'package:zest/app/main/theme_provider.dart';
import 'package:zest/app/navigation/nav_bar.dart';

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
    final isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return [
      ChangeNotifierProvider(
        create: (context) => AuthProvider(),
      ),
      ChangeNotifierProxyProvider<AuthProvider, MainProvider>(
        create: (context) => MainProvider(
            Provider.of<AppProvider>(context, listen: false), null),
        update: (context, value, previous) => MainProvider(
            Provider.of<AppProvider>(context, listen: false), value),
      ),
      ChangeNotifierProxyProvider<MainProvider, ThemeProvider>(
        create: (context) => ThemeProvider(isDark, null),
        update: (context, value, previous) => ThemeProvider(isDark, value),
      ),
    ];
  }

  Widget _mainPage(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final opacity = authProvider.showLoginDialog ? 0.1 : 1.0;
    return PlatformScaffold(
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
              duration: const Duration(milliseconds: 500),
              opacity: opacity,
              child: const AutoRouter()),
          AnimatedOpacity(
              duration: const Duration(milliseconds: 500),
              opacity: opacity,
              child: const NavBar()),
          AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              child: authProvider.showLoginDialog
                  ? const LoginDialog()
                  : const SizedBox.shrink()),
        ],
      ),
    );
  }
}
