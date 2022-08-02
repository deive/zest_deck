import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:zest/app/main/theme_provider.dart';
import 'package:zest/app/shared/gesture_detector_region.dart';

class TitleBarWidget extends StatefulWidget {
  const TitleBarWidget({
    Key? key,
    this.onUp,
    required this.title,
    this.children,
  }) : super(key: key);

  final GestureTapCallback? onUp;
  final String title;
  final List<Widget>? children;

  @override
  State<StatefulWidget> createState() => TitleBarWidgetState();
}

class TitleBarWidgetState extends State<TitleBarWidget> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return Padding(
      padding: EdgeInsets.only(left: themeProvider.navWidth),
      child: AnimatedContainer(
        duration: themeProvider.fastTransitionDuration,
        color: themeProvider.appBarColour,
        child: SizedBox(
          height: themeProvider.titleHeight,
          child: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Row(
              children: [
                if (widget.onUp != null) _back(),
                _title(),
                ...?widget.children
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _back() {
    final themeProvider = context.watch<ThemeProvider>();

    return GestureDetectorRegion(
      onTap: widget.onUp!,
      child: Padding(
        padding: const EdgeInsets.only(
          right: 10,
          top: 5,
        ),
        child: Icon(
          CupertinoIcons.back,
          size: themeProvider.titleHeight - 10,
          color: themeProvider.headerTextColour,
        ),
      ),
    );
  }

  Widget _title() {
    final themeProvider = context.watch<ThemeProvider>();

    return Expanded(
      child: AutoSizeText(
        widget.title,
        maxLines: 1,
        style: TextStyle(
          fontSize: 30,
          color: themeProvider.headerTextColour,
        ),
      ),
    );
  }
}
