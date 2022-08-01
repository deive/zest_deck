import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:zest/app/main/main_provider.dart';

class ThemeProvider with ChangeNotifier {
  final bool _isDark;
  final MainProvider? _mainProvider;

  ThemeProvider(this._isDark, this._mainProvider);

  Color get appBarColour =>
      _mainProvider?.currentlySelectedDeck?.headerColour ??
      const Color.fromARGB(0, 0, 0, 0);

  Color get headerTextColour =>
      _mainProvider?.currentlySelectedDeck?.headerTextColour ??
      foregroundColour;

  Color get zestHighlightColour => const Color.fromARGB(255, 255, 87, 0);

  double get titleHeight => _mainProvider?.showNavigation == true ? 56.0 : 0.0;

  double get navWidth => _mainProvider?.showNavigation == true ? 76.0 : 0.0;

  double get scrollbarSize => 15;

  double get contentLeftPadding =>
      _mainProvider?.showNavigation == true ? 81.0 : 0.0;

  double get contentTopPadding =>
      _mainProvider?.showNavigation == true ? 61.0 : 0.0;

  bool get showScrollbar =>
      kIsWeb || Platform.isLinux || Platform.isMacOS || Platform.isWindows;

  double get contentScrollbarPadding => showScrollbar ? 20.0 : 0.0;

  Color get foregroundColour => _isDark
      ? const Color.fromARGB(255, 255, 255, 255)
      : const Color.fromARGB(255, 0, 0, 0);

  Color get backgroundColour => _isDark
      ? const Color.fromARGB(255, 0, 0, 0)
      : const Color.fromARGB(255, 255, 255, 255);

  Duration get fadeTransitionDuration => const Duration(milliseconds: 500);
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
  Color get deckIconBackgroundColour => _isDark
      ? const Color.fromARGB(255, 192, 192, 192)
      : const Color.fromARGB(255, 0, 0, 0);

// TODO: Light colour
  Color get deckDetailsBackgroundColour => _isDark
      ? const Color.fromARGB(255, 92, 92, 92)
      : const Color.fromARGB(255, 0, 0, 0);
}
