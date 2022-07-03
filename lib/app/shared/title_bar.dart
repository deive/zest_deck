import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:zest/app/main_provider.dart';
import 'package:zest/generated/l10n.dart';

class TitleBar extends StatelessWidget {
  const TitleBar({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    final app = Provider.of<MainProvider>(context);
    final selectedDeck = app.currentlySelectedDeck;
    final title = selectedDeck == null ? l10n.appName : selectedDeck.title;
    final height = app.showNavigation ? 56.0 : 0.0;
    final startPadding = app.showNavigation ? 81.0 : 0.0;

    return AnimatedContainer(
        duration: const Duration(milliseconds: 50),
        color: app.getAppBarColour(),
        child: SizedBox(
            height: height,
            child: Padding(
              padding: EdgeInsets.only(left: startPadding),
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
