import 'package:hive_flutter/hive_flutter.dart';
import 'package:zest_deck/app/app_data.dart';

part 'session.g.dart';

enum AuthState { loading, unauthorised, loggingIn, authorised }

@HiveType(typeId: HiveDataType.authSession)
class AuthSession {
  @HiveField(0)
  final String accessToken;
  @HiveField(1)
  final int expiresOn;
  @HiveField(2)
  final String refreshToken;

  AuthSession(this.accessToken, this.expiresOn, this.refreshToken);

  isExpired() => DateTime.now().millisecondsSinceEpoch / 1000 >= expiresOn;

  @override
  int get hashCode => accessToken.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthSession &&
          runtimeType == other.runtimeType &&
          accessToken == other.accessToken;
}

class LoginIncorrectException implements Exception {}
