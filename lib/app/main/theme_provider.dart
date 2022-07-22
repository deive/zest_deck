import 'package:flutter/widgets.dart';
import 'package:zest/app/main/main_provider.dart';

class ThemeProvider with ChangeNotifier {
  final bool _isDark;
  final MainProvider? _mainProvider;

  ThemeProvider(bool isDark, MainProvider? mainProvider)
      : _isDark = isDark,
        _mainProvider = mainProvider;

  Color get appBarColour =>
      _mainProvider?.currentlySelectedDeck?.headerColour ??
      const Color(0x00000000);

  Color get headerTextColour =>
      _mainProvider?.currentlySelectedDeck?.headerTextColour ??
      foregroundColour;

  Color get zestHighlightColour => const Color.fromARGB(255, 255, 87, 0);

  double get titleHeight => _mainProvider?.showNavigation == true ? 56.0 : 0.0;

  double get navWidth => _mainProvider?.showNavigation == true ? 76.0 : 0.0;

  double get navSelectedDeckMargin =>
      _mainProvider?.lastSelectedDeck != null ? 25.0 : 0.0;

  double get contentLeftPadding =>
      _mainProvider?.showNavigation == true ? 81.0 : 0.0;

  Color get foregroundColour => _isDark
      ? const Color.fromARGB(255, 255, 255, 255)
      : const Color.fromARGB(255, 0, 0, 0);

  Duration get fadeTransitionDuration => const Duration(milliseconds: 500);
  Duration get fastTransitionDuration => const Duration(milliseconds: 50);
}
