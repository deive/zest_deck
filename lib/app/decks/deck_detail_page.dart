import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:zest_deck/app/decks/deck.dart';
import 'package:zest_deck/app/decks/deck_icon_widget.dart';
import 'package:zest_deck/app/decks/deck_section_widget.dart';
import 'package:zest_deck/app/decks/decks_provider.dart';
import 'package:zest_deck/app/downloads/deck_file_error_widget.dart';
import 'package:zest_deck/app/theme_provider.dart';

class DeckDetailPage extends StatefulWidget {
  const DeckDetailPage({Key? key, @pathParam required this.deckId})
      : super(key: key);

  final String deckId;

  @override
  State<StatefulWidget> createState() => DeckDetailPageState();
}

class DeckDetailPageState extends State<DeckDetailPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final decks = Provider.of<DecksProvider>(context);
    final uuid = UuidValue(widget.deckId);
    Deck? deck;
    try {
      deck = decks.decks?.singleWhere((element) => element.id == uuid);
    } finally {}

    return PlatformScaffold(
      body: PrimaryScrollController(
        controller: _scrollController,
        child: Scrollbar(
            isAlwaysShown: kIsWeb ||
                Platform.isLinux ||
                Platform.isMacOS ||
                Platform.isWindows,
            interactive: true,
            controller: _scrollController,
            thickness: ThemeProvider.scrollbarSize,
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  title: Row(
                    children: [
                      SizedBox(
                        child: deck == null
                            ? LayoutBuilder(builder: (context, constraints) {
                                return DeckFileErrorWidget(
                                    width: constraints.maxWidth,
                                    height: constraints.maxHeight);
                              })
                            : DeckIconWidget(
                                deck: deck,
                                borderRadius: BorderRadius.circular(15),
                              ),
                        // TODO: Check toolbar height on Cupertino.
                        height: kToolbarHeight - 5,
                        width: kToolbarHeight - 5,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(deck?.title ?? ""),
                    ],
                  ),
                  floating: true,
                  titleTextStyle: TextStyle(
                    color: deck?.headerTextColour,
                  ),
                  backgroundColor: deck?.headerColour,
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => DeckSectionWidget(
                        deck: deck!, section: deck.sections[index]),
                    childCount: deck?.sections.length ?? 0,
                  ),
                ),
              ],
            )),
      ),
    );
  }
}