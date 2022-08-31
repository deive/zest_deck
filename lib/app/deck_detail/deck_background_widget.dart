import 'package:flutter/widgets.dart';
import 'package:zest/api/models/deck.dart';
import 'package:zest/app/resource/resource_icon.dart';

class DeckBackgroundWidget extends StatefulWidget {
  const DeckBackgroundWidget({Key? key, required this.deck}) : super(key: key);

  final Deck deck;

  @override
  State<StatefulWidget> createState() => DeckBackgroundWidgetState();
}

class DeckBackgroundWidgetState extends State<DeckBackgroundWidget> {
  @override
  Widget build(BuildContext context) {
    if (widget.deck.backgroundImageResourceId != null) {
      return LayoutBuilder(builder: (context, constraints) {
        final resource =
            widget.deck.getResource(widget.deck.backgroundImageResourceId!);
        final resourceFile = resource?.contentFile;
        if (resourceFile == null) return const SizedBox.shrink();
        double dimension;
        if (constraints.maxHeight > constraints.maxWidth) {
          dimension = constraints.maxHeight;
        } else {
          dimension = constraints.maxWidth;
        }
        return ResourceIconWidget(
          borderRadius: BorderRadius.zero,
          companyId: widget.deck.companyId!,
          fileId: resourceFile,
          dimension: dimension,
          containerColor: const Color(0x00000000),
          progress: (context) => const SizedBox.shrink(),
          error: (context) => const SizedBox.shrink(),
        );
      });
    } else {
      return const SizedBox.shrink();
    }
  }
}
