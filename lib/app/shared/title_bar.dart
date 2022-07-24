import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:zest/app/main/theme_provider.dart';

class TitleBar extends StatelessWidget {
  const TitleBar(
      {Key? key, required this.title, this.children = const <Widget>[]})
      : super(key: key);
  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final height = themeProvider.titleHeight;

    return AnimatedContainer(
        duration: themeProvider.fastTransitionDuration,
        color: themeProvider.appBarColour,
        child: SizedBox(
            height: height,
            child: Padding(
              padding:
                  EdgeInsets.only(left: themeProvider.contentLeftPadding + 10),
              child: Row(
                children: [
                  Expanded(
                    child: AutoSizeText(
                      title,
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: 30,
                        color: themeProvider.foregroundColour,
                      ),
                    ),
                  ),
                  ...children
                ],
              ),
            )));
  }
}
