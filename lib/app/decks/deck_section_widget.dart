import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:provider/provider.dart';
import 'package:zest_deck/app/app_provider.dart';
import 'package:zest_deck/app/decks/deck.dart';
import 'package:zest_deck/app/decks/decks_provider.dart';
import 'package:zest_deck/app/downloads/deck_file_or_web_widget.dart';
import 'package:zest_deck/app/downloads/decks_download_provider.dart';
import 'package:zest_deck/app/models/resource.dart';
import 'package:zest_deck/app/models/section.dart';
import 'package:zest_deck/app/theme_provider.dart';
import 'package:zest_deck/app/users/re_login_dialog.dart';

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
                  fontSize: platformThemeData(context,
                      material: (theme) => theme.textTheme.headline1?.fontSize,
                      cupertino: (theme) =>
                          theme.textTheme.navLargeTitleTextStyle.fontSize)),
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
                    fontSize: platformThemeData(context,
                        material: (theme) =>
                            theme.textTheme.headline2?.fontSize,
                        cupertino: (theme) =>
                            theme.textTheme.navTitleTextStyle.fontSize)),
              ),
            )),
        Align(
            alignment: Alignment.topLeft,
            child: SizedBox(
              height: 200,
              // TODO: Use CupertinoScrollbar
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
    final app = Provider.of<AppProvider>(context);
    return Padding(
      padding: ThemeProvider.listItemInsets,
      child: Column(
        children: [
          Expanded(
              child: AspectRatio(
                  aspectRatio: 1,
                  child: PlatformIconButton(
                    onPressed: () async {
                      bool showLogin = false;
                      if (!kIsWeb) {
                        // Check for failed login on icon download
                        final dl = Provider.of<DecksDownloadProvider>(context,
                            listen: false);
                        final d = await dl.getThumbnailDownload(
                            widget.deck, widget.resource);
                        showLogin = d?.hasAuthFail ?? false;
                      }
                      if (showLogin) {
                        showReLoginDialog(context);
                      } else {
                        AutoRouter.of(context).push(app.router
                            .resourceViewRoute(widget.deck, widget.resource));
                      }
                    },
                    icon: LayoutBuilder(builder: (context, constraints) {
                      final decks = Provider.of<DecksProvider>(context);
                      return DeckFileOrWebWidget(
                        downloadBuilder: () {
                          final dl =
                              Provider.of<DecksDownloadProvider>(context);
                          return dl.getThumbnailDownload(
                              widget.deck, widget.resource);
                        },
                        urlBuilder: () => decks.fileStorePath(
                            widget.deck.companyId!,
                            widget.resource.thumbnailFile!),
                        width: constraints.maxWidth,
                        height: constraints.maxHeight,
                      );
                    }),
                  ))),
          Text(widget.resource.name),
        ],
      ),
    );
  }
}
