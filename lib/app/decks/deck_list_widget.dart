import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localisations.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:zest_deck/app/decks/deck.dart';
import 'package:zest_deck/app/decks/deck_icon_widget.dart';
import 'package:zest_deck/app/decks/decks_provider.dart';
import 'package:zest_deck/app/router.gr.dart';
import 'package:zest_deck/app/theme_provider.dart';

class DeckListWidget extends StatefulWidget {
  const DeckListWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => DeckListWidgetState();
}

class DeckListWidgetState extends State<DeckListWidget> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final decks = Provider.of<DecksProvider>(context);
    final orientation = MediaQuery.of(context).orientation;
    return FractionallySizedBox(
      widthFactor: orientation == Orientation.portrait ? 1 : null,
      heightFactor: orientation == Orientation.landscape ? 1 : null,
      child: Scrollbar(
        isAlwaysShown: kIsWeb ||
            Platform.isLinux ||
            Platform.isMacOS ||
            Platform.isWindows,
        interactive: true,
        controller: _scrollController,
        thickness: ThemeProvider.scrollbarSize,
        child: ListView.builder(
          controller: _scrollController,
          scrollDirection: orientation == Orientation.portrait
              ? Axis.vertical
              : Axis.horizontal,
          itemCount: decks.decks!.length,
          itemBuilder: (context, index) => DeckWidget(
            deck: decks.decks![index],
            onPressed: () {
              AutoRouter.of(context)
                  .push(DeckDetailRoute(deck: decks.decks![index]));
            },
          ),
        ),
      ),
    );
  }
}

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
                            decoration: const BoxDecoration(
                                color: Color.fromARGB(100, 100, 100, 100)),
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(
                                  constraints.maxHeight / 7,
                                  constraints.maxHeight / 40,
                                  constraints.maxHeight / 7,
                                  constraints.maxHeight / 35),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(deck.title,
                                        style: platformThemeData(
                                          context,
                                          material: (data) =>
                                              data.textTheme.headline5,
                                          cupertino: (data) =>
                                              data.textTheme.navTitleTextStyle,
                                        )),
                                  ),
                                  SizedBox(height: constraints.maxHeight / 100),
                                  FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        l10n.deckModifiedLabel,
                                        style: platformThemeData(context,
                                            material: (theme) =>
                                                theme.textTheme.bodyText1,
                                            cupertino: (theme) =>
                                                theme.textTheme.textStyle),
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
                          ))
                    ],
                  ),
                ),
              );
            }),
          )),
    );
  }
}
