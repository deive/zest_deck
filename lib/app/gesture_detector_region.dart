import 'package:flutter/widgets.dart';

class GestureDetectorRegion extends StatelessWidget {
  const GestureDetectorRegion(
      {Key? key, required this.child, required this.onTap})
      : super(key: key);
  final Widget child;
  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) => MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: child,
      ));
}
