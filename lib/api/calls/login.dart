import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:zest/api/api_request_response.dart';

// A login call to the Zest API.
class LoginCall extends ZestCall {
  final String password;

  factory LoginCall(String username, String password) {
    final passBytes = utf8.encode("${password}bellboysprout");
    final passwordDigest = sha512.convert(passBytes);
    return LoginCall._(username, password, passwordDigest);
  }

  LoginCall._(String username, this.password, Digest passwordDigest)
      : super(ZestAPIRequestResponse(metadata: {
          "username": username,
          "password": passwordDigest.toString()
        }));

  String get username => request.metadata!["username"]!;
}

class LoginIncorrectException implements Exception {}
