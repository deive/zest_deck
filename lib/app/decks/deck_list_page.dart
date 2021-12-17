import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localisations.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:provider/provider.dart';
import 'package:zest_deck/app/decks/deck_list_widget.dart';
import 'package:zest_deck/app/decks/decks_provider.dart';
import 'package:zest_deck/app/users/users_provider.dart';

class DeckListPage extends StatelessWidget {
  const DeckListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final decks = Provider.of<DecksProvider>(context);
    final users = Provider.of<UsersProvider>(context);
    final isOnline = users.currentData?.authToken != null;
    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: Row(
          children: [
            Expanded(child: Text(AppLocalizations.of(context)!.appName)),
            if (decks.isUpdatingWhileNotEmpty)
              ...platformThemeData(
                context,
                material: (theme) => [PlatformCircularProgressIndicator()],
                cupertino: (theme) => [
                  PlatformCircularProgressIndicator(),
                  const SizedBox(
                    width: 15,
                  )
                ],
              ),
            if (!kIsWeb)
              Icon(
                PlatformIcons(context).shuffle,
                color: platformThemeData(
                  context,
                  material: (theme) => isOnline
                      ? theme.colorScheme.onPrimary
                      : theme.colorScheme.primary,
                  cupertino: (theme) => isOnline
                      ? theme.textTheme.textStyle.color
                      : theme.scaffoldBackgroundColor,
                ),
              ),
          ],
        ),
        trailingActions: _buildActions(context),
      ),
      body: _body(context, decks),
    );
  }

  Widget _body(BuildContext context, DecksProvider decks) {
    final l10n = AppLocalizations.of(context)!;
    if (decks.isUpdatingWhileEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: PlatformCircularProgressIndicator(),
          ),
        ],
      );
    } else if (decks.hasUpdateErrorWhileEmpty) {
      return Center(
        child: Text(l10n.noDecksErrorMessage),
      );
    } else if (decks.decks == null || decks.decks!.isEmpty) {
      return Center(
          child: Text(l10n.noDecksMessage,
              style: platformThemeData(
                context,
                material: (data) => data.textTheme.headline1,
                cupertino: (data) => data.textTheme.navLargeTitleTextStyle,
              )));
    } else {
      return const DeckListWidget();
    }
  }

  _actionLogout(BuildContext context) {
    final users = Provider.of<UsersProvider>(context, listen: false);
    users.logout();
  }

  _actionRefresh(BuildContext context) {
    final decks = Provider.of<DecksProvider>(context, listen: false);
    decks.updateDecksFromAPI();
  }

  List<Widget> _buildActions(BuildContext context) => platformThemeData(context,
      material: (theme) => _buildActionsMaterial(context),
      cupertino: (theme) => _buildActionsCupertino(context, theme));

  List<Widget> _buildActionsCupertino(
          BuildContext context, CupertinoThemeData theme) =>
      [
        PlatformIconButton(
            onPressed: () => showCupertinoModalPopup(
                  context: context,
                  builder: (context) => CupertinoActionSheet(actions: [
                    CupertinoActionSheetAction(
                        onPressed: () => _actionLogout(context),
                        child: Text(
                          AppLocalizations.of(context)!.zestLogoutAction,
                          style:
                              TextStyle(color: theme.textTheme.textStyle.color),
                        )),
                    CupertinoActionSheetAction(
                        isDefaultAction: true,
                        onPressed: () {
                          _actionRefresh(context);
                          AutoRouter.of(context).pop();
                        },
                        child: Text(
                          AppLocalizations.of(context)!.zestRefreshAction,
                          style:
                              TextStyle(color: theme.textTheme.textStyle.color),
                        ))
                  ]),
                ),
            icon: Icon(
              CupertinoIcons.ellipsis,
              color: theme.textTheme.textStyle.color,
            ))
      ];

  List<Widget> _buildActionsMaterial(BuildContext context) => [
        PopupMenuButton<Actions>(
          onSelected: (value) {
            switch (value) {
              case Actions.logout:
                _actionLogout(context);
                break;
              case Actions.refresh:
                _actionRefresh(context);
                break;
            }
          },
          itemBuilder: (context) => <PopupMenuEntry<Actions>>[
            PopupMenuItem<Actions>(
              value: Actions.logout,
              child: Text(AppLocalizations.of(context)!.zestLogoutAction),
            ),
            PopupMenuItem<Actions>(
              value: Actions.refresh,
              child: Text(AppLocalizations.of(context)!.zestRefreshAction),
            ),
          ],
        ),
      ];
}

enum Actions { logout, refresh }
