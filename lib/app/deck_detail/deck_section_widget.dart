import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zest/api/models/deck.dart';
import 'package:zest/api/models/resource.dart';
import 'package:zest/api/models/section.dart';
import 'package:zest/app/deck_detail/deck_resource_widget.dart';
import 'package:zest/app/main/main_provider.dart';
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(),
        _sectionSubtitle(),
        Scrollbar(
          thumbVisibility: kIsWeb ||
              Platform.isLinux ||
              Platform.isMacOS ||
              Platform.isWindows,
          interactive: true,
          controller: _scrollController,
          thickness: themeProvider.scrollbarSize,
          child: widget.section.resources.isEmpty
              ? const SizedBox.shrink()
              : SizedBox(
                  height: widget.section.type.getUIHeight(context),
                  child: Padding(
                    padding: EdgeInsets.only(
                      bottom: themeProvider.scrollbarSize,
                    ),
                    child: ListView.builder(
                      scrollDirection: widget.deck.flow == DeckFlow.horizontal
                          ? Axis.horizontal
                          : Axis.vertical,
                      controller: _scrollController,
                      itemCount: widget.section.resources.length,
                      itemBuilder: (context, index) =>
                          _listItem(context, index),
                    ),
                  ),
                ),
        ),
      ],
    );
  }

  Widget _listItem(BuildContext context, int index) {
    final themeProvider = context.watch<ThemeProvider>();
    final resource = widget.getResource(index);
    final margin = widget.section.type.getUIMarginFromHeight(context);
    return Padding(
      padding: EdgeInsets.only(
        left: index == 0 ? themeProvider.contentLeftPadding : margin,
        right: margin +
            (widget.section.resources.length - 1 == index
                ? themeProvider.scrollbarSize
                : 0),
      ),
      child: GestureDetector(
        onTap: () => context.read<MainProvider>().navigateToResource(
              widget.deck,
              resource,
            ),
        child: DeckResourceWidget(
          deck: widget.deck,
          section: widget.section,
          resource: resource,
        ),
      ),
    );
  }

  Widget _sectionTitle() => widget.section.title.isEmpty
      ? const SizedBox.shrink()
      : _sectionHeader(
          widget.section.title,
          widget.deck.sectionTitleColour,
          25,
        );

  Widget _sectionSubtitle() => widget.section.subtitle.isEmpty
      ? const SizedBox.shrink()
      : _sectionHeader(
          widget.section.subtitle,
          widget.deck.sectionSubtitleColour,
          20,
        );

  Widget _sectionHeader(String header, Color? color, double fontSize) {
    final themeProvider = context.watch<ThemeProvider>();
    return Padding(
      padding: themeProvider.listItemInsets.copyWith(
        left: themeProvider.contentLeftPadding,
        right: 0,
      ),
      child: Text(
        header,
        style: TextStyle(
          color: color,
          fontSize: fontSize,
        ),
      ),
    );
  }
}

extension SectionTypeUI on SectionType {
  double getUIHeight(BuildContext context) {
    switch (this) {
      case SectionType.iconSmall:
      case SectionType.iconMedium:
      case SectionType.iconLarge:
        return getUIIconHeight(context) +
            getUITitleTextHeight(context) +
            (getUIMarginFromHeight(context) * 2) +
            15;
      case SectionType.cardFull:
      case SectionType.cardCompact:
        return getUICardHeight(context) + 35;
    }
  }

  double getUIIconHeight(BuildContext context) {
    switch (this) {
      case SectionType.iconSmall:
      case SectionType.cardCompact:
        return _smallIconHeight(context);
      case SectionType.iconMedium:
      case SectionType.cardFull:
        return _mediumIconHeight(context);
      case SectionType.iconLarge:
        return _largeIconHeight(context);
    }
  }

  double getUICardHeight(BuildContext context) =>
      getUIIconHeight(context) +
      (getUIMarginFromHeight(context) * 2) +
      (getUITextMarginFromHeight(context) * 3) +
      getUICardDetailsTextHeight(context) +
      getUITitleTextHeight(context) +
      (this == SectionType.cardCompact
          ? 0
          : (getUICardMetadataTextHeight(context) * 2) +
              (getUITextMarginFromHeight(context)));

  double getUITitleTextHeight(BuildContext context) =>
      _ratioHeight(context, 0.05);

  double getUIMarginFromHeight(BuildContext context) =>
      _ratioHeight(context, 0.02);

  double getUITextMarginFromHeight(BuildContext context) =>
      _ratioHeight(context, 0.01);

  double getUICardDetailsTextHeight(BuildContext context) =>
      _ratioHeight(context, 0.2);

  double getUICardMetadataTextHeight(BuildContext context) =>
      _ratioHeight(context, 0.02);

  double _smallIconHeight(BuildContext context) => _ratioHeight(context, 0.2);
  double _mediumIconHeight(BuildContext context) => _ratioHeight(context, 0.3);
  double _largeIconHeight(BuildContext context) => _ratioHeight(context, 0.4);

  double _ratioHeight(BuildContext context, double ratio) =>
      MediaQuery.of(context).size.height * ratio;
}
