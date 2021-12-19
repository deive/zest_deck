import 'package:flutter/widgets.dart';

class DeckFileErrorWidget extends StatefulWidget {
  final double? width;
  final double? height;

  const DeckFileErrorWidget({Key? key, this.width, this.height})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => DeckFileErrorWidgetState();
}

class DeckFileErrorWidgetState extends State<DeckFileErrorWidget> {
  @override
  Widget build(BuildContext context) => Image.asset(
        "assets/logos/zest_icon.png",
        width: widget.width,
        height: widget.height,
        fit: BoxFit.contain,
      );
}
