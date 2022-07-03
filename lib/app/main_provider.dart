import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import 'package:zest/api/calls/login.dart';
import 'package:zest/api/models/deck.dart';
import 'package:zest/api/models/user.dart';
import 'package:zest/app/app.gr.dart';
import 'package:zest/app/app_provider.dart';

/// Main provider.
class MainProvider with ChangeNotifier {
  MainProvider(this.appProvider);

  final AppProvider appProvider;

  LoginCall? get loginCall => _loginCall;
  User? get user => _user;
  bool get reloginRequested => _reloginRequested;

  bool get showNavigation => _showNavigation;
  Deck? get currentlySelectedDeck => _currentlySelectedDeck;
  Deck? get lastSelectedDeck => _lastSelectedDeck;

  bool get isLoggingIn => _user == null && _loginCall != null;
  bool get isLoggedIn => _user != null && _loginCall == null;
  bool get isReloggingIn =>
      _user != null && _reloginRequested && _loginCall != null;

  LoginCall? _loginCall;
  User? _user;
  bool _reloginRequested = false;
  bool _showNavigation = true;
  Deck? _currentlySelectedDeck;
  Deck? _lastSelectedDeck;

  Color getAppBarColour() =>
      _currentlySelectedDeck?.headerColour ?? const Color(0x00000000);

  Color getHeaderTextColour(BuildContext context) {
    final brightness = MediaQuery.of(context).platformBrightness;
    final defaultColour = brightness == Brightness.dark
        ? const Color.fromARGB(255, 255, 255, 255)
        : const Color.fromARGB(255, 0, 0, 0);
    return _currentlySelectedDeck?.headerTextColour ?? defaultColour;
  }

  void navigateTo(MainNavigation dest) async {
    switch (dest) {
      case MainNavigation.decks:
        appProvider.router.replace(const DeckListRoute());
        break;
      case MainNavigation.favorites:
        appProvider.router.replace(const FavoritesRoute());
        break;
      case MainNavigation.selectedDeck:
        if (_currentlySelectedDeck != null) {
          appProvider.router.replace(
              DeckDetailRoute(deckId: _currentlySelectedDeck!.id.toString()));
        }
        break;
      case MainNavigation.settings:
        appProvider.router.replace(const SettingsRoute());
        break;
    }
  }
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
