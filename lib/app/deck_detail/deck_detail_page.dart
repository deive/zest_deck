import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:zest/api/models/deck.dart';
import 'package:zest/app/deck_detail/deck_section_widget.dart';
import 'package:zest/app/deck_list/deck_list_provider.dart';
import 'package:zest/app/main/theme_provider.dart';
import 'package:zest/app/shared/page_layout.dart';
import 'package:zest/app/shared/title_bar.dart';

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
    final deckListProvider = context.watch<DeckListProvider>();
    UuidValue? id;
    try {
      id = UuidValue(widget.deckId);
    } catch (_) {}
    final deck = id == null ? null : deckListProvider.getDeck(id);
    if (deck == null) {
      return _notFound();
    } else {
      return _deckPage(context, deck);
    }
  }

  Widget _deckPage(BuildContext context, Deck deck) {
    final themeProvider = context.watch<ThemeProvider>();
    return PageLayout(
      title: _deckTitleBar(context, deck),
      child: PrimaryScrollController(
        controller: _scrollController,
        child: Scrollbar(
          thumbVisibility: kIsWeb ||
              Platform.isLinux ||
              Platform.isMacOS ||
              Platform.isWindows,
          interactive: true,
          controller: _scrollController,
          thickness: themeProvider.scrollbarSize,
          child: Padding(
            padding: themeProvider.contentInsets,
            child: CustomScrollView(
              slivers: [
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => DeckSectionWidget(
                      deck: deck,
                      section: deck.sections[index],
                    ),
                    childCount: deck.sections.length,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  TitleBar? _deckTitleBar(BuildContext context, Deck deck) {
    if (deck.windowStyle == DeckWindowStyle.noTitle) {
      return null;
    } else {
      return TitleBar(
        title: deck.title,
      );
    }
  }

  // TODO: Deck not found UI.
  Widget _notFound() => Text("NOT FOUND: ${widget.deckId}");
}
