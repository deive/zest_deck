import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:zest_deck/app/api/api_provider.dart';
import 'package:zest_deck/app/api/api_request_response.dart';
import 'package:zest_deck/app/app_data.dart';
import 'package:zest_deck/app/decks/deck.dart';
import 'package:zest_deck/app/models/company.dart';
import 'package:zest_deck/app/models/resource.dart';
import 'package:zest_deck/app/models/section.dart';
import 'package:zest_deck/app/models/task.dart';
import 'package:zest_deck/app/router/router.dart';

/// App-level provider.
class AppProvider with ChangeNotifier {
  Router get router => _appRouter;
  late Box<AppData> _appData;
  AppInfo? _appInfo;

  static const _appBox = 'app';
  static const _appBoxInstallId = 'installId';
  static const _appBoxCurrentUserId = 'currentUserId';

  final _appRouter = Router();

  /// Static config from assets/config.json.
  AppInfo? get appInfo => _appInfo;

  /// Install id, this is generated on first run.
  String get appInstallId => _appData.get(_appBoxInstallId)!.valString!;

  // Current user id.
  String? get currentUserId => _appData.get(_appBoxCurrentUserId)?.valString;

  /// Update the current user id (and the routers authGuard).
  set currentUserId(String? userId) {
    _appRouter.authGuard.userAuthenticated = userId != null;
    _setString(_appBoxCurrentUserId, userId);
  }

  String apiPath(String path) =>
      "${_appInfo!.apiHost}/${_appInfo!.apiPath}/$path";

  resetNavigation() {
    _appRouter.router.replaceAll([_appRouter.deckListRoute()]);
  }

  init() async {
    // Load config
    final configStr = await rootBundle.loadString("assets/config.json");
    _appInfo = AppInfo.fromJson(_os, json.decode(configStr));

    // Static config
    await Hive.initFlutter(await getHiveDirectory());
    Hive.registerAdapter(UuidValueAdapter());
    Hive.registerAdapter(AppDataAdapter());
    Hive.registerAdapter(ZestAPIRequestResponseAdapter());
    Hive.registerAdapter(CompanyAdapter());
    Hive.registerAdapter(DeckAdapter());
    Hive.registerAdapter(ResourceAdapter());
    Hive.registerAdapter(ResourceFileAdapter());
    Hive.registerAdapter(ResourceFileTypeAdapter());
    Hive.registerAdapter(ResourceProcessingStageAdapter());
    Hive.registerAdapter(ResourcePropertyAdapter());
    Hive.registerAdapter(ResourceTypeAdapter());
    Hive.registerAdapter(SectionAdapter());
    Hive.registerAdapter(SectionTypeAdapter());
    Hive.registerAdapter(TaskAdapter());

    // Load saved data
    _appData = await Hive.openBox<AppData>(_appBox);
    final data = _appData.get(_appBoxInstallId);
    if (data == null) {
      final installId = AppData(valString: const Uuid().v4().toString());
      _appData.put(_appBoxInstallId, installId);
    }
    if (currentUserId != null) {
      _appRouter.authGuard.userAuthenticated = true;
    }
    notifyListeners();
  }

  routeInformationParser() => _appRouter.router.defaultRouteParser();
  routerDelegate() => _appRouter.router.delegate();

  Future<String> getHiveDirectory() async {
    if (kIsWeb) return _appInfo!.appId;
    final supportDir = await getApplicationSupportDirectory();
    return supportDir.path;
  }

  _setString(String key, String? val) {
    _appData.put(key, AppData(valString: val));
    notifyListeners();
  }

  String get _os {
    if (kIsWeb) {
      return "Web";
    } else if (Platform.isIOS) {
      return "iOS";
    } else if (Platform.isAndroid) {
      return "Android";
    } else if (Platform.isWindows) {
      return "Windows";
    } else if (Platform.isLinux) {
      return "Linux";
    } else if (Platform.isMacOS) {
      return "MacOS";
    } else if (Platform.isFuchsia) {
      return "Fuchsia";
    } else {
      return "Unknown";
    }
  }
}

mixin AppAndAPIProvider {
  @protected
  AppProvider get app => _app;
  @protected
  APIProvider get api => _api;

  @protected
  bool loaded = false;

  late AppProvider _app;
  late APIProvider _api;

  String? _lastUserId;

  @protected
  void onAppProviderUpdate(AppProvider app, APIProvider api) async {
    _app = app;
    _api = api;
    if (checkForLoaded()) {
      loaded = true;
      await load();
    }
    if (loaded) {
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
  load() {}

  /// Called every time a user is set as logged in.
  @protected
  void onLogin() {}

  /// Called every time users are set as logged out.
  @protected
  void onLogout() {}

  /// Called if the logged in user has changed to a new user.
  @protected
  void onLoginChanged() {}

  @protected
  checkForLoaded() => !loaded && app.appInfo != null;
}
