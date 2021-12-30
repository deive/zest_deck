import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zest_deck/app/app_provider.dart';
import 'package:zest_deck/app/decks/deck_widget.dart';
import 'package:zest_deck/app/decks/decks_provider.dart';
import 'package:zest_deck/app/theme_provider.dart';

class DeckListWidget extends StatefulWidget {
  const DeckListWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => DeckListWidgetState();
}

class DeckListWidgetState extends State<DeckListWidget> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final app = Provider.of<AppProvider>(context);
    final decks = Provider.of<DecksProvider>(context);
    final orientation = MediaQuery.of(context).orientation;
    return FractionallySizedBox(
      widthFactor: orientation == Orientation.portrait ? 1 : null,
      heightFactor: orientation == Orientation.landscape ? 1 : null,
      child: Scrollbar(
        isAlwaysShown: kIsWeb ||
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
