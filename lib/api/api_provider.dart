import 'package:zest_deck/api/api.dart';
import 'package:zest_deck/app/app_provider.dart';

/// All API methods.
class APIProvider extends BaseAPIProvider {
// TODO: Complete API methods.

  @override
  late AppProvider app;

  APIProvider onUpdate(AppProvider app) {
    this.app = app;
    return this;
  }
}
