import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zest/app/favorites/favorites_list.dart';
import 'package:zest/app/favorites/favorites_provider.dart';
import 'package:zest/app/main/theme_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final favoritesProvider = context.watch<FavoritesProvider>();
    if (!favoritesProvider.initComplete) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(
        top: 5,
        bottom: 5,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 4, child: _favorites(context, favoritesProvider)),
          Expanded(flex: 3, child: _recent(context, favoritesProvider)),
        ],
      ),
    );
  }

  Widget _favorites(
          BuildContext context, FavoritesProvider favoritesProvider) =>
      _favoritesSection(
        context,
        AppLocalizations.of(context)!.appNavFavorites,
        favoritesProvider.favorites as List<FavoriteItem>,
        AppLocalizations.of(context)!.favoritesEmpty,
      );

  Widget _recent(BuildContext context, FavoritesProvider favoritesProvider) =>
      _favoritesSection(
        context,
        AppLocalizations.of(context)!.favoritesRecent,
        favoritesProvider.recentlyViewed as List<FavoriteItem>,
        AppLocalizations.of(context)!.favoritesRecentEmpty,
      );

  Widget _favoritesSection(BuildContext context, String title,
      List<FavoriteItem>? resources, String noneMsg) {
    final themeProvider = context.watch<ThemeProvider>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _favoritesText(themeProvider, title, 30),
        Expanded(
          child: resources?.isNotEmpty == true
              ? FavoritesList(
                  resources: resources ?? [],
                )
              : _favoritesText(themeProvider, noneMsg, 14),
        )
      ],
    );
  }

  Widget _favoritesText(
          ThemeProvider themeProvider, String text, double fontSize) =>
      Padding(
        padding: EdgeInsets.only(
          left: themeProvider.contentLeftPadding,
        ),
        child: Text(text,
            style: TextStyle(
              fontSize: fontSize,
              color: themeProvider.foregroundColour,
            )),
      );
}
