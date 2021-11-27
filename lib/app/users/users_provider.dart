import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:zest_deck/app/api_provider.dart';
import 'package:zest_deck/app/app_provider.dart';
import 'package:zest_deck/app/api_request_response.dart';
import 'package:zest_deck/app/users/user.dart';

class UsersProvider with ChangeNotifier, AppAndAPIProvider {
  ZestAPIRequestResponse? get currentData => _currentData;
  LoginCall? get loginCall => _loginCall;

  ZestAPIRequestResponse? _currentData;
  LoginCall? _loginCall;

  List<String>? get knownEmails => _knownEmails;

  static const _usersBox = 'data';
  late Box<ZestAPIRequestResponse> _usersData;

  late List<String> _knownEmails;

  login(String username, String password, void Function() onLogin) async {
    if (_loginCall != null && _loginCall!.loading) {
      throw ConcurrentModificationError("Can only call login once at a time.");
    }
    _newLoginCall(username, password);
    try {
      await _api.post(_app.apiPath("auth"), null, _loginCall!);
      final response = _loginCall?.response;
      if (response != null) {
        _handleLoginResponse(response, onLogin);
      }
    } on APIException catch (e) {
      if (e.response.statusCode == 403) {
        _loginCall!.onError(LoginIncorrectException());
      } else {
        _loginCall!.onError(e);
      }
    }
  }

  logout() async {
    _currentData = null;
    _loginCall?.dispose();
    _loginCall = null;
    _updateKnownEmails();
    _app.currentUserId = null;
    notifyListeners();
  }

  init() async {
    Hive.registerAdapter(UserAdapter());
  }

  UsersProvider onUpdate(AppProvider app, APIProvider api) {
    _onUpdate(app, api);
    return this;
  }

  @override
  _load() async {
    _usersData = await Hive.openBox<ZestAPIRequestResponse>(_usersBox);
    if (_app.currentUserId != null) {
      _currentData = _usersData.get(_app.currentUserId);
    }
    _updateKnownEmails();
  }

  _handleLoginResponse(
      ZestAPIRequestResponse response, void Function() onLogin) {
    if (response.user?.email != null) {
      if (_currentData?.user?.email == response.user!.email!) {
        // Current user re-logging in
        _currentData = _currentData!.copyUpdate(response);
      } else {
        // New login
        _currentData = response;
        _app.currentUserId = response.user!.id.toString();
      }
      _usersData.put(response.user!.id.toString(), response);
      onLogin();
    }
  }

  _newLoginCall(String username, String password) {
    _loginCall?.dispose();
    _loginCall = LoginCall(username, password);
    _loginCall!.addListener(() {
      notifyListeners();
    });
  }

  _updateKnownEmails() {
    _knownEmails = _usersData.values
        .where((e) => e.user?.email != null)
        .map((e) => e.user!.email!)
        .toList();
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

mixin AppAndAPIProvider {
  late AppProvider _app;
  late APIProvider _api;
  bool _startedLoading = false;

  _onUpdate(AppProvider app, APIProvider api) {
    _app = app;
    _api = api;
    if (!_startedLoading && app.appInfo != null) {
      _startedLoading = true;
      _load();
    }
  }

  _load();
}
