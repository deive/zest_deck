import 'dart:developer';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:zest/api/models/deck.dart';
import 'package:zest/app/main/main_provider.dart';
import 'package:zest/app/main/theme_provider.dart';
import 'package:zest/app/shared/gesture_detector_region.dart';
import 'package:zest/app/shared/zest_icon.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NavBar extends StatelessWidget {
  const NavBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final mainProvider = context.watch<MainProvider>();
    final currentlySelectedDeck = mainProvider.currentlySelectedDeck;

    return AnimatedContainer(
      duration: themeProvider.fastTransitionDuration,
      color: themeProvider.appBarColour,
      child: SizedBox(
          width: themeProvider.navWidth,
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
                    SizedBox(height: currentlySelectedDeck == null ? 0 : 25),
                    const SelectedDeckNavIcon(),
                  ],
                ),
              ),
              const SettingsNavIcon(),
              SizedBox(
                  height: themeProvider.showScrollbar
                      ? themeProvider.contentScrollbarPadding
                      : 8),
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
            context.read<MainProvider>().navigateTo(MainNavigation.decks),
        assetName: "assets/home.svg",
        title: AppLocalizations.of(context)!.appNavDecks,
      );
}

/// Favorites naviation icon button.
class FavoritesNavIcon extends StatelessWidget {
  const FavoritesNavIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => SvgNavIcon(
        onTap: () =>
            context.read<MainProvider>().navigateTo(MainNavigation.favorites),
        assetName: "assets/heart.svg",
        title: AppLocalizations.of(context)!.appNavFavorites,
      );
}

/// Selected Deck naviation icon button.
class SelectedDeckNavIcon extends StatelessWidget {
  const SelectedDeckNavIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mainProvider = context.watch<MainProvider>();
    final currentlySelectedDeck = mainProvider.currentlySelectedDeck;
    return currentlySelectedDeck == null
        ? const SizedBox.shrink()
        : DeckNavIcon(
            onTap: () => context
                .read<MainProvider>()
                .navigateTo(MainNavigation.selectedDeck),
            deck: currentlySelectedDeck,
          );
  }
}

/// Favorites naviation icon button.
class SettingsNavIcon extends StatelessWidget {
  const SettingsNavIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => SvgNavIcon(
        onTap: () =>
            context.read<MainProvider>().navigateTo(MainNavigation.settings),
        assetName: "assets/cog.svg",
        title: AppLocalizations.of(context)!.appNavSettings,
      );
}

/// Deck naviation icon button.
class DeckNavIcon extends StatelessWidget {
  const DeckNavIcon({Key? key, required this.onTap, required this.deck})
      : super(key: key);
  final GestureTapCallback onTap;
  final Deck deck;

  @override
  Widget build(BuildContext context) => SvgNavIcon(
        onTap: onTap,
        assetName: "assets/home.svg",
        title: deck.title,
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
                child: SvgPicture.asset(
                  assetName,
                  color: context.watch<ThemeProvider>().headerTextColour,
                ));
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
          AutoSizeText(title,
              maxLines: 2,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: context.watch<ThemeProvider>().headerTextColour,
              )),
        ],
      );
}
