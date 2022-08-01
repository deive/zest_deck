import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:zest/api/models/deck.dart';
import 'package:zest/app/deck_list/deck_icon_widget.dart';
import 'package:zest/app/main/theme_provider.dart';

class DeckWidget extends StatefulWidget {
  const DeckWidget({Key? key, required this.deck, this.onPressed})
      : super(key: key);

  final Deck deck;
  final void Function(Deck deck)? onPressed;

  @override
  State<StatefulWidget> createState() => DeckWidgetState();
}

class DeckWidgetState extends State<DeckWidget> {
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final orientation = mediaQuery.orientation;
    final padding = _deckPadding();
    Widget child;
    if (orientation == Orientation.landscape) {
      child = _horizontalLayout();
    } else {
      child = _verticalLayout();
    }

    return Padding(
      padding: padding,
      child: GestureDetector(
        onTap: () {
          if (widget.onPressed != null) {
            widget.onPressed!(widget.deck);
          }
        },
        child: child,
      ),
    );
  }

  Widget _horizontalLayout() {
    final mediaQuery = MediaQuery.of(context);
    return SizedBox(
      width: mediaQuery.size.height * 0.6,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 5),
              child: DeckIconWidget(
                deck: widget.deck,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
            child: _deckDetails(),
          ),
        ],
      ),
    );
  }

  EdgeInsets _deckPadding() {
    final mediaQuery = MediaQuery.of(context);
    final themeProvider = context.watch<ThemeProvider>();
    return (Platform.isAndroid || Platform.isIOS)
        ? EdgeInsets.symmetric(
            horizontal: mediaQuery.orientation == Orientation.landscape
                ? 0
                : themeProvider.scrollbarSize + 5,
            vertical: mediaQuery.orientation == Orientation.portrait
                ? 0
                : themeProvider.scrollbarSize + 5,
          )
        : EdgeInsets.symmetric(
            horizontal: mediaQuery.orientation == Orientation.landscape
                ? 0
                : mediaQuery.size.height * 0.1,
            vertical: mediaQuery.orientation == Orientation.portrait
                ? 0
                : mediaQuery.size.height * 0.1,
          );
  }

  Widget _verticalLayout() => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            fit: FlexFit.loose,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: DeckIconWidget(
                deck: widget.deck,
              ),
            ),
          ),
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: _deckDetails(),
          ),
          const SizedBox(height: 20),
        ],
      );

  Widget _deckDetails() {
    final mediaQuery = MediaQuery.of(context);
    final borderRadius = BorderRadius.circular(mediaQuery.size.height / 100);
    final themeProvider = context.watch<ThemeProvider>();

    return Container(
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(borderRadius: borderRadius),
        color: themeProvider.deckDetailsBackgroundColour,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: _deckInfo(borderRadius),
      ),
    );
  }

  Widget _deckInfo(BorderRadius borderRadius) => Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _deckTitle(),
                _deckSubtitle(),
              ],
            ),
          ),
          _deckDownloader(borderRadius) ?? const SizedBox.shrink(),
        ],
      );

  Widget _deckTitle() => AutoSizeText(
        widget.deck.title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 30,
          color: context.watch<ThemeProvider>().foregroundColour,
        ),
      );

  Widget _deckSubtitle() => Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: AutoSizeText(
          widget.deck.subtitle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 15,
            color: context.watch<ThemeProvider>().foregroundColour,
          ),
        ),
      );

  Widget? _deckDownloader(BorderRadius borderRadius) {
    return null;
    // if (kIsWeb) return null;
    // final deck = widget.deck;
    // final downloader = Provider.of<DecksDownloadProvider>(context);
    // return Padding(
    //   padding: const EdgeInsets.only(left: 4),
    //   child: GestureDetector(
    //     onTap: () async {
    //       final dl = await downloader.getDeckDownload(deck);
    //       if (dl.hasAuthFail) {
    //         WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //           showReLoginDialog(context);
    //         });
    //       } else {
    //         downloader.startDeckDownload(deck);
    //       }
    //     },
    //     child: MouseRegion(
    //       cursor: SystemMouseCursors.click,
    //       child: Container(
    //         decoration: ShapeDecoration(
    //             shape: RoundedRectangleBorder(borderRadius: borderRadius),
    //             color: ThemeProvider.getAppBarColour(context, null)),
    //         child: Padding(
    //           padding: const EdgeInsets.all(4.0),
    //           child: DeckDownloaderWidget(
    //               deckDownloader: downloader.getDeckDownload(deck)),
    //         ),
    //       ),
    //     ),
    //   ),
    // );
  }
}
