import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// Puts child in a SafeArea if running on Android or iOS.
class WrapInSafeAreaIfRequired extends StatelessWidget {
  const WrapInSafeAreaIfRequired({
    Key? key,
    this.left = true,
    this.top = true,
    this.right = true,
    this.bottom = true,
    this.minimum = EdgeInsets.zero,
    this.maintainBottomViewPadding = false,
    required this.child,
  }) : super(key: key);

  final bool left;
  final bool top;
  final bool right;
  final bool bottom;
  final EdgeInsets minimum;
  final bool maintainBottomViewPadding;
  final Widget child;

  @override
  Widget build(BuildContext context) =>
      (!kIsWeb && (Platform.isAndroid || Platform.isIOS))
          ? SafeArea(
              left: left,
              top: top,
              right: right,
              bottom: bottom,
              minimum: minimum,
              maintainBottomViewPadding: maintainBottomViewPadding,
              child: child,
            )
          : child;
}
