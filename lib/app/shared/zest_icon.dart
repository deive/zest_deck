import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ZestIcon extends StatefulWidget {
  const ZestIcon({Key? key, required this.size}) : super(key: key);
  final double size;

  @override
  State<StatefulWidget> createState() => ZestIconState();
}

class ZestIconState extends State<ZestIcon> {
  @override
  Widget build(BuildContext context) => Container(
      width: widget.size,
      height: widget.size,
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 255, 255, 255),
        shape: BoxShape.circle,
      ),
      child: Padding(
        padding: EdgeInsets.all(widget.size / 6),
        child: SvgPicture.asset("assets/zest_icon.svg"),
      ));
}
