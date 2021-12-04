import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:uuid/uuid.dart';
import 'package:zest_deck/app/decks/deck.dart';
import 'package:zest_deck/app/decks/deck_list_page.dart';
import 'package:zest_deck/app/models/resource.dart';
import 'package:zest_deck/app/models/section.dart';

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
              thickness: 15,
              child: CustomScrollView(
                slivers: [
                  SliverAppBar(
                    title: Row(
                      children: [
                        SizedBox(
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: DeckIconWidget(deck: widget.deck)),
                          height: 50,
                          width: 50,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(widget.deck.title),
                      ],
                    ),
                    floating: true,
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => DeckSectionWidget(
                          deck: widget.deck, section: widget.deck.sections[0]),
                      childCount: 100, //widget.deck.sections.length,
                    ),
                  ),
                ],
              )),
        ),
      );
}

class DeckSectionWidget extends StatefulWidget {
  const DeckSectionWidget({Key? key, required this.deck, required this.section})
      : super(key: key);

  final Deck deck;
  final Section section;

  Resource getResource(int index) {
    final id = section.resources[index];
    return deck.resources.firstWhere((element) => element.id == id);
  }

  @override
  State<StatefulWidget> createState() => DeckSectionWidgetState();
}

class DeckSectionWidgetState extends State<DeckSectionWidget> {
  @override
  Widget build(BuildContext context) => Column(
        children: [
          Align(
              alignment: Alignment.topLeft, child: Text(widget.section.title)),
          Align(
              alignment: Alignment.topLeft,
              child: Text(widget.section.subtitle)),
          Align(
              alignment: Alignment.topLeft,
              child: SizedBox(
                height: 200,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 100, //widget.section.resources.length,
                    itemBuilder: (context, index) =>
                        DeckResourceWidget(resource: widget.getResource(0))),
              )),
        ],
      );
}

class DeckResourceWidget extends StatefulWidget {
  const DeckResourceWidget({Key? key, required this.resource})
      : super(key: key);

  final Resource resource;

  @override
  State<StatefulWidget> createState() => DeckResourceWidgetState();
}

class DeckResourceWidgetState extends State<DeckResourceWidget> {
  @override
  Widget build(BuildContext context) => Column(
        children: [
          const Expanded(child: Placeholder()),
          Text(widget.resource.name),
        ],
      );
}
