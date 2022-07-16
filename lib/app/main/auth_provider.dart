import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
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

  bool get initComplete => _initComplete;
  bool get showLoginDialog => _loginRequested || _reloginRequested;
  bool get loginRequested => _loginRequested;
  bool get reloginRequested => _reloginRequested;
  LoginCall? get loginCall => _loginCall;
  bool get isLoggingIn =>
      _loginCall?.started == true && _loginCall?.completed == false;
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

  String? get _lastUserId => _app.getString("currentUserId");
  ZestAPIRequestResponse? get _loginData => _authData.get(_lastUserId);

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
    if (_lastUserId == null || _loginData == null) {
      _loginRequested = true;
    }
    _initComplete = true;
    notifyListeners();
  }
}
