import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localisations.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';
import 'package:zest_deck/app/decks/deck_list_widget.dart';
import 'package:zest_deck/app/decks/decks_provider.dart';
import 'package:zest_deck/app/users/re_login_dialog.dart';
import 'package:zest_deck/app/users/users_provider.dart';

class DeckListPage extends StatefulWidget {
  const DeckListPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => DeckListPageState();
}

class DeckListPageState extends State<DeckListPage> {
  Artboard? _riveArtboard;
  SMIInput<bool>? _refreshingInput;
  SMIInput<bool>? _onlineInput;

  @override
  void initState() {
    rootBundle.load('assets/icons/refreshing.riv').then(
      (data) async {
        final file = RiveFile.import(data);
        final artboard = file.mainArtboard;
        var controller =
            StateMachineController.fromArtboard(artboard, 'refreshing');
        if (controller != null) {
          artboard.addController(controller);
          _refreshingInput = controller.findInput('refreshing');
          _onlineInput = controller.findInput('online');
          _refreshingInput?.change(true);
        }
        setState(() => _riveArtboard = artboard);
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final decks = Provider.of<DecksProvider>(context);
    final users = Provider.of<UsersProvider>(context);

    _refreshingInput?.change(decks.isUpdatingWhileNotEmpty);
    _onlineInput?.change(users.currentData?.authToken != null);

    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: Row(
          children: [
            Expanded(child: Text(AppLocalizations.of(context)!.appName)),
            if (!kIsWeb && _riveArtboard != null)
              SizedBox(
                height: kToolbarHeight,
                child: AspectRatio(
                    aspectRatio: 1,
                    child: PlatformIconButton(
                      padding: EdgeInsets.zero,
                      icon: Rive(artboard: _riveArtboard!),
                      onPressed: () {
                        if (users.currentData?.authToken == null) {
                          showReLoginDialog(context);
                        }
                      },
                    )),
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
