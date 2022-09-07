import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:zest/api/api_request_response.dart';
import 'package:zest/api/models/company.dart';
import 'package:zest/api/models/deck.dart';
import 'package:zest/api/models/resource.dart';
import 'package:zest/api/models/section.dart';
import 'package:zest/api/models/task.dart';
import 'package:zest/api/models/user.dart';
import 'package:zest/app/download/file_download.dart';
import 'package:zest/app/app_data.dart';
import 'package:zest/app/favorites/favorite.dart';
import 'package:zest/app/favorites/recently_viewed.dart';
import 'package:zest/app/navigation/app_router.gr.dart';

/// App-level provider.
class AppProvider with ChangeNotifier {
  AppProvider() {
    _init();
  }

  String? get routeDeckId => _routeDeckId;
  String? get routeResourceId => _routeResourceId;
  late AppRouter router;
  bool get initComplete => _initComplete;

  String? _routeDeckId;
  String? _routeResourceId;
  bool _initComplete = false;
  static const _appBox = 'app';
  late Box<AppData> _appData;

  DefaultRouteParser getRouteInformationParser() => router.defaultRouteParser();
  AutoRouterDelegate getRouterDelegate() => router.delegate(
        navigatorObservers: () => [
          MyObserver(_setRouteDeckId, _setRouteResourceId),
        ],
      );

  Future<void> putString(String key, String value) =>
      _appData.put(key, AppData(valString: value));
  String? getString(String key) => _appData.get(key)?.valString;
  DateTime? getDateTime(String key) => _appData.get(key)?.valDateTime;
  Future<void> putDateTime(String key, DateTime value) =>
      _appData.put(key, AppData(valDateTime: value));
  Future<void> removeValue(String key) => _appData.delete(key);

  Future<String> getHiveDirectory() async {
    if (kIsWeb) return "zest";
    final supportDir = await getApplicationSupportDirectory();
    return supportDir.path;
  }

  void _setRouteDeckId(String? routeDeckId) {
    if (_routeDeckId != routeDeckId) {
      _routeDeckId = routeDeckId;
      _notifyAsync();
    }
  }

  void _setRouteResourceId(String? routeResourceId) {
    if (_routeResourceId != routeResourceId) {
      _routeResourceId = routeResourceId;
      _notifyAsync();
    }
  }

  void _notifyAsync() {
    () async {
      await Future.delayed(Duration.zero);
      notifyListeners();
    }();
  }

  Future<void> _init() async {
    await Hive.initFlutter(await getHiveDirectory());
    Hive.registerAdapter(UuidValueAdapter());
    Hive.registerAdapter(AppDataAdapter());
    Hive.registerAdapter(ZestAPIRequestResponseAdapter());
    Hive.registerAdapter(UserAdapter());
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
    Hive.registerAdapter(FileDownloadRequestAdapter());
    Hive.registerAdapter(DownloadRequestTypeAdapter());
    Hive.registerAdapter(FavoriteAdapter());
    Hive.registerAdapter(RecentlyViewedAdapter());
    _appData = await Hive.openBox<AppData>(_appBox);
    router = AppRouter();
    _initComplete = true;
    notifyListeners();
  }
}

/// List of data types in use for hive.
abstract class HiveDataType {
  static const uuidValue = 0;
  static const appData = 1;
  static const response = 2;
  static const user = 3;
  static const company = 4;
  static const deck = 5;
  static const resource = 6;
  static const resourceFile = 7;
  static const task = 8;
  static const section = 9;
  static const resourceFileType = 10;
  static const resourceProcessingStage = 11;
  static const resourceProperty = 12;
  static const resourceType = 13;
  static const sectionType = 14;
  static const fileDownload = 15;
  static const fileDownloadRequest = 16;
  static const fileDownloadRequestType = 17;
  static const favorite = 18;
  static const recentlyViewed = 19;
}

class UuidValueAdapter extends TypeAdapter<UuidValue> {
  @override
  final int typeId = HiveDataType.uuidValue;

  @override
  UuidValue read(BinaryReader reader) =>
      UuidValue.fromByteList(reader.readByteList());

  @override
  void write(BinaryWriter writer, UuidValue obj) {
    writer.writeByteList(obj.toBytes());
  }
}

class MyObserver extends AutoRouterObserver {
  final void Function(String?) onRouteDeckId;
  final void Function(String?) onRouteResourceId;

  MyObserver(this.onRouteDeckId, this.onRouteResourceId);

  @override
  void didPush(Route route, Route? previousRoute) {
    final args = route.settings.arguments;
    String? deckId;
    String? resourceId;
    if (args is DeckDetailRouteArgs) {
      deckId = args.deckId;
    } else if (args is ResourceViewRouteArgs) {
      deckId = args.deckId;
      resourceId = args.resourceId;
    }
    onRouteDeckId(deckId);
    onRouteResourceId(resourceId);
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    if (previousRoute == null) {
      onRouteDeckId(null);
    } else if (previousRoute.settings.name != DeckDetailRoute.name &&
        previousRoute.settings.name != ResourceViewRoute.name) {
      onRouteDeckId(null);
      onRouteResourceId(null);
    } else if (previousRoute.settings.name != ResourceViewRoute.name) {
      onRouteResourceId(null);
    }
  }
}
