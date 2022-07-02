import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localisations.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:provider/provider.dart';
import 'package:zest_deck/app/main/auth_and_sync_action.dart';
import 'package:zest_deck/app/main/main_provider.dart';
import 'package:zest_deck/app/main/overflow_actions.dart';
import 'package:zest_deck/app/theme_provider.dart';

class TitleBar extends StatefulWidget {
  const TitleBar({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => TitleBarState();
}

class TitleBarState extends State<TitleBar> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final mainProvider = Provider.of<MainProvider>(context);
    final selectedDeck = mainProvider.currentlySelectedDeck;
    final title = selectedDeck == null ? l10n.appName : selectedDeck.title;
    final appBarColour = ThemeProvider.getAppBarColour(context, selectedDeck);
    final height =
        mainProvider.showNavigation ? ThemeProvider.titlebarHeight : 0.0;
    final startPadding = mainProvider.showNavigation
        ? ThemeProvider.contentPaddingForNavbar
        : 0.0;
    return AnimatedContainer(
        duration: const Duration(milliseconds: 50),
        color: appBarColour,
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
                    style: platformThemeData(context,
                        material: (theme) => theme.textTheme.headline1,
                        cupertino: (theme) => theme.textTheme.textStyle),
                  )),
                  const AuthAndSyncAction(),
                  const OverflowActions(),
                ],
              ),
            )));
  }
}
