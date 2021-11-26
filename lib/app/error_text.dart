import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:zest_deck/app/theme_provider.dart';

/// Text with the error text theme style applied.
class ErrorText extends PlatformWidget {
  final String text;

  ErrorText(
    this.text, {
    Key? key,
  }) : super(key: key);

  @override
  Widget createMaterialWidget(BuildContext context) {
    var t = Theme.of(context);
    var style = ThemeProvider.materialTextThemeError(t.brightness);
    return Text(
      text,
      style: style,
    );
  }

  @override
  Widget createCupertinoWidget(BuildContext context) {
    var style = ThemeProvider.cupertinoTextThemeError(context);
    return Text(
      text,
      style: style,
    );
  }
}
