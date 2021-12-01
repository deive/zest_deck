import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart' as c;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

// TODO: Use as provider instead of const.
class ThemeProvider {
  createThemeForMaterial() => MaterialAppRouterData(
      theme: _themeMaterialData(!hasDarkTheme),
      darkTheme: _themeMaterialData(true),
      themeMode: ThemeMode.system);
  createThemeForCupertino() => CupertinoAppRouterData(
        theme: _cupertinoThemeData(),
      );

  static bool isCupertino = !kIsWeb && (Platform.isIOS || Platform.isMacOS);
  static bool isDesktop =
      !kIsWeb && (Platform.isLinux || Platform.isMacOS || Platform.isWindows);
  static bool hasDarkTheme = !kIsWeb;

  static const EdgeInsets screenEdgeInsets =
      EdgeInsets.symmetric(horizontal: _sizeSmall, vertical: _sizeMedium);
  static const EdgeInsets listItemInsets =
      EdgeInsets.symmetric(horizontal: _sizeSmall, vertical: _sizeSmaller);
  static const double contactIconSize = 48;
  static const double formMargin = _sizeSmall;

  static const zestyOrange = Color.fromARGB(255, 255, 149, 0);

  static const Color _lightThemePrimaryColor = Color.fromARGB(255, 48, 65, 203);
  static const Color _lightThemeAccentColor = Color.fromARGB(255, 68, 106, 233);
  static const Color _lightThemeSecondaryColor =
      Color.fromARGB(255, 97, 97, 97);
  static const Color _lightThemeSecondaryAccentColor =
      Color.fromARGB(255, 241, 241, 241);
  static const Color _lightThemeTextColor = Color.fromARGB(255, 0, 0, 0);
  static const Color _lightThemeTextErrorColor = Color.fromARGB(255, 175, 0, 0);

  static const Color _darkThemePrimaryColor = Color.fromARGB(255, 68, 106, 233);
  static const Color _darkThemeAccentColor = Color.fromARGB(255, 35, 46, 140);
  static const Color _darkThemeSecondaryColor =
      Color.fromARGB(255, 159, 159, 159);
  static const Color _darkThemeSecondaryAccentColor =
      Color.fromARGB(255, 112, 112, 112);
  static const Color _darkThemeTextColor = Color.fromARGB(255, 255, 255, 255);
  static const Color _darkThemeTextErrorColor = Color.fromARGB(255, 255, 0, 0);

  static const double _sizeSmaller = 5;
  static const double _sizeSmall = 10;
  static const double _sizeMedium = 20;
  static const double _sizeLarge = 25;

  static ThemeData _themeMaterialData(bool dark) {
    if (dark) {
      return ThemeData(
        brightness: Brightness.dark,
        colorScheme: const ColorScheme.dark(
          primary: _darkThemePrimaryColor,
          primaryVariant: _darkThemeAccentColor,
          secondary: _darkThemeSecondaryColor,
          secondaryVariant: _darkThemeSecondaryAccentColor,
        ),
        textTheme:
            _textThemeMaterialData(_darkThemeTextColor, _darkThemePrimaryColor),
        // sliderTheme: SliderThemeData(activeTrackColor: _darkThemePrimaryColor,
        //     thumbColor: _darkThemePrimaryColor,
        //     inactiveTrackColor: _darkThemeAccentColor),
        // checkboxTheme: CheckboxThemeData(
        //     fillColor: MaterialStateProperty.resolveWith((
        //         states) => _darkThemePrimaryColor)),
      );
    } else {
      return ThemeData(
        brightness: Brightness.light,
        colorScheme: const ColorScheme.light(
          primary: _lightThemePrimaryColor,
          primaryVariant: _lightThemeAccentColor,
          secondary: _lightThemeSecondaryColor,
          secondaryVariant: _lightThemeSecondaryAccentColor,
        ),
        textTheme: _textThemeMaterialData(
            _lightThemeTextColor, _lightThemePrimaryColor),
        // sliderTheme: SliderThemeData(activeTrackColor: _lightThemePrimaryColor,
        //     thumbColor: _lightThemePrimaryColor,
        //     inactiveTrackColor: _lightThemeAccentColor),
        // checkboxTheme: CheckboxThemeData(
        //     fillColor: MaterialStateProperty.resolveWith((
        //         states) => _lightThemePrimaryColor)),
      );
    }
  }

