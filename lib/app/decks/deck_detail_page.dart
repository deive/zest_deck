import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:zest_deck/app/decks/deck.dart';

class DeckDetailPage extends StatefulWidget {
  const DeckDetailPage({Key? key, required this.deck}) : super(key: key);

  final Deck deck;

  @override
  State<StatefulWidget> createState() => DeckDetailPageState();
}

class DeckDetailPageState extends State<DeckDetailPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: Text(widget.deck.title),
      ),
      body: Scrollbar(
        isAlwaysShown: kIsWeb ||
            Platform.isLinux ||
            Platform.isMacOS ||
            Platform.isWindows,
        interactive: true,
        controller: _scrollController,
        thickness: 15,
        child: ListView.builder(
          controller: _scrollController,
          itemCount: 1,
          itemBuilder: (context, index) {
            return Text(widget.deck.title);
          },
        ),
      ),
    );
  }
}
