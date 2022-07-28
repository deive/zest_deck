import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zest/api/models/deck.dart';
import 'package:zest/api/models/resource.dart';
import 'package:zest/api/models/section.dart';
import 'package:zest/app/deck_detail/deck_resource_widget.dart';
import 'package:zest/app/main/theme_provider.dart';

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
    final themeProvider = context.watch<ThemeProvider>();

    return Column(
      children: [
        _sectionTitle(),
        _sectionSubtitle(),
        Align(
            alignment: Alignment.topLeft,
            child: SizedBox(
              height: 200,
              child: Scrollbar(
                thumbVisibility: kIsWeb ||
                    Platform.isLinux ||
                    Platform.isMacOS ||
                    Platform.isWindows,
                interactive: true,
                controller: _scrollController,
                thickness: themeProvider.scrollbarSize,
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: themeProvider.scrollbarSize,
                  ),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    controller: _scrollController,
                    itemCount: widget.section.resources.length,
                    itemBuilder: (context, index) => DeckResourceWidget(
                      deck: widget.deck,
                      section: widget.section,
                      resource: widget.getResource(index),
                    ),
                  ),
                ),
              ),
            )),
        const SizedBox(height: 5),
      ],
    );
  }

  Widget _sectionTitle() => widget.section.title.isEmpty
      ? const SizedBox.shrink()
      : Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: context.watch<ThemeProvider>().listItemInsets,
            child: Text(
              widget.section.title,
              style: TextStyle(
                color: widget.deck.sectionTitleColour,
                fontSize: 25,
              ),
            ),
          ),
        );

  Widget _sectionSubtitle() => widget.section.subtitle.isEmpty
      ? const SizedBox.shrink()
      : Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: context.watch<ThemeProvider>().listItemInsets,
            child: Text(
              widget.section.subtitle,
              style: TextStyle(
                color: widget.deck.sectionSubtitleColour,
                fontSize: 20,
              ),
            ),
          ),
        );
}
