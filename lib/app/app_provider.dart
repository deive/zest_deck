import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
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
import 'package:zest/app/models/app_data.dart';
import 'package:zest/app/navigation/app_router.gr.dart';

/// App-level provider.
class AppProvider with ChangeNotifier {
  AppProvider() {
    _init();
  }

  final router = AppRouter();
  bool get initComplete => _initComplete;

  bool _initComplete = false;
  static const _appBox = 'app';
  late Box<AppData> _appData;

  DefaultRouteParser getRouteInformationParser() => router.defaultRouteParser();
  AutoRouterDelegate getRouterDelegate() => router.delegate();

  Future<void> putString(String key, String value) =>
      _appData.put(key, AppData(valString: value));
  String? getString(String key) => _appData.get(key)?.valString;
  Future<void> removeValue(String key) => _appData.delete(key);

  Future<void> _init() async {
    await Hive.initFlutter(await _getHiveDirectory());
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
    _appData = await Hive.openBox<AppData>(_appBox);
    _initComplete = true;
    notifyListeners();
  }

  Future<String> _getHiveDirectory() async {
    if (kIsWeb) return "zest";
    final supportDir = await getApplicationSupportDirectory();
    return supportDir.path;
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
  static const deckFileDownload = 15;
  static const downloadStatus = 16;
  static const deckDownload = 17;
  static const deckDownloadStatus = 18;
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
