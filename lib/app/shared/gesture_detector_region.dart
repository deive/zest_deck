import 'package:flutter/widgets.dart';

class GestureDetectorRegion extends StatelessWidget {
  const GestureDetectorRegion({
    Key? key,
    required this.onTap,
    required this.child,
  }) : super(key: key);

  final Widget child;
  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) => MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: child,
      ));
}
