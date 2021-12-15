import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zest_deck/app/decks/deck.dart';
import 'package:zest_deck/app/downloads/deck_file_widget.dart';
import 'package:zest_deck/app/downloads/decks_download_provider.dart';
import 'package:zest_deck/app/models/resource.dart';
import 'package:zest_deck/app/models/section.dart';
import 'package:zest_deck/app/theme_provider.dart';

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
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final Deck deck = widget.deck;
    final Section section = widget.section;

    return Column(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: ThemeProvider.listItemInsets,
            child: Text(
              section.title,
              style: TextStyle(
                  color: deck.sectionTitleColour,
                  fontSize: Theme.of(context).textTheme.headline1?.fontSize),
            ),
          ),
        ),
        Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: ThemeProvider.listItemInsets,
              child: Text(
                section.subtitle,
                style: TextStyle(
                    color: deck.sectionSubtitleColour,
                    fontSize: Theme.of(context).textTheme.headline2?.fontSize),
              ),
            )),
        Align(
            alignment: Alignment.topLeft,
            child: SizedBox(
              height: 200,
              // TODO: Use CupertinoScrollbar
              child: Scrollbar(
                isAlwaysShown: kIsWeb ||
                    Platform.isLinux ||
                    Platform.isMacOS ||
                    Platform.isWindows,
                interactive: true,
                controller: _scrollController,
                thickness: ThemeProvider.scrollbarSize,
                child: Padding(
                  padding: const EdgeInsets.only(
                      bottom: ThemeProvider.scrollbarSize),
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      controller: _scrollController,
                      itemCount: section.resources.length,
                      itemBuilder: (context, index) => DeckResourceWidget(
                          deck: deck, resource: widget.getResource(index))),
                ),
              ),
            )),
        const SizedBox(height: 5),
      ],
    );
  }
}

class DeckResourceWidget extends StatefulWidget {
  const DeckResourceWidget(
      {Key? key, required this.deck, required this.resource})
      : super(key: key);

  final Deck deck;
  final Resource resource;

  @override
  State<StatefulWidget> createState() => DeckResourceWidgetState();
}

class DeckResourceWidgetState extends State<DeckResourceWidget> {
  @override
  Widget build(BuildContext context) {
    final dl = Provider.of<DecksDownloadProvider>(context);
    final download = dl.getThumbnailDownload(widget.deck, widget.resource);
    return Padding(
      padding: ThemeProvider.listItemInsets,
      child: Column(
        children: [
          Expanded(
              child: AspectRatio(
                  aspectRatio: 1,
                  child: LayoutBuilder(builder: (context, constraints) {
                    return DeckFileWidget(
                      fileDownloader: download,
                      width: constraints.maxWidth,
                      height: constraints.maxHeight,
                    );
                  }))),
          Text(widget.resource.name),
        ],
      ),
    );
  }
}
