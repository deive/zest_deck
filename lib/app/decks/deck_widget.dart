import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localisations.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:zest_deck/app/decks/deck.dart';
import 'package:zest_deck/app/decks/deck_icon_widget.dart';
import 'package:zest_deck/app/downloads/deck_downloader_widget.dart';
import 'package:zest_deck/app/downloads/decks_download_provider.dart';
import 'package:zest_deck/app/users/re_login_dialog.dart';

class DeckWidget extends StatefulWidget {
  DeckWidget({Key? key, required this.deck, this.onPressed}) : super(key: key);

  final Deck deck;
  final void Function()? onPressed;

  final DateFormat _dateFormat = DateFormat.yMMMMEEEEd();

  String get deckModifiedFormatted {
    if (deck.modified != null) {
      return _dateFormat.format(deck.modified!);
    } else {
      return "";
    }
  }

  @override
  State<StatefulWidget> createState() => DeckWidgetState();
}

class DeckWidgetState extends State<DeckWidget> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final deck = widget.deck;
    final orientation = MediaQuery.of(context).orientation;
    final backgroundColour = platformThemeData(context,
        material: (theme) => theme.backgroundColor,
        cupertino: (theme) => theme.scaffoldBackgroundColor);
    return FractionallySizedBox(
      widthFactor: orientation == Orientation.portrait ? 0.75 : null,
      heightFactor: orientation == Orientation.landscape ? 0.75 : null,
      child: AspectRatio(
          aspectRatio: 1,
          child: PlatformIconButton(
            onPressed: widget.onPressed,
            icon: LayoutBuilder(builder: (context, constraints) {
              final borderRadius =
                  BorderRadius.circular(constraints.maxHeight / 5);
              return FractionallySizedBox(
                widthFactor: orientation == Orientation.portrait ? 1 : null,
                heightFactor: orientation == Orientation.landscape ? 1 : null,
                child: ClipRRect(
                  borderRadius: borderRadius,
                  child: Stack(
                    children: [
                      LayoutBuilder(builder: (context, constraints) {
                        return SizedBox(
                          child: DeckIconWidget(
                            deck: deck,
                            borderRadius: borderRadius,
                          ),
                          width: constraints.maxWidth,
                          height: constraints.maxHeight,
                        );
                      }),
                      Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            decoration: BoxDecoration(
                                color: backgroundColour.withAlpha(150)),
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(
                                  constraints.maxHeight / 7,
                                  constraints.maxHeight / 40,
                                  constraints.maxHeight / 7,
                                  constraints.maxHeight / 35),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: Text(deck.title,
                                              style: platformThemeData(
                                                context,
                                                material: (data) =>
                                                    data.textTheme.headline5,
                                                cupertino: (data) => data
                                                    .textTheme
                                                    .navTitleTextStyle,
                                              )),
                                        ),
                                        SizedBox(
                                            height:
                                                constraints.maxHeight / 100),
                                        FittedBox(
                                            fit: BoxFit.scaleDown,
                                            child: Text(
                                              l10n.deckModifiedLabel,
                                              style: platformThemeData(context,
                                                  material: (theme) =>
                                                      theme.textTheme.bodyText1,
                                                  cupertino: (theme) => theme
                                                      .textTheme.textStyle),
                                            )),
                                        FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: Text(
                                            widget.deckModifiedFormatted,
                                            style: platformThemeData(context,
                                                material: (theme) =>
                                                    theme.textTheme.bodyText1,
                                                cupertino: (theme) =>
                                                    theme.textTheme.textStyle),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  _deckDownloader() ?? const SizedBox.shrink(),
                                ],
                              ),
                            ),
                          )),
                    ],
                  ),
                ),
              );
            }),
          )),
    );
  }

  Widget? _deckDownloader() {
    if (kIsWeb) return null;
    final deck = widget.deck;
    final downloader = Provider.of<DecksDownloadProvider>(context);
    return PlatformIconButton(
      icon: DeckDownloaderWidget(
          deckDownloader: downloader.getDeckDownload(deck)),
      onPressed: () async {
        final dl = await downloader.getDeckDownload(deck);
        if (dl.hasAuthFail) {
          showReLoginDialog(context);
        } else {
          downloader.startDeckDownload(deck);
        }
      },
    );
  }
}
