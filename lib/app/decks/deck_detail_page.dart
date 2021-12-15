import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:zest_deck/app/decks/deck.dart';
import 'package:zest_deck/app/decks/deck_icon_widget.dart';
import 'package:zest_deck/app/decks/deck_section_widget.dart';
import 'package:zest_deck/app/theme_provider.dart';

class DeckDetailPage extends StatefulWidget {
  const DeckDetailPage({Key? key, required this.deck}) : super(key: key);

  final Deck deck;

  @override
  State<StatefulWidget> createState() => DeckDetailPageState();
}

class DeckDetailPageState extends State<DeckDetailPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) => PlatformScaffold(
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
                          child: DeckIconWidget(
                            deck: widget.deck,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          // TODO: Check toolbar height on Cupertino.
                          height: kToolbarHeight - 5,
                          width: kToolbarHeight - 5,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(widget.deck.title),
                      ],
                    ),
                    floating: true,
                    titleTextStyle: TextStyle(
                      color: widget.deck.headerTextColour,
                    ),
                    backgroundColor: widget.deck.headerColour,
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => DeckSectionWidget(
                          deck: widget.deck,
                          section: widget.deck.sections[index]),
                      childCount: widget.deck.sections.length,
                    ),
                  ),
                ],
              )),
        ),
      );
}
