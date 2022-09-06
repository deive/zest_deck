import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import 'package:zest/app/app_provider.dart';
import 'package:zest/app/favorites/favorites_provider.dart';

part 'favorite.g.dart';

@HiveType(typeId: HiveDataType.favorite)
@immutable
class Favorite implements FavoriteItem {
  @override
  @HiveField(0)
  final UuidValue resourceId;
  @override
  @HiveField(1)
  final UuidValue companyId;
  @override
  @HiveField(2)
  final DateTime dateTime;
  @override
  @HiveField(3)
  final UuidValue? fromDeckId;

  const Favorite(
    this.resourceId,
    this.companyId,
    this.dateTime,
    this.fromDeckId,
  );

  @override
  int get hashCode => resourceId.hashCode ^ companyId.hashCode;

  @override
  bool operator ==(Object? other) =>
      identical(this, other) ||
      other is Favorite &&
          runtimeType == other.runtimeType &&
          resourceId == other.resourceId &&
          companyId == other.companyId;
}
