import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zest/api/models/deck.dart';
import 'package:zest/app/deck_list/deck_widget.dart';
import 'package:zest/app/main/theme_provider.dart';

class DeckList extends StatefulWidget {
  const DeckList({Key? key, required this.decks, required this.onPressed})
      : super(key: key);
  final List<Deck> decks;
  final void Function(Deck deck) onPressed;

  @override
  State<StatefulWidget> createState() => DeckListState();
}

class DeckListState extends State<DeckList> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    final themeProvider = context.read<ThemeProvider>();

    return FractionallySizedBox(
      widthFactor: orientation == Orientation.portrait ? 1 : null,
      heightFactor: orientation == Orientation.landscape ? 1 : null,
      child: Scrollbar(
        thumbVisibility: themeProvider.showScrollbar,
        interactive: true,
        controller: _scrollController,
        thickness: themeProvider.scrollbarSize,
        child: ListView.builder(
          padding: EdgeInsets.fromLTRB(
              themeProvider.contentLeftPadding,
              themeProvider.contentTopPadding,
              orientation == Orientation.portrait
                  ? themeProvider.contentScrollbarPadding
                  : themeProvider.listItemInsets.right,
              orientation == Orientation.landscape
                  ? themeProvider.contentScrollbarPadding
                  : themeProvider.listItemInsets.bottom),
          controller: _scrollController,
          scrollDirection: orientation == Orientation.portrait
              ? Axis.vertical
              : Axis.horizontal,
          itemCount: widget.decks.length,
          itemBuilder: (context, index) => DeckWidget(
            deck: widget.decks[index],
            onPressed: widget.onPressed,
          ),
        ),
      ),
    );
  }
}
