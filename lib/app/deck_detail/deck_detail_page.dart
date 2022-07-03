import 'package:auto_route/auto_route.dart';
import 'package:flutter/widgets.dart';

class DeckDetailPage extends StatelessWidget {
  const DeckDetailPage({Key? key, @pathParam required this.deckId})
      : super(key: key);

  final String deckId;

  @override
  Widget build(BuildContext context) {
    return Text("DeckDetailPage: $deckId");
  }
}
