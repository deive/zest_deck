import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:zest/api/models/deck.dart';
import 'package:zest/app/deck_list/deck_list_provider.dart';
import 'package:zest/app/main/theme_provider.dart';

/// Shows the icon for a deck.
class DeckIconWidget extends StatefulWidget {
  const DeckIconWidget({Key? key, required this.deck}) : super(key: key);

  final Deck deck;

  @override
  State<StatefulWidget> createState() => DeckIconWidgetState();
}

class DeckIconWidgetState extends State<DeckIconWidget> {
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final borderRadius = BorderRadius.circular(mediaQuery.size.height / 70);
    final themeProvider = context.watch<ThemeProvider>();
    final fileId = widget.deck.thumbnailFile!;

    return Hero(
      tag: "deck_icon_${widget.deck.id}",
      child: AspectRatio(
        aspectRatio: 1,
        child: ClipRRect(
          borderRadius: borderRadius,
          child: LayoutBuilder(builder: (context, constraints) {
            final decks = context.watch<DeckListProvider>();
            return Container(
                color: themeProvider.deckIconBackgroundColour,
                child: FractionallySizedBox(
                  heightFactor: 0.6,
                  widthFactor: 0.6,
                  child: SvgPicture.asset(
                    "assets/image.svg",
                    color: themeProvider.deckDetailsBackgroundColour,
                  ),
                ));
            // return DeckFileOrWebWidget(
            //   downloadBuilder: () {
            //     final dl = Provider.of<DecksDownloadProvider>(context);
            //     return dl.getFileDownload(widget.deck, fileId);
            //   },
            //   urlBuilder: () =>
            //       decks.fileStorePath(widget.deck.companyId!, fileId),
            //   width: constraints.maxWidth,
            //   height: constraints.maxHeight,
            // );
          }),
        ),
      ),
    );
  }
}
