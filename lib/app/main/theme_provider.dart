import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:zest/app/main/main_provider.dart';

class ThemeProvider with ChangeNotifier {
  final MainProvider? _mainProvider;

  ThemeProvider(this._mainProvider);

  bool get isMobile => !kIsWeb && (Platform.isAndroid || Platform.isIOS);

  Color get appBarColour =>
      _mainProvider?.lastSelectedDeck?.headerColour ??
      const Color.fromARGB(0, 0, 0, 0);

  Color get headerTextColour =>
      _mainProvider?.lastSelectedDeck?.headerTextColour ?? foregroundColour;

  Color get zestHighlightColour => const Color.fromARGB(255, 255, 87, 0);

  double get titleHeight => _mainProvider?.showTitle == true ? 56.0 : 0.0;

  double get navWidth => _mainProvider?.showNavigation == true ? 76.0 : 0.0;

  double get scrollbarSize => 15;

  double get contentLeftPadding =>
      _mainProvider?.showNavigation == true ? 81.0 : 10.0;

  double get contentTopPadding => _mainProvider?.showTitle == true ? 61.0 : 0.0;

  bool get showScrollbar =>
      kIsWeb || Platform.isLinux || Platform.isMacOS || Platform.isWindows;

  double get contentScrollbarPadding => showScrollbar ? 20.0 : 0.0;

  Color get foregroundColour => const Color.fromARGB(255, 255, 255, 255);

  Color get backgroundColour => const Color.fromARGB(255, 0, 0, 0);

  Duration get fadeTransitionDuration => const Duration(milliseconds: 500);
  Duration get navBarShowHideDuration => const Duration(milliseconds: 250);
  Duration get fastTransitionDuration => const Duration(milliseconds: 50);

  EdgeInsets get contentInsets => EdgeInsets.fromLTRB(
        contentLeftPadding,
        contentTopPadding,
        10,
        5,
      );

  EdgeInsets get listItemInsets =>
      const EdgeInsets.symmetric(horizontal: 10, vertical: 5);

// TODO: Light colour
  Color get deckIconBackgroundColour =>
      const Color.fromARGB(255, 192, 192, 192);

// TODO: Light colour
  Color get deckDetailsBackgroundColour =>
      const Color.fromARGB(255, 92, 92, 92);
}
