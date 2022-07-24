import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:provider/provider.dart';
import 'package:zest/app/app_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (context) => AppProvider(),
        child: Builder(builder: (context) {
          final appProvider = Provider.of<AppProvider>(context);
          if (!appProvider.initComplete) {
            return const SizedBox.shrink();
          } else {
            return PlatformApp.router(
              debugShowCheckedModeBanner: false,
              color: const Color.fromARGB(255, 0, 0, 0),
              restorationScopeId: 'app',
              onGenerateTitle: (BuildContext context) =>
                  AppLocalizations.of(context)!.appName,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              routeInformationParser: appProvider.getRouteInformationParser(),
              routerDelegate: appProvider.getRouterDelegate(),
            );
          }
        }),
      );
}
