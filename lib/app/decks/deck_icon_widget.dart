import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zest_deck/app/decks/deck.dart';
import 'package:zest_deck/app/decks/decks_provider.dart';
import 'package:zest_deck/app/downloads/deck_file_or_web_widget.dart';
import 'package:zest_deck/app/downloads/decks_download_provider.dart';

/// Shows the icon for a deck.
class DeckIconWidget extends StatefulWidget {
  const DeckIconWidget(
      {Key? key, required this.deck, required this.borderRadius})
      : super(key: key);

  final Deck deck;
  final BorderRadius borderRadius;

  @override
  State<StatefulWidget> createState() => DeckIconWidgetState();
}

class DeckIconWidgetState extends State<DeckIconWidget> {
  @override
  Widget build(BuildContext context) {
    final fileId = widget.deck.thumbnailFile!;
    return Hero(
      tag: "deck_icon_${widget.deck.id}",
      child: ClipRRect(
        borderRadius: widget.borderRadius,
        child: LayoutBuilder(builder: (context, constraints) {
          final decks = Provider.of<DecksProvider>(context);
          return DeckFileOrWebWidget(
              downloadBuilder: () {
                final dl = Provider.of<DecksDownloadProvider>(context);
                return dl.getFileDownload(widget.deck, fileId);
              },
              urlBuilder: () =>
                  decks.fileStorePath(widget.deck.companyId!, fileId),
              width: constraints.maxWidth,
              height: constraints.maxHeight);
        }),
      ),
    );
  }
}
