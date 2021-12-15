import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zest_deck/app/decks/deck.dart';
import 'package:zest_deck/app/downloads/deck_file_widget.dart';
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
    final dl = Provider.of<DecksDownloadProvider>(context);
    final fileId = widget.deck.thumbnailFile!;
    final download = dl.getFileDownload(widget.deck, fileId);
    return Hero(
      tag: "deck_icon_${widget.deck.id}",
      child: ClipRRect(
        borderRadius: widget.borderRadius,
        child: LayoutBuilder(builder: (context, constraints) {
          return DeckFileWidget(
            fileDownloader: download,
            width: constraints.maxWidth,
            height: constraints.maxHeight,
          );
        }),
      ),
    );
  }
}
