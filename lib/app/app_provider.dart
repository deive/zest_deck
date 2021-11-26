import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:zest_deck/app/app_data.dart';
import 'package:zest_deck/app/router.dart';
import 'package:zest_deck/app/router.gr.dart';

/// App-level provider.
class AppProvider with ChangeNotifier {
  late Box<AppData> _appData;
  AppInfo? _appInfo;

  static const _appBox = 'app';
  static const _appBoxInstallId = 'installId';
  static const _appBoxCurrentUserId = 'currentUserId';

  final _appRouter = AppRouter(authGuard: AuthGuard());

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

  init() async {
    // Load config
    final configStr = await rootBundle.loadString("assets/config.json");
    _appInfo = AppInfo.fromJson(_os, json.decode(configStr));

    // Static config
    await Hive.initFlutter(await getHiveDirectory());
    Hive.registerAdapter(AppDataAdapter());

    // Load saved data
    _appData = await Hive.openBox<AppData>(_appBox);
    final data = _appData.get(_appBoxInstallId);
    if (data == null) {
      final installId = AppData(valString: const Uuid().v4().toString());
      _appData.put(_appBoxInstallId, installId);
    }
    notifyListeners();
  }

  routeInformationParser() => _appRouter.defaultRouteParser();
  routerDelegate() => _appRouter.delegate();

  Future<String> getHiveDirectory() async {
    if (kIsWeb) return _appInfo!.appId;
    final supportDir = await getApplicationSupportDirectory();
    return "${supportDir.path}/${_appInfo!.appId}";
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
