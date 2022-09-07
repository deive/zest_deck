import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:zest/api/models/deck.dart';
import 'package:zest/app/main/main_provider.dart';
import 'package:zest/app/main/theme_provider.dart';
import 'package:zest/app/resource/resource_icon.dart';
import 'package:zest/app/resource/resource_icon_error.dart';
import 'package:zest/app/shared/gesture_detector_region.dart';
import 'package:zest/app/shared/zest_icon.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NavBar extends StatelessWidget {
  const NavBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final mainProvider = context.watch<MainProvider>();

    return AnimatedContainer(
      duration: themeProvider.navBarShowHideDuration,
      width: themeProvider.navWidth,
      child: AnimatedContainer(
        duration: themeProvider.fastTransitionDuration,
        color: themeProvider.appBarColour,
        child: Column(
          children: [
            if (!kIsWeb && Platform.isAndroid)
              const SafeArea(child: SizedBox.shrink()),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: ZestIcon(size: 60.0),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  const SizedBox(height: 8),
                  if (themeProvider.navWidth > 0) const HomeNavIcon(),
                  const SizedBox(height: 8),
                  if (themeProvider.navWidth > 0) const FavoritesNavIcon(),
                  SizedBox(
                      height: mainProvider.lastSelectedDeck == null ? 0 : 25),
                  if (themeProvider.navWidth > 0) const SelectedDeckNavIcon(),
                ],
              ),
            ),
            if (!kIsWeb && themeProvider.navWidth > 0) const SettingsNavIcon(),
            SizedBox(
                height: themeProvider.showScrollbar
                    ? themeProvider.contentScrollbarPadding
                    : 8),
          ],
        ),
      ),
    );
  }
}

/// Home naviation icon button.
class HomeNavIcon extends StatelessWidget {
  const HomeNavIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => NavIcon(
        onTap: () =>
            context.read<MainProvider>().navigateTo(MainNavigation.decks),
        icon: CupertinoIcons.home,
        title: AppLocalizations.of(context)!.appNavDecks,
      );
}

/// Favorites naviation icon button.
class FavoritesNavIcon extends StatelessWidget {
  const FavoritesNavIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => NavIcon(
        onTap: () =>
            context.read<MainProvider>().navigateTo(MainNavigation.favorites),
        icon: CupertinoIcons.square_favorites_fill,
        title: AppLocalizations.of(context)!.appNavFavorites,
      );
}

/// Selected Deck naviation icon button.
class SelectedDeckNavIcon extends StatelessWidget {
  const SelectedDeckNavIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mainProvider = context.watch<MainProvider>();
    final lastSelectedDeck = mainProvider.lastSelectedDeck;
    return lastSelectedDeck == null
        ? const SizedBox.shrink()
        : DeckNavIcon(
            onTap: () => {
              context
                  .read<MainProvider>()
                  .navigateTo(MainNavigation.selectedDeck)
            },
            deck: lastSelectedDeck,
          );
  }
}

/// Favorites naviation icon button.
class SettingsNavIcon extends StatelessWidget {
  const SettingsNavIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => NavIcon(
        onTap: () =>
            context.read<MainProvider>().navigateTo(MainNavigation.settings),
        icon: CupertinoIcons.settings,
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
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final dimension = themeProvider.navWidth - 40;
    if (dimension <= 0) return const SizedBox.shrink();
    return GestureDetectorRegion(
      onTap: onTap,
      child: Column(
        children: [
          ResourceIconWidget(
            borderRadius: BorderRadius.circular(2),
            dimension: dimension,
            companyId: deck.companyId!,
            fileId: deck.thumbnailFile!,
            progress: (context) => const SizedBox.shrink(),
            error: (context) => const ResourceIconErrorWidget(),
          ),
          const SizedBox(height: 2),
          AutoSizeText(
            deck.title,
            maxLines: 2,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: themeProvider.headerTextColour,
            ),
          ),
        ],
      ),
    );
  }
}

/// An icon button on the nav menu, with a child and text.
class NavIcon extends StatelessWidget {
  const NavIcon({
    Key? key,
    required this.onTap,
    required this.title,
    required this.icon,
  }) : super(key: key);

  final GestureTapCallback onTap;
  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    return GestureDetectorRegion(
      onTap: onTap,
      child: Column(
        children: [
          Icon(
            icon,
            color: themeProvider.headerTextColour,
          ),
          AutoSizeText(
            title,
            maxLines: 2,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: themeProvider.headerTextColour,
            ),
          ),
        ],
      ),
    );
  }
}
