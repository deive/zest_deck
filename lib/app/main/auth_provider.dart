import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:zest/api/api_provider.dart';
import 'package:zest/api/api_request_response.dart';
import 'package:zest/api/calls/login.dart';
import 'package:zest/api/models/user.dart';
import 'package:zest/app/app_provider.dart';

class AuthProvider with ChangeNotifier {
  AuthProvider(this._api, this._app) {
    _init();
  }

  bool get initComplete => _initComplete;
  bool get showLoginDialog => _loginRequested || _reloginRequested;
  bool get loginRequested => _loginRequested;
  bool get reloginRequested => _reloginRequested;
  LoginCall? get loginCall => _loginCall;
  bool get isLoggingIn => _loginCall?.loading == true;
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
  ZestAPIRequestResponse? _loginData;
  static const _authBox = 'auth';
  late Box<ZestAPIRequestResponse> _authData;

  login(LoginCall call) async {
    _newLoginCall(call);
    try {
      await _api.post(_api.apiPath("auth"), null, _loginCall!);
      final response = _loginCall?.response;
      if (response != null) {
        _handleLoginResponse(response);
      }
    } on APIException catch (e) {
      if (e.response.statusCode == 401) {
        _loginCall!.onError(LoginIncorrectException());
      } else {
        _loginCall!.onError(e);
      }
    }
  }

  _handleLoginResponse(ZestAPIRequestResponse response) {
    if (response.user?.email != null) {
      if (_loginData?.user?.email == response.user!.email!) {
        // Current user re-logging in
        _loginData = _loginData!.copyUpdate(response);
      } else {
        // New login
        _loginData = response;
      }
      final userId = response.user!.id.toString();
      _authData.put(userId, response);
      _app.putString("currentUserId", userId);
      _loginRequested = false;
      notifyListeners();
    }
  }

  _newLoginCall(LoginCall call) {
    _loginCall?.dispose();
    _loginCall = call;
    _loginCall!.addListener(() {
      notifyListeners();
    });
  }

  _init() async {
    _authData = await Hive.openBox<ZestAPIRequestResponse>(_authBox);
    final lastUserId = _app.getString("currentUserId");
    if (lastUserId != null) {
      _loginData = _authData.get(lastUserId);
    }
    if (_loginData == null) {
      _loginRequested = true;
    }
    _initComplete = true;
    notifyListeners();
  }
}
