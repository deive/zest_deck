import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:zest_deck/app/api/api_provider.dart';
import 'package:zest_deck/app/app_provider.dart';
import 'package:zest_deck/app/api/api_request_response.dart';
import 'package:zest_deck/app/users/user.dart';

class UsersProvider with ChangeNotifier, AppAndAPIProvider {
  User? get currentUser => _currentData?.user;
  ZestAPIRequestResponse? get currentData => _currentData;
  LoginCall? get loginCall => _loginCall;

  ZestAPIRequestResponse? _currentData;
  LoginCall? _loginCall;

  List<String>? get knownEmails => _knownEmails;

  static const _usersBox = 'data';
  late Box<ZestAPIRequestResponse> _usersData;

  late List<String> _knownEmails;

  bool canReLogin() {
    if (_currentData?.user?.email != null) {
      _loginCall?.dispose();
      _loginCall = null;
      return true;
    }
    return false;
  }

  reLogin(String password, void Function() onLogin) async {
    if (canReLogin()) {
      login(_currentData!.user!.email!, password, onLogin);
    }
  }

  login(String username, String password, void Function() onLogin) async {
    if (_loginCall != null && _loginCall!.loading) {
      throw ConcurrentModificationError("Can only call login once at a time.");
    }
    _newLoginCall(username, password);
    try {
      await api.post(app.apiPath("auth"), null, _loginCall!);
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

  bool updateCurrentData(ZestAPIRequestResponse response, {bool save = true}) {
    if (response.user?.email != null &&
        _currentData?.user?.email == response.user!.email!) {
      _currentData = _currentData!.copyUpdate(response);
      if (save) {
        _usersData.put(response.user!.id.toString(), _currentData!);
      }
      return true;
    }
    return false;
  }

  onAPI403() async {
    if (kIsWeb) {
      logout();
    } else if (_currentData != null &&
        _currentData!.user != null &&
        _currentData!.authToken != null) {
      _currentData = _currentData!.withoutAuth();
      _usersData.put(_currentData!.user!.id.toString(), _currentData!);
    }
  }

  logout() async {
    _currentData = null;
    _loginCall?.dispose();
    _loginCall = null;
    _updateKnownEmails();
    app.currentUserId = null;
    notifyListeners();
    app.resetNavigation();
  }

  init() async {
    Hive.registerAdapter(UserAdapter());
  }

  UsersProvider onUpdate(AppProvider app, APIProvider api) {
    onAppProviderUpdate(app, api);
    return this;
  }

  @override
  load() async {
    _usersData = await Hive.openBox<ZestAPIRequestResponse>(_usersBox);
    _updateKnownEmails();
    notifyListeners();
  }

  @override
  void onLogin() {
    if (app.currentUserId != null) {
      _currentData = _usersData.get(app.currentUserId);
      notifyListeners();
    }
  }

  @override
  void onLogout() {
    _updateKnownEmails();
    notifyListeners();
  }

  _handleLoginResponse(
      ZestAPIRequestResponse response, void Function() onLogin) {
    if (response.user?.email != null) {
      if (_currentData?.user?.email == response.user!.email!) {
        // Current user re-logging in
        updateCurrentData(response, save: false);
      } else {
        // New login
        _currentData = response;
        app.currentUserId = response.user!.id.toString();
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
        .toSet()
        .toList();
  }
}

mixin UsersAndAPIProvider on AppAndAPIProvider {
  @protected
  UsersProvider get user => _user;
  @protected
  String? get currentAuthToken => user.currentData?.authToken;

  late UsersProvider _user;

  String? _lastAuthToken;

  @protected
  void onUserProviderUpdate(
      AppProvider app, APIProvider api, UsersProvider user) {
    _user = user;
    onAppProviderUpdate(app, api);
    if (loaded) {
      if (_lastAuthToken == null && currentAuthToken != null) {
        _lastAuthToken = currentAuthToken;
        onRecievedAuthToken();
      } else if (_lastAuthToken != null && currentAuthToken == null) {
        _lastAuthToken = null;
        onLostAuthToken();
      } else if (_lastAuthToken != currentAuthToken) {
        _lastAuthToken = currentAuthToken;
        onRecievedAuthToken();
      }
    }
  }

  /// Called every time the logged in user has a new auth token.
  @protected
  void onRecievedAuthToken() {}

  /// Called every time the logged user's auth token is emptied/expired.
  @protected
  void onLostAuthToken() {}
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
