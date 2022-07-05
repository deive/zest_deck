import 'package:flutter/foundation.dart';
import 'package:zest/api/calls/login.dart';

class AuthProvider with ChangeNotifier {
  bool get showLoginDialog => _loginRequested || _reloginRequested;
  bool get loginRequested => _loginRequested;
  bool get reloginRequested => _reloginRequested;
  LoginCall? get loginCall => _loginCall;
  bool get isLoggingIn => _loginCall?.loading == true;
  // User? get user => _user;

  bool _loginRequested = true;
  bool _reloginRequested = false;
  LoginCall? _loginCall;
  // User? _user;

  login(LoginCall call) async {
    _loginCall = call;
    call.loading = true;
    notifyListeners();
    Future.delayed(const Duration(seconds: 1));
    call.loading = false;
    notifyListeners();
  }
}
