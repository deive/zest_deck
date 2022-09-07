import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:provider/provider.dart';
import 'package:zest/app/deck_list/deck_list_provider.dart';
import 'package:zest/app/favorites/favorites_provider.dart';
import 'package:zest/app/main/main_provider.dart';
import 'package:zest/app/main/theme_provider.dart';
import 'package:zest/app/resource/resource_icon.dart';
import 'package:zest/app/resource/resource_icon_error.dart';
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

class FavoritesList extends StatefulWidget {
  const FavoritesList({
    Key? key,
    required this.resources,
  }) : super(key: key);

  final List<FavoriteItem> resources;

  @override
  State<StatefulWidget> createState() => FavoritesListState();
}

class FavoritesListState extends State<FavoritesList> {
  final ScrollController _scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    final themeProvider = context.read<ThemeProvider>();
    return LayoutBuilder(builder: (context, constraints) {
      return Scrollbar(
        thumbVisibility: themeProvider.showScrollbar,
        interactive: true,
        controller: _scrollController,
        thickness: themeProvider.scrollbarSize,
        child: ListView.builder(
          controller: _scrollController,
          scrollDirection: Axis.horizontal,
          itemCount: widget.resources.length,
          padding: EdgeInsets.only(
              left: themeProvider.contentLeftPadding,
              bottom: themeProvider.contentScrollbarPadding),
          itemBuilder: (context, index) => FavoriteItemWidget(
            favoriteItem: widget.resources[index],
            // onPressed: widget.onPressed,
          ),
        ),
      );
    });
  }
}

class FavoriteItemWidget extends StatefulWidget {
  const FavoriteItemWidget({
    Key? key,
    required this.favoriteItem,
  }) : super(key: key);

  final FavoriteItem favoriteItem;

  @override
  State<StatefulWidget> createState() => FavoriteItemWidgetState();
}

class FavoriteItemWidgetState extends State<FavoriteItemWidget> {
  late ResourceAndDeck? favorite;

  @override
  void initState() {
    super.initState();
    favorite =
        context.read<DeckListProvider>().getResource(widget.favoriteItem);
  }

  @override
  Widget build(BuildContext context) {
    if (favorite == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(right: 20),
      child: LayoutBuilder(builder: (context, constraints) {
        final borderRadius = BorderRadius.circular(constraints.maxHeight / 70);
        return GestureDetector(
          onTap: () => context
              .read<MainProvider>()
              .navigateToResource(favorite!.second, favorite!.first),
          child: Hero(
            tag: "resource_icon_${favorite!.first.id}",
            child: ResourceIconWidget(
              borderRadius: borderRadius,
              companyId: widget.favoriteItem.companyId,
              fileId: favorite!.first.thumbnailFile!,
              dimension: constraints.maxHeight,
              progress: (context) => Center(
                child: PlatformCircularProgressIndicator(),
              ),
              error: (context) => const ResourceIconErrorWidget(),
            ),
          ),
        );
      }),
    );
  }
}
