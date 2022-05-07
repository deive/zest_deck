import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localisations.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:provider/provider.dart';
import 'package:zest_deck/app/main/main_provider.dart';
import 'package:zest_deck/app/theme_provider.dart';
import 'package:zest_deck/app/users/users_provider.dart';

class OverflowActions extends StatefulWidget {
  const OverflowActions({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => OverflowActionsState();
}

class OverflowActionsState extends State<OverflowActions> {
  @override
  Widget build(BuildContext context) {
    final mainProvider = Provider.of<MainProvider>(context);
    final selectedDeck = mainProvider.currentlySelectedDeck;
    final textColour =
        ThemeProvider.getAppBarForegroundColour(context, selectedDeck);
    return PlatformWidget(
        material: (context, platform) => PopupMenuButton<Actions>(
              onSelected: (value) {
                switch (value) {
                  case Actions.logout:
                    _actionLogout(context);
                    break;
                }
              },
              itemBuilder: (context) => <PopupMenuEntry<Actions>>[
                PopupMenuItem<Actions>(
                  value: Actions.logout,
                  child: Text(AppLocalizations.of(context)!.zestLogoutAction),
                ),
              ],
              icon: Icon(
                Icons.adaptive.more,
                color: textColour,
              ),
            ),
        cupertino: (context, platform) {
          return PlatformIconButton(
              onPressed: () => showCupertinoModalPopup(
                    context: context,
                    builder: (context) => CupertinoActionSheet(actions: [
                      CupertinoActionSheetAction(
                          onPressed: () => _actionLogout(context),
                          child: Text(
                            AppLocalizations.of(context)!.zestLogoutAction,
                            style: TextStyle(color: textColour),
                          )),
                    ]),
                  ),
              icon: Icon(
                CupertinoIcons.ellipsis,
                color: textColour,
              ));
        });
  }

  _actionLogout(BuildContext context) {
    final users = Provider.of<UsersProvider>(context, listen: false);
    users.logout();
  }
}

enum Actions { logout }
