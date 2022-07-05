import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import 'package:zest/api/calls/login.dart';
import 'package:zest/api/models/deck.dart';
import 'package:zest/api/models/user.dart';
import 'package:zest/app/app_provider.dart';
import 'package:zest/app/navigation/app_router.gr.dart';

/// Main provider.
class MainProvider with ChangeNotifier {
  MainProvider(AppProvider appProvider, AuthProvider? authProvider)
      : _appProvider = appProvider,
        _authProvider = authProvider;

  final AppProvider _appProvider;
  final AuthProvider? _authProvider;

  bool get showNavigation => _showNavigation;
  Deck? get currentlySelectedDeck => _currentlySelectedDeck;
  Deck? get lastSelectedDeck => _lastSelectedDeck;

  Deck? _currentlySelectedDeck;
  Deck? _lastSelectedDeck;
  bool _showNavigation = true;

  void navigateTo(MainNavigation dest) async {
    switch (dest) {
      case MainNavigation.decks:
        _appProvider.router.replace(const DeckListRoute());
        break;
      case MainNavigation.favorites:
        _appProvider.router.replace(const FavoritesRoute());
        break;
      case MainNavigation.selectedDeck:
        if (_currentlySelectedDeck != null) {
          _appProvider.router.replace(
              DeckDetailRoute(deckId: _currentlySelectedDeck!.id.toString()));
        }
        break;
      case MainNavigation.settings:
        _appProvider.router.replace(const SettingsRoute());
        break;
    }
  }
}

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

class ThemeProvider with ChangeNotifier {
  final bool _isDark;
  final MainProvider? _mainProvider;

  ThemeProvider(bool isDark, MainProvider? mainProvider)
      : _isDark = isDark,
        _mainProvider = mainProvider;

  Color get appBarColour =>
      _mainProvider?._currentlySelectedDeck?.headerColour ??
      const Color(0x00000000);

  Color get headerTextColour =>
      _mainProvider?._currentlySelectedDeck?.headerTextColour ??
      _foregroundColour;

  Color get zestHighlightColour => const Color.fromARGB(255, 255, 87, 0);

  double get titleHeight => _mainProvider?.showNavigation == true ? 56.0 : 0.0;

  double get navWidth => _mainProvider?.showNavigation == true ? 76.0 : 0.0;

  double get navSelectedDeckMargin =>
      _mainProvider?.lastSelectedDeck != null ? 25.0 : 0.0;

  double get contentLeftPadding =>
      _mainProvider?.showNavigation == true ? 81.0 : 0.0;

  Color get _foregroundColour => _isDark
      ? const Color.fromARGB(255, 255, 255, 255)
      : const Color.fromARGB(255, 0, 0, 0);
}

enum MainNavigation { decks, favorites, selectedDeck, settings }

/// List of data types in use for hive.
abstract class HiveDataType {
  static const uuidValue = 1;
  static const response = 2;
  static const user = 3;
  static const company = 4;
  static const deck = 5;
  static const resource = 6;
  static const resourceFile = 7;
  static const task = 8;
  static const section = 9;
  static const resourceFileType = 10;
  static const resourceProcessingStage = 11;
  static const resourceProperty = 12;
  static const resourceType = 13;
  static const sectionType = 14;
  static const deckFileDownload = 15;
  static const downloadStatus = 16;
  static const deckDownload = 17;
  static const deckDownloadStatus = 18;
}

class UuidValueAdapter extends TypeAdapter<UuidValue> {
  @override
  final int typeId = HiveDataType.uuidValue;

  @override
  UuidValue read(BinaryReader reader) =>
      UuidValue.fromByteList(reader.readByteList());

  @override
  void write(BinaryWriter writer, UuidValue obj) {
    writer.writeByteList(obj.toBytes());
  }
}
