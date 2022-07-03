import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:zest/app/main_provider.dart';

class TitleBar extends StatelessWidget {
  const TitleBar({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    final mainProvider = Provider.of<MainProvider>(context);
    final height = mainProvider.showNavigation ? 56.0 : 0.0;

    return AnimatedContainer(
        duration: const Duration(milliseconds: 50),
        color: mainProvider.getAppBarColour(),
        child: SizedBox(
            height: height,
            child: Padding(
              padding:
                  EdgeInsets.only(left: mainProvider.getContentLeftPadding()),
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
