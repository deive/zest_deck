import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:zest/app/main_provider.dart';

class TitleBar extends StatelessWidget {
  const TitleBar({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final height = themeProvider.titleHeight;

    return AnimatedContainer(
        duration: const Duration(milliseconds: 50),
        color: themeProvider.appBarColour,
        child: SizedBox(
            height: height,
            child: Padding(
              padding: EdgeInsets.only(left: themeProvider.contentLeftPadding),
              child: Row(
                children: [
                  Expanded(
                      child: AutoSizeText(
                    title,
                    maxLines: 1,
                    style: const TextStyle(fontSize: 30),
                  )),
                ],
              ),
            )));
  }
}
