import 'package:zest/app/navigation/app_router.gr.dart';

/// App-level provider.
class AppProvider {
  final router = AppRouter();

  getRouteInformationParser() => router.defaultRouteParser();
  getRouterDelegate() => router.delegate();
}
