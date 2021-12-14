import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'app_data.g.dart';

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
  final String apiHost;
  final String apiPath;
  final String fileStoreHost;
  const AppInfo._(
      this.os, this.appId, this.apiHost, this.apiPath, this.fileStoreHost);
  factory AppInfo.fromJson(String os, Map<String, dynamic> jsonMap) {
    return AppInfo._(os, jsonMap["app_id"], jsonMap["api_host"],
        jsonMap["api_path"], jsonMap["file_store_host"]);
  }
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
