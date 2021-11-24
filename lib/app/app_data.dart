import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

part 'app_data.g.dart';

/// List of data types in use for hive.
abstract class HiveDataType {
  static const appData = 0;
  static const user = 1;
  static const authSession = 2;
}

/// Holds app-wide saved data.
@HiveType(typeId: HiveDataType.appData)
@immutable
class AppData {
  @HiveField(0)
  final String? valString;

  const AppData({this.valString});
}

/// Holds the application static config (see assets/config.json)
@immutable
class AppInfo {
  final String os;
  final String appId;
  final String apiKey;
  final String apiSecret;
  const AppInfo._(this.os, this.appId, this.apiKey, this.apiSecret);
  factory AppInfo.fromJson(String os, Map<String, dynamic> jsonMap) {
    return AppInfo._(
        os, jsonMap["app_id"], jsonMap["api_key"], jsonMap["api_secret"]);
  }
}
