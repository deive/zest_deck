import 'package:flutter/foundation.dart';
import 'package:zest_deck/api/api_provider.dart';
import 'package:zest_deck/app/app_provider.dart';

class UsersProvider with ChangeNotifier {
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

  login(String email, String password, void Function() onLogin) async {}

  logout() async {
    // _currentUser = null;
    // _authState = AuthState.unauthorised;
    // notifyListeners();
    // final box = Hive.box<UsersData>(_usersDataBox);
    // box.delete(_usersDataBoxData);
  }

  load() async {
    // Hive.registerAdapter(AccountServerAdapter());
    // Hive.registerAdapter(UserAdapter());
    // Hive.registerAdapter(UserAccountAdapter());
    // Hive.registerAdapter(AuthSessionAdapter());
    // Hive.registerAdapter(UsersDataAdapter());
    // Hive.registerAdapter(TwoFAEnumAdapter());
    notifyListeners();
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
}
