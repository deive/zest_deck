import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zest/app/favorites/favorite_item_widget.dart';
import 'package:zest/app/favorites/favorites_provider.dart';
import 'package:zest/app/main/theme_provider.dart';

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
  }
}
