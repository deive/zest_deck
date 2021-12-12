import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localisations.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:provider/provider.dart';
import 'package:zest_deck/app/decks/deck_list_widget.dart';
import 'package:zest_deck/app/decks/decks_provider.dart';
import 'package:zest_deck/app/theme_provider.dart';
import 'package:zest_deck/app/users/users_provider.dart';

class DeckListPage extends StatelessWidget {
  const DeckListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final decks = Provider.of<DecksProvider>(context);
    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: Row(
          children: [
            Expanded(child: Text(AppLocalizations.of(context)!.appName)),
            if (decks.isUpdatingWhileNotEmpty)
              PlatformCircularProgressIndicator(),
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

  List<Widget> _buildActions(BuildContext context) => ThemeProvider.isCupertino
      ? _buildActionsCupertino(context)
      : _buildActionsMaterial(context);

  List<Widget> _buildActionsCupertino(BuildContext context) => [
        PlatformIconButton(
          onPressed: () => showCupertinoModalPopup(
            context: context,
            builder: (context) => CupertinoActionSheet(actions: [
              CupertinoActionSheetAction(
                  onPressed: () => _actionLogout(context),
                  child: Text(AppLocalizations.of(context)!.zestLogoutAction)),
              CupertinoActionSheetAction(
                  onPressed: () => _actionRefresh(context),
                  child: Text(AppLocalizations.of(context)!.zestRefreshAction))
            ]),
          ),
          icon: const Icon(CupertinoIcons.ellipsis),
        )
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
