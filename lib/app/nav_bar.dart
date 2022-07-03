import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:zest/api/models/deck.dart';
import 'package:zest/app/app_provider.dart';
import 'package:zest/app/gesture_detector_region.dart';
import 'package:zest/app/zest_icon.dart';
import 'package:zest/generated/l10n.dart';

class NavBar extends StatelessWidget {
  const NavBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final app = Provider.of<AppProvider>(context);
    final lastSelectedDeck = app.lastSelectedDeck;
    final width = app.showNavigation ? 76.0 : 0.0;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 50),
      color: app.getAppBarColour(),
      child: SizedBox(
          width: width,
          child: Column(
            children: [
              if (Platform.isAndroid) const SafeArea(child: SizedBox.shrink()),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: ZestIcon(size: 60.0),
              ),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    const SizedBox(height: 8),
                    const HomeNavIcon(),
                    const SizedBox(height: 8),
                    const FavoritesNavIcon(),
                    if (lastSelectedDeck != null) const SizedBox(height: 25),
                    if (lastSelectedDeck != null)
                      DeckNavIcon(deck: lastSelectedDeck),
                  ],
                ),
              ),
              const SettingsNavIcon(),
              const SizedBox(height: 8),
            ],
          )),
    );
  }
}

/// Home naviation icon button.
class HomeNavIcon extends StatelessWidget {
  const HomeNavIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => SvgNavIcon(
        onTap: () =>
            {}, //AutoRouter.of(context).replace(const DeckListRoute()),
        assetName: "assets/home.svg",
        title: S.of(context).appNavDecks,
      );
}

/// Favorites naviation icon button.
class FavoritesNavIcon extends StatelessWidget {
  const FavoritesNavIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => SvgNavIcon(
        onTap: () =>
            {}, //AutoRouter.of(context).replace(const DeckListRoute()),
        assetName: "assets/heart.svg",
        title: S.of(context).appNavFavorites,
      );
}

/// Deck naviation icon button.
class DeckNavIcon extends StatelessWidget {
  const DeckNavIcon({Key? key, required this.deck}) : super(key: key);
  final Deck deck;

  @override
  Widget build(BuildContext context) => SvgNavIcon(
        onTap: () =>
            {}, //AutoRouter.of(context).replace(const DeckListRoute()),
        assetName: "assets/home.svg",
        title: deck.title,
      );
}

/// Favorites naviation icon button.
class SettingsNavIcon extends StatelessWidget {
  const SettingsNavIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => SvgNavIcon(
        onTap: () =>
            {}, //AutoRouter.of(context).replace(const DeckListRoute()),
        assetName: "assets/cog.svg",
        title: S.of(context).appNavSettings,
      );
}

/// An icon button on the nav menu, with an SVG icon and text.
class SvgNavIcon extends StatelessWidget {
  const SvgNavIcon(
      {Key? key,
      required this.onTap,
      required this.assetName,
      required this.title})
      : super(key: key);
  final GestureTapCallback onTap;
  final String assetName;
  final String title;

  @override
  Widget build(BuildContext context) => GestureDetectorRegion(
        onTap: onTap,
        child: NavIcon(
          title: title,
          child: LayoutBuilder(builder: (context, constraints) {
            return SizedBox(
                width: constraints.maxWidth,
                height: constraints.maxWidth,
                child: SvgPicture.asset(assetName,
                    color: Provider.of<AppProvider>(context)
                        .getHeaderTextColour(context)));
          }),
        ),
      );
}

/// An icon button on the nav menu, with a child and text.
class NavIcon extends StatelessWidget {
  const NavIcon({Key? key, required this.title, required this.child})
      : super(key: key);
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: child,
          ),
          Text(title,
              style: TextStyle(
                  color: Provider.of<AppProvider>(context)
                      .getHeaderTextColour(context))),
        ],
      );
}
