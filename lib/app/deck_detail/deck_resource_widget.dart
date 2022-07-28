import 'package:flutter/widgets.dart';
import 'package:zest/api/models/deck.dart';
import 'package:zest/api/models/resource.dart';
import 'package:zest/api/models/section.dart';

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
      case SectionType.iconMedium:
        // TODO: Handle this case.
        break;
      case SectionType.iconLarge:
        // TODO: Handle this case.
        break;
      case SectionType.iconSmall:
        // TODO: Handle this case.
        break;
      case SectionType.cardFull:
        // TODO: Handle this case.
        break;
      case SectionType.cardCompact:
        // TODO: Handle this case.
        break;
    }
    return Text(widget.resource.name);
  }
}
