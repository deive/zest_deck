import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localisations.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:provider/provider.dart';
import 'package:zest_deck/app/api_provider.dart';
import 'package:zest_deck/app/app_provider.dart';
import 'package:zest_deck/app/decks/decks_provider.dart';
import 'package:zest_deck/app/router.gr.dart';
import 'package:zest_deck/app/theme_provider.dart';
import 'package:zest_deck/app/users/users_provider.dart';

class DeckListPage extends StatelessWidget {
  const DeckListPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => ChangeNotifierProxyProvider3<
          AppProvider, APIProvider, UsersProvider, DecksProvider>(
        create: (context) => DecksProvider(),
        update: (context, app, api, users, decks) =>
            decks!.onUpdate(app, api, users),
        child: const DeckListScaffold(),
      );
}

class DeckListScaffold extends StatelessWidget {
  const DeckListScaffold({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => PlatformScaffold(
        appBar: PlatformAppBar(
          title: Text(AppLocalizations.of(context)!.appName),
          trailingActions: _buildActions(context),
        ),
        body: const SafeArea(
          minimum: ThemeProvider.screenEdgeInsets,
          child: DeckListWidget(),
        ),
      );

  _actionLogout(BuildContext context) {
    final users = Provider.of<UsersProvider>(context, listen: false);
    users.logout();
    AutoRouter.of(context).replaceAll([const DeckListRoute()]);
  }

  _actionRefresh(BuildContext context) {
    final decks = Provider.of<DecksProvider>(context, listen: false);
    decks.update();
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

class DeckListWidget extends StatefulWidget {
  const DeckListWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => DeckListWidgetState();
}

class DeckListWidgetState extends State<DeckListWidget> {
  @override
  Widget build(BuildContext context) {
    final decks = Provider.of<DecksProvider>(context);
    if (decks.isUpdatingWhileEmpty()) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: PlatformCircularProgressIndicator(),
          ),
        ],
      );
    } else if (decks.decks == null || decks.decks!.isEmpty) {
      return const Text("No Decks :-(");
    } else {
      return Text("${decks.decks!.length} DECKS");
    }
  }
}

enum Actions { logout, refresh }
