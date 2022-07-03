import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zest/app/app_provider.dart';
import 'package:zest/generated/l10n.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Provider(
        create: (context) => AppProvider(),
        child: Builder(builder: (context) {
          return WidgetsApp.router(
            color: const Color.fromARGB(255, 0, 0, 0),
            restorationScopeId: 'app',
            onGenerateTitle: (BuildContext context) => S.of(context).appName,
            localizationsDelegates: const [S.delegate],
            supportedLocales: S.delegate.supportedLocales,
            routeInformationParser:
                Provider.of<AppProvider>(context, listen: false)
                    .getRouteInformationParser(),
            routerDelegate: Provider.of<AppProvider>(context, listen: false)
                .getRouterDelegate(),
          );
        }),
      );
}
