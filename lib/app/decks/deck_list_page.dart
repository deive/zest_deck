import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localisations.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:provider/provider.dart';
import 'package:zest_deck/app/app_provider.dart';
import 'package:zest_deck/app/decks/deck_widget.dart';
import 'package:zest_deck/app/decks/decks_provider.dart';
import 'package:zest_deck/app/main/auth_and_sync_action.dart';
import 'package:zest_deck/app/main/overflow_actions.dart';
import 'package:zest_deck/app/theme_provider.dart';

class DeckListPage extends StatefulWidget {
  const DeckListPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => DeckListPageState();
}

class DeckListPageState extends State<DeckListPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) => PlatformScaffold(
      appBar: PlatformAppBar(
        title: Text(AppLocalizations.of(context)!.appName),
        trailingActions: const [
          AuthAndSyncAction(),
          OverflowActions(),
        ],
      ),
      body: _build(context));

  Widget _build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final decks = Provider.of<DecksProvider>(context);
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
      return _deckList();
    }
  }

  Widget _deckList() {
    final app = Provider.of<AppProvider>(context);
    final decks = Provider.of<DecksProvider>(context);
    final orientation = MediaQuery.of(context).orientation;
    return FractionallySizedBox(
      widthFactor: orientation == Orientation.portrait ? 1 : null,
      heightFactor: orientation == Orientation.landscape ? 1 : null,
      child: Scrollbar(
        thumbVisibility: kIsWeb ||
            Platform.isLinux ||
            Platform.isMacOS ||
            Platform.isWindows,
        interactive: true,
        controller: _scrollController,
        thickness: ThemeProvider.scrollbarSize,
        child: ListView.builder(
          controller: _scrollController,
          scrollDirection: orientation == Orientation.portrait
              ? Axis.vertical
              : Axis.horizontal,
          itemCount: decks.decks!.length,
          itemBuilder: (context, index) => DeckWidget(
            deck: decks.decks![index],
            onPressed: () {
              AutoRouter.of(context)
                  .push(app.router.deckDetailRoute(decks.decks![index]));
            },
          ),
        ),
      ),
    );
  }
}
