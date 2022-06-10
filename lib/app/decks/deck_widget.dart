import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:provider/provider.dart';
import 'package:zest_deck/app/decks/deck.dart';
import 'package:zest_deck/app/decks/deck_icon_widget.dart';
import 'package:zest_deck/app/downloads/deck_downloader_widget.dart';
import 'package:zest_deck/app/downloads/decks_download_provider.dart';
import 'package:zest_deck/app/theme_provider.dart';
import 'package:zest_deck/app/users/re_login_dialog.dart';

class DeckWidget extends StatefulWidget {
  const DeckWidget({Key? key, required this.deck, this.onPressed})
      : super(key: key);

  final Deck deck;
  final void Function()? onPressed;

  @override
  State<StatefulWidget> createState() => DeckWidgetState();
}

class DeckWidgetState extends State<DeckWidget> {
  @override
  Widget build(BuildContext context) =>
      _layout(MediaQuery.of(context).orientation);

  Widget _layout(Orientation orientation) => FractionallySizedBox(
      widthFactor: orientation == Orientation.portrait ? 0.6 : null,
      heightFactor: orientation == Orientation.landscape ? 0.6 : null,
      child: AspectRatio(
          aspectRatio: 1,
          child: LayoutBuilder(builder: (context, constraints) {
            final borderRadius =
                BorderRadius.circular(constraints.maxHeight / 30);
            return GestureDetector(
              onTap: widget.onPressed,
              child: Column(
                children: [
                  Expanded(child: _deckIcon(borderRadius)),
                  SizedBox(height: ThemeProvider.listItemInsets.bottom),
                  _deckDetails(borderRadius, constraints.maxHeight)
                ],
              ),
            );
          })));

  Widget _deckIcon(BorderRadius borderRadius) =>
      LayoutBuilder(builder: (context, constraints) {
        return SizedBox(
          width: constraints.maxWidth,
          height: constraints.maxHeight,
          child: DeckIconWidget(
            deck: widget.deck,
            borderRadius: borderRadius,
          ),
        );
      });

  Widget _deckDetails(BorderRadius borderRadius, double maxHeight) {
    final backgroundColour = platformThemeData(context,
        material: (theme) => theme.backgroundColor,
        cupertino: (theme) => theme.scaffoldBackgroundColor);
    return Container(
      decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(borderRadius: borderRadius),
          color: backgroundColour),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: _deckInfo(borderRadius, maxHeight),
      ),
    );
  }

  Widget _deckInfo(BorderRadius borderRadius, double maxHeight) => Row(
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

  Widget _deckTitle() => FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(widget.deck.title,
            style: platformThemeData(
              context,
              material: (data) => data.textTheme.headline5,
              cupertino: (data) => data.textTheme.navTitleTextStyle,
            )),
      );

  Widget _deckSubtitle() => Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            widget.deck.subtitle,
            style: platformThemeData(context,
                material: (theme) => theme.textTheme.bodyText1,
                cupertino: (theme) => theme.textTheme.textStyle),
          ),
        ),
      );

  Widget? _deckDownloader(BorderRadius borderRadius) {
    if (kIsWeb) return null;
    final deck = widget.deck;
    final downloader = Provider.of<DecksDownloadProvider>(context);
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: GestureDetector(
        onTap: () async {
          final dl = await downloader.getDeckDownload(deck);
          if (dl.hasAuthFail) {
            showReLoginDialog(context);
          } else {
            downloader.startDeckDownload(deck);
          }
        },
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: Container(
            decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(borderRadius: borderRadius),
                color: ThemeProvider.getAppBarColour(context, null)),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: DeckDownloaderWidget(
                  deckDownloader: downloader.getDeckDownload(deck)),
            ),
          ),
        ),
      ),
    );
  }
}
