import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:zest/app/app_provider.dart';

part 'app_data.g.dart';

/// Holds app-wide saved data.
@HiveType(typeId: HiveDataType.appData)
@immutable
class AppData {
  @HiveField(0)
  final String? valString;

  const AppData({this.valString});
}