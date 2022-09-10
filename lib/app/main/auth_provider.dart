import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:universal_html/html.dart';
import 'package:uuid/uuid.dart';
import 'package:zest/api/api_provider.dart';
import 'package:zest/api/api_request_response.dart';
import 'package:zest/api/calls/login.dart';
import 'package:zest/api/models/user.dart';
import 'package:zest/app/app_provider.dart';
import 'package:zest/app/navigation/app_router.gr.dart';

class AuthProvider with ChangeNotifier {
  AuthProvider(this._api, this._app) {
    _init();
  }

  String? get currentUserId => _currentUserId;
  String get currentEmail => loginCall?.username ?? user?.email ?? "";
  ZestAPIRequestResponse? get loginData => _loginData;
  bool get initComplete => _initComplete;
  bool get showLoginDialog => _loginRequested || _reloginRequested;
  bool get loginRequested => _loginRequested;
  bool get reloginRequested => _reloginRequested;
  LoginCall? get loginCall => _loginCall;
  bool get isLoggingIn => _loginCall?.running ?? false;
  bool get canLogin =>
      (_loginRequested || _reloginRequested) &&
      (_loginCall == null || !_loginCall!.started || _loginCall!.error != null);
  User? get user => _loginData?.user;
  List<String> get knownEmails => _authData.values
      .where((e) => e.user?.email != null)
      .map((e) => e.user!.email!)
      .toSet()
      .toList();

  final APIProvider _api;
  final AppProvider _app;
  bool _initComplete = false;
  bool _loginRequested = false;
  bool _reloginRequested = false;

  LoginCall? _loginCall;
  static const _authBox = 'auth';
  late Box<ZestAPIRequestResponse> _authData;

  String? get _currentUserId => _app.getString("currentUserId");
  ZestAPIRequestResponse? get _loginData {
    final currentUserId = _currentUserId;
    if (currentUserId == null) return null;
    return _authData.get(currentUserId);
  }

  // TODO: More client side checking of token
  bool get isCurrentUserAPISessionValid => _loginData?.authToken != null;

  Future<void> login(LoginCall call) async {
    _newLoginCall(call);
    try {
      await _api.post(_api.apiPath("auth"), null, _loginCall!);
      final response = _loginCall?.response;
      _handleLoginResponse(response!);
    } on APIException catch (e) {
      if (e.response.statusCode == 401) {
        _loginCall!.onError(LoginIncorrectException());
      } else {
        _loginCall!.onError(e);
      }
    } on Exception catch (e) {
      _loginCall!.onError(e);
    }
  }

  Future<void> logout() async {
    await _app.removeValue("currentUserId");
    _app.router.replaceAll([const DeckListRoute()]);
    _loginRequested = true;
    notifyListeners();
  }

  Future<void> requestRelogin() async {
    if (!_reloginRequested) {
      _reloginRequested = true;
      notifyListeners();
    }
  }

  Future<void> cancelRelogin() async {
    if (_reloginRequested) {
      _reloginRequested = false;
      notifyListeners();
    }
  }

  Future<void> onAPI403() async {
    if (kIsWeb) {
      logout();
    } else if (_loginData != null &&
        _loginData!.user != null &&
        _loginData!.authToken != null) {
      final newData = _loginData!.withoutAuth();
      _authData.put(newData.user!.id.toString(), newData);
      notifyListeners();
    }
  }

  Future<String?> getDataDirectory() async => currentUserId == null
      ? null
      : "${await _app.getHiveDirectory()}/$currentUserId";

  Future<void> _handleLoginResponse(ZestAPIRequestResponse response) async {
    if (response.user?.email != null) {
      final userId = response.user!.id.toString();
      await _authData.put(userId, response);
      await _app.putString("currentUserId", userId);
      _loginRequested = false;
      _reloginRequested = false;
      _loginCall?.dispose();
      _loginCall = null;
      notifyListeners();
    }
  }

  void _newLoginCall(LoginCall call) {
    _loginCall?.dispose();
    _loginCall = call;
    _loginCall!.addListener(() {
      notifyListeners();
    });
  }

  Future<void> _init() async {
    _authData = await Hive.openBox<ZestAPIRequestResponse>(_authBox);
    if (_currentUserId == null || _loginData == null) {
      _loginRequested = true;
    }
    await _checkLoginCookie();
    _initComplete = true;
    notifyListeners();
  }

  Future<void> _checkLoginCookie() async {
    if (_loginRequested && kIsWeb) {
      try {
        if (window.navigator.userAgent.toLowerCase().contains("chrome") ||
            window.navigator.userAgent.toLowerCase().contains("edge")) {
          final cookieList =
              (await window.cookieStore?.getAll({"name": "AuthToken"})) as List;
          if (cookieList.isNotEmpty) {
            final cookie = cookieList.first;
            if (cookie.value != null && cookie.value is String) {
              final authToken = cookie.value as String;
              if (authToken.isNotEmpty) {
                final id = const Uuid().v4obj();
                final userId = id.toString();
                await _app.putString("currentUserId", userId);
                final response =
                    ZestAPIRequestResponse.fromWeb(id, cookie.value);
                await _authData.put(userId, response);
                _loginRequested = false;
              }
            }
          }
        }
      } finally {}
    }
  }
}
