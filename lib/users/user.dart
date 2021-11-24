import 'package:hive/hive.dart';
import 'package:zest_deck/app/app_data.dart';

part 'user.g.dart';

@HiveType(typeId: HiveDataType.user)
class User {
  @HiveField(0)
  final String email;

  User(this.email);

  @override
  int get hashCode => email.hashCode;

  @override
  bool operator ==(Object? other) =>
      identical(this, other) ||
      other is User && runtimeType == other.runtimeType && email == other.email;
}
