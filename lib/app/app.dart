import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localisations.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:provider/provider.dart';
import 'package:zest_deck/app/api_provider.dart';
import 'package:zest_deck/app/app_provider.dart';
import 'package:zest_deck/app/theme_provider.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: [
          Provider(create: (context) => ThemeProvider()),
          Provider(create: (context) => APIProvider()),
          ChangeNotifierProvider(create: (context) => AppProvider()..init()),
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
