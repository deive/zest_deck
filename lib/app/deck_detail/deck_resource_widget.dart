import 'package:flutter/widgets.dart';
import 'package:zest/api/models/deck.dart';
import 'package:zest/api/models/resource.dart';
import 'package:zest/api/models/section.dart';
import 'package:zest/app/deck_detail/deck_resource_card_widget.dart';
import 'package:zest/app/deck_detail/deck_resource_icon_widget.dart';

class DeckResourceWidget extends StatefulWidget {
  const DeckResourceWidget(
      {Key? key,
      required this.deck,
      required this.section,
      required this.resource})
      : super(key: key);

  final Deck deck;
  final Section section;
  final Resource resource;

  @override
  State<StatefulWidget> createState() => DeckResourceWidgetState();
}

class DeckResourceWidgetState extends State<DeckResourceWidget> {
  @override
  Widget build(BuildContext context) {
    switch (widget.section.type) {
      case SectionType.iconLarge:
      case SectionType.iconMedium:
      case SectionType.iconSmall:
        return DeckResourceIconWidget(
          deck: widget.deck,
          section: widget.section,
          resource: widget.resource,
        );
      case SectionType.cardFull:
      case SectionType.cardCompact:
        return DeckResourceCardWidget(
          deck: widget.deck,
          section: widget.section,
          resource: widget.resource,
        );
    }
  }
}
