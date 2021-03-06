import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localisations.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:provider/provider.dart';
import 'package:zest_deck/app/app_provider.dart';
import 'package:zest_deck/app/decks/deck.dart';
import 'package:zest_deck/app/decks/deck_widget.dart';
import 'package:zest_deck/app/decks/decks_provider.dart';
import 'package:zest_deck/app/main/main_provider.dart';
import 'package:zest_deck/app/theme_provider.dart';

class DeckListPage extends StatefulWidget {
  const DeckListPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => DeckListPageState();
}

class DeckListPageState extends State<DeckListPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
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
    final mainProvider = Provider.of<MainProvider>(context);
    final startPadding = mainProvider.showNavigation
        ? ThemeProvider.contentPaddingForNavbar
        : 0.0;
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
          padding: ThemeProvider.listItemInsets
              .copyWith(left: ThemeProvider.listItemInsets.left + startPadding),
          controller: _scrollController,
          scrollDirection: orientation == Orientation.portrait
              ? Axis.vertical
              : Axis.horizontal,
          itemCount: decks.decks!.length,
          itemBuilder: (context, index) =>
              _deckItem(orientation, index, decks.decks![index], (deck) {
            AutoRouter.of(context).push(app.router.deckDetailRoute(deck));
          }),
        ),
      ),
    );
  }

  Widget _deckItem(Orientation orientation, int index, Deck deck,
      void Function(Deck deck) onPressed) {
    return LayoutBuilder(builder: (context, constraints) {
      final padding = index == 0
          ? 0.0
          : orientation == Orientation.landscape
              ? constraints.maxHeight / 8
              : constraints.maxWidth / 16;
      return Padding(
        padding: EdgeInsets.fromLTRB(
          orientation == Orientation.landscape ? padding : 0,
          orientation == Orientation.portrait ? padding : 0,
          0,
          0,
        ),
        child: DeckWidget(
          deck: deck,
          onPressed: () => onPressed(deck),
        ),
      );
    });
  }
}
