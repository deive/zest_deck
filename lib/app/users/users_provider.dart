import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:zest_deck/app/api_provider.dart';
import 'package:zest_deck/app/app_provider.dart';
import 'package:zest_deck/app/models/api_request_response.dart';

class UsersProvider with ChangeNotifier {
  LoginCall? _loginCall;
  LoginCall? get loginCall => _loginCall;

  // AuthState get authState => _auth;
  // set _authState(AuthState val) {
  //   _auth = val;
  //   _app.userAuthenticated = val == AuthState.authorised;
  // }

  // User? get currentUser => _currentUser;
  // List<String>? get knownEmails => _knownEmails;

  // UsersData? _usersData;
  // static const _usersDataBox = 'users_data';
  // static const _usersDataBoxData = 'usersData';
  // static const _usersBox = 'users';

  late AppProvider _app;
  late APIProvider _api;

  // AuthState _auth = AuthState.loading;
  // User? _currentUser;
  List<String>? _knownEmails;
  bool _startedLoading = false;

  login(String username, String password, void Function() onLogin) async {
    if (_loginCall != null && _loginCall!.loading) {
      throw ConcurrentModificationError("Can only call login once at a time.");
    }
    _newLoginCall(username, password);
    try {
      await _api.post(_app.apiPath("auth"), null, _loginCall!);
      // TODO: Process response here :-)
      // final response = _loginCall?.response;
      // if (response != null) {
      //   _handleLoginResponse(server, email, response, onLogin);
      // }
    } on APIException catch (e) {
      if (e.response.statusCode == 403) {
        _loginCall!.onError(LoginIncorrectException());
      } else {
        _loginCall!.onError(e);
      }
    }
  }

  logout() async {
    // _currentUser = null;
    // _authState = AuthState.unauthorised;
    // notifyListeners();
    // final box = Hive.box<UsersData>(_usersDataBox);
    // box.delete(_usersDataBoxData);
  }

  init() async {
    // Hive.registerAdapter(AccountServerAdapter());
    // Hive.registerAdapter(UserAdapter());
    // Hive.registerAdapter(UserAccountAdapter());
    // Hive.registerAdapter(AuthSessionAdapter());
    // Hive.registerAdapter(UsersDataAdapter());
    // Hive.registerAdapter(TwoFAEnumAdapter());
    // notifyListeners();
  }

  UsersProvider onUpdate(AppProvider app, APIProvider api) {
    _app = app;
    _api = api;
    if (!_startedLoading && app.appInfo != null) {
      _startedLoading = true;
      // _load();
    } else {
      notifyListeners();
    }
    return this;
  }

  _newLoginCall(String username, String password) {
    _loginCall?.dispose();
    _loginCall = LoginCall(username, password);
    _loginCall!.addListener(() {
      notifyListeners();
    });
  }
}

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
