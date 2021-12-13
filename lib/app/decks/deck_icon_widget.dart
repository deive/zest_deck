import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_network_image_platform_interface/cached_network_image_platform_interface.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zest_deck/app/decks/deck.dart';
import 'package:zest_deck/app/decks/decks_provider.dart';

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
    final decks = Provider.of<DecksProvider>(context);
    return Hero(
      tag: "deck_icon_${widget.deck.id}",
      child: ClipRRect(
        borderRadius: widget.borderRadius,
        child: LayoutBuilder(builder: (context, constraints) {
          return CachedNetworkImage(
            width: constraints.maxWidth,
            height: constraints.maxHeight,
            fit: BoxFit.cover,
            imageUrl: decks.fileStorePath(
                widget.deck.companyId!, widget.deck.thumbnailFile!),
            httpHeaders: decks.fileStoreHeaders(),
            imageRenderMethodForWeb: ImageRenderMethodForWeb.HttpGet,
            placeholder: (context, url) => const CircularProgressIndicator(),
            errorWidget: (context, url, error) =>
                Image.asset("assets/logos/zest_icon.png"),
          );
        }),
      ),
    );
  }
}
