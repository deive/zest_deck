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
    final mq = MediaQuery.of(context);

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
                  height: widget.section.type.getUIHeight(mq),
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
    final mq = MediaQuery.of(context);
    final margin = widget.section.type.getUIMarginFromHeight(mq);

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
  double getUIHeight(MediaQueryData mq) {
    switch (this) {
      case SectionType.iconSmall:
      case SectionType.iconMedium:
      case SectionType.iconLarge:
        return getUIIconHeight(mq) +
            getUITitleTextHeight(mq) +
            (getUIMarginFromHeight(mq) * 2) +
            15;
      case SectionType.cardFull:
      case SectionType.cardCompact:
        return getUICardHeight(mq) + 35;
    }
  }

  double getUIIconHeight(MediaQueryData mq) {
    switch (this) {
      case SectionType.iconSmall:
      case SectionType.cardCompact:
        return _smallIconHeight(mq);
      case SectionType.iconMedium:
      case SectionType.cardFull:
        return _mediumIconHeight(mq);
      case SectionType.iconLarge:
        return _largeIconHeight(mq);
    }
  }

  double getUICardHeight(MediaQueryData mq) =>
      getUIIconHeight(mq) +
      (getUIMarginFromHeight(mq) * 2) +
      (getUITextMarginFromHeight(mq) * 3) +
      getUICardDetailsTextHeight(mq) +
      getUITitleTextHeight(mq) +
      (this == SectionType.cardCompact
          ? 0
          : (getUICardMetadataTextHeight(mq) * 2) +
              (getUITextMarginFromHeight(mq)));

  double getUITitleTextHeight(MediaQueryData mq) => _ratioHeight(mq, 0.05);

  double getUIMarginFromHeight(MediaQueryData mq) => _ratioHeight(mq, 0.02);

  double getUITextMarginFromHeight(MediaQueryData mq) => _ratioHeight(mq, 0.01);

  double getUICardDetailsTextHeight(MediaQueryData mq) => _ratioHeight(mq, 0.2);

  double getUICardMetadataTextHeight(MediaQueryData mq) =>
      _ratioHeight(mq, 0.02);

  double _smallIconHeight(MediaQueryData mq) => _ratioHeight(mq, 0.2);
  double _mediumIconHeight(MediaQueryData mq) => _ratioHeight(mq, 0.3);
  double _largeIconHeight(MediaQueryData mq) => _ratioHeight(mq, 0.4);

  double _ratioHeight(MediaQueryData mq, double ratio) =>
      mq.size.height * ratio;
}
