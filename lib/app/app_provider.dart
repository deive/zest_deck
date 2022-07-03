import 'package:zest/app/app.gr.dart';

/// App-level provider.
class AppProvider {
  final router = AppRouter();

  getRouteInformationParser() => router.defaultRouteParser();
  getRouterDelegate() => router.delegate();
}
