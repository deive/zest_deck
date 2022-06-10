import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localisations.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:provider/provider.dart';
import 'package:zest_deck/app/decks/deck.dart';
import 'package:zest_deck/app/decks/deck_icon_widget.dart';
import 'package:zest_deck/app/main/main_provider.dart';
import 'package:zest_deck/app/main/zest_icon.dart';
import 'package:zest_deck/app/router/router_app.gr.dart';
import 'package:zest_deck/app/theme_provider.dart';

class NavBar extends StatefulWidget {
  const NavBar({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => NavBarState();
}

class NavBarState extends State<NavBar> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final mainProvider = Provider.of<MainProvider>(context);
    final selectedDeck = mainProvider.currentlySelectedDeck;
    final lastSelectedDeck = mainProvider.lastSelectedDeck;
    final appBarColour = ThemeProvider.getAppBarColour(context, selectedDeck);
    const width = ThemeProvider.navbarWidth;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 50),
      color: appBarColour,
      child: SizedBox(
        width: width,
        child: Column(
          children: [
            if (Platform.isAndroid) const SafeArea(child: SizedBox.shrink()),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: ZestIcon(size: width - 16),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  NavIcon(
                    iconData: PlatformIcons(context).collections,
                    title: l10n.navDecks,
                    onTap: () =>
                        AutoRouter.of(context).replace(const DeckListRoute()),
                    barWidth: width,
                  ),
                  NavIcon(
                    iconData: PlatformIcons(context).favoriteOutline,
                    title: l10n.navFavorites,
                    onTap: () =>
                        AutoRouter.of(context).replace(const FavoritesRoute()),
                    barWidth: width,
                  ),
                  if (lastSelectedDeck != null)
                    const SizedBox(
                      height: 25,
                    ),
                  if (lastSelectedDeck != null)
                    NavIcon(
                      deck: lastSelectedDeck,
                      title: lastSelectedDeck.title,
                      onTap: () => AutoRouter.of(context).replace(
                          DeckDetailRoute(deckId: lastSelectedDeck.id.uuid)),
                      barWidth: width,
                    ),
                ],
              ),
            ),
            NavIcon(
              iconData: PlatformIcons(context).settings,
              title: l10n.navSettings,
              onTap: () =>
                  AutoRouter.of(context).replace(const SettingsRoute()),
              barWidth: width,
            ),
          ],
        ),
      ),
    );
  }
}

class NavIcon extends StatefulWidget {
  const NavIcon({
    Key? key,
    this.iconData,
    this.deck,
    required this.title,
    this.onTap,
    required this.barWidth,
  }) : super(key: key);

  final IconData? iconData;
  final Deck? deck;
  final String title;
  final void Function()? onTap;
  final double barWidth;

  @override
  State<StatefulWidget> createState() => NavIconState();
}

class NavIconState extends State<NavIcon> {
  @override
  Widget build(BuildContext context) => PlatformWidget(
        material: (context, platform) =>
            InkWell(onTap: widget.onTap, child: _icon()),
        cupertino: (context, platform) =>
            GestureDetector(onTap: widget.onTap, child: _icon()),
      );

  Widget _icon() {
    final width = widget.barWidth - (ThemeProvider.formMargin * 2) - 10;
    final mainProvider = Provider.of<MainProvider>(context);
    final selectedDeck = mainProvider.currentlySelectedDeck;
    final textColour =
        ThemeProvider.getAppBarForegroundColour(context, selectedDeck);
    return Column(children: [
      if (widget.iconData != null)
        Icon(
          widget.iconData,
          semanticLabel: widget.title,
          size: width,
          color: textColour,
        ),
      if (widget.deck != null)
        SizedBox.square(
          dimension: width,
          child: DeckIconWidget(
            deck: widget.deck!,
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      if (widget.deck != null)
        const SizedBox(
          height: ThemeProvider.formItemMargin,
        ),
      Text(widget.title, style: TextStyle(color: textColour)),
      const SizedBox(height: ThemeProvider.formItemMargin),
    ]);
  }
}