  static c.CupertinoThemeData _cupertinoThemeData() =>
      const c.CupertinoThemeData(
        primaryColor: c.CupertinoDynamicColor.withBrightness(
            color: _lightThemePrimaryColor, darkColor: _darkThemePrimaryColor),
        primaryContrastingColor: c.CupertinoDynamicColor.withBrightness(
            color: _lightThemeAccentColor, darkColor: _darkThemeAccentColor),
      );

  // Material text themes
  static materialTextThemeError(Brightness? brightness) {
    var c = _lightThemeTextErrorColor;
    if (brightness != Brightness.light) c = _darkThemeTextErrorColor;
    return _textThemeError(c);
  }

  static _textThemeMaterialData(Color textColor, Color themePrimaryColor) =>
      TextTheme(
        headline1: TextStyle(
            color: textColor, fontSize: 30.0, fontWeight: FontWeight.bold),
        headline2: TextStyle(
          color: textColor,
          fontSize: 20.0,
        ),
        headline3: TextStyle(
          color: themePrimaryColor,
          fontSize: 16.0,
        ),
      );

  static _textThemeError(Color themeErrorColor) => TextStyle(
        color: themeErrorColor,
      );

  // Cupertino text themes
  static const _cupertinoTextColour = c.CupertinoDynamicColor.withBrightness(
      color: _lightThemeTextColor, darkColor: _darkThemeTextColor);
  static const _cupertinoTextPrimaryColour =
      c.CupertinoDynamicColor.withBrightness(
          color: _lightThemePrimaryColor, darkColor: _darkThemePrimaryColor);
  static const _cupertinoTextSecondaryColour =
      c.CupertinoDynamicColor.withBrightness(
          color: _lightThemeSecondaryAccentColor,
          darkColor: _darkThemeSecondaryAccentColor);
  static const cupertinoBackgroundSecondaryColour =
      c.CupertinoDynamicColor.withBrightness(
          color: _lightThemeSecondaryColor,
          darkColor: _darkThemeSecondaryColor);
  static const _cupertinoTextErrorColour =
      c.CupertinoDynamicColor.withBrightness(
          color: _lightThemeTextErrorColor,
          darkColor: _darkThemeTextErrorColor);

  static c.TextStyle cupertinoTextThemeHeadline1(BuildContext context) =>
      c.TextStyle(
          color: c.CupertinoDynamicColor.resolve(_cupertinoTextColour, context),
          fontSize: 30.0,
          fontWeight: FontWeight.bold);

  static c.TextStyle cupertinoTextThemeHeadline2(BuildContext context) =>
      c.TextStyle(
        color: c.CupertinoDynamicColor.resolve(_cupertinoTextColour, context),
        fontSize: 20.0,
      );

  static c.TextStyle cupertinoTextThemeHeadline3(BuildContext context) =>
      c.TextStyle(
        color: c.CupertinoDynamicColor.resolve(
            _cupertinoTextPrimaryColour, context),
        fontSize: 16.0,
      );

  static c.TextStyle cupertinoTextThemeSecondary(BuildContext context) =>
      c.TextStyle(
        color: c.CupertinoDynamicColor.resolve(
            _cupertinoTextSecondaryColour, context),
      );

  static c.TextStyle cupertinoTextThemeError(BuildContext context) =>
      c.TextStyle(
        color:
            c.CupertinoDynamicColor.resolve(_cupertinoTextErrorColour, context),
      );
}
