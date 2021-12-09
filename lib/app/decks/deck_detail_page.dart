import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_network_image_platform_interface/cached_network_image_platform_interface.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:provider/provider.dart';
import 'package:zest_deck/app/decks/deck.dart';
import 'package:zest_deck/app/decks/deck_icon_widget.dart';
import 'package:zest_deck/app/decks/decks_provider.dart';
import 'package:zest_deck/app/models/resource.dart';
import 'package:zest_deck/app/models/section.dart';
import 'package:zest_deck/app/theme_provider.dart';

class DeckDetailPage extends StatefulWidget {
  const DeckDetailPage({Key? key, required this.deck}) : super(key: key);

  final Deck deck;

  @override
  State<StatefulWidget> createState() => DeckDetailPageState();
}

class DeckDetailPageState extends State<DeckDetailPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) => PlatformScaffold(
        body: PrimaryScrollController(
          controller: _scrollController,
          child: Scrollbar(
              isAlwaysShown: kIsWeb ||
                  Platform.isLinux ||
                  Platform.isMacOS ||
                  Platform.isWindows,
              interactive: true,
              controller: _scrollController,
              thickness: ThemeProvider.scrollbarSize,
              child: CustomScrollView(
                slivers: [
                  SliverAppBar(
                    title: Row(
                      children: [
                        SizedBox(
                          child: DeckIconWidget(
                            deck: widget.deck,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          height: 50,
                          width: 50,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(widget.deck.title),
                      ],
                    ),
                    floating: true,
                    titleTextStyle: TextStyle(
                      color: widget.deck.headerTextColour,
                    ),
                    backgroundColor: widget.deck.headerColour,
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => DeckSectionWidget(
                          deck: widget.deck,
                          section: widget.deck.sections[index]),
                      childCount: widget.deck.sections.length,
                    ),
                  ),
                ],
              )),
        ),
      );
}

class DeckSectionWidget extends StatefulWidget {
  const DeckSectionWidget({Key? key, required this.deck, required this.section})
      : super(key: key);

  final Deck deck;
  final Section section;

  Resource getResource(int index) {
    final id = section.resources[index];
    return deck.resources.firstWhere((element) => element.id == id);
  }

  @override
  State<StatefulWidget> createState() => DeckSectionWidgetState();
}

class DeckSectionWidgetState extends State<DeckSectionWidget> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final Deck deck = widget.deck;
    final Section section = widget.section;
    return Column(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: ThemeProvider.listItemInsets,
            child: Text(
              section.title,
              style: TextStyle(
                  color: deck.sectionTitleColour,
                  fontSize: Theme.of(context).textTheme.headline1?.fontSize),
            ),
          ),
        ),
        Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: ThemeProvider.listItemInsets,
              child: Text(
                section.subtitle,
                style: TextStyle(
                    color: deck.sectionSubtitleColour,
                    fontSize: Theme.of(context).textTheme.headline2?.fontSize),
              ),
            )),
        Align(
            alignment: Alignment.topLeft,
            child: SizedBox(
              height: 200,
              child: Scrollbar(
                isAlwaysShown: kIsWeb ||
                    Platform.isLinux ||
                    Platform.isMacOS ||
                    Platform.isWindows,
                interactive: true,
                controller: _scrollController,
                thickness: ThemeProvider.scrollbarSize,
                child: Padding(
                  padding: const EdgeInsets.only(
                      bottom: ThemeProvider.scrollbarSize),
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      controller: _scrollController,
                      itemCount: section.resources.length,
                      itemBuilder: (context, index) => DeckResourceWidget(
                          deck: deck, resource: widget.getResource(index))),
                ),
              ),
            )),
        const SizedBox(height: 5),
      ],
    );
  }
}

class DeckResourceWidget extends StatefulWidget {
  const DeckResourceWidget(
      {Key? key, required this.deck, required this.resource})
      : super(key: key);

  final Deck deck;
  final Resource resource;

  @override
  State<StatefulWidget> createState() => DeckResourceWidgetState();
}

class DeckResourceWidgetState extends State<DeckResourceWidget> {
  @override
  Widget build(BuildContext context) {
    final decks = Provider.of<DecksProvider>(context);
    return Padding(
      padding: ThemeProvider.listItemInsets,
      child: Column(
        children: [
          Expanded(
              child: AspectRatio(
                  aspectRatio: 1,
                  child: CachedNetworkImage(
                    imageUrl: decks.fileStorePath(
                        widget.deck.companyId!, widget.resource.thumbnailFile!),
                    httpHeaders: decks.fileStoreHeaders(),
                    imageRenderMethodForWeb: ImageRenderMethodForWeb.HttpGet,
                    placeholder: (context, url) =>
                        const Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) =>
                        Image.asset("assets/logos/zest_icon.png"),
                  ))),
          Text(widget.resource.name),
        ],
      ),
    );
  }
}
