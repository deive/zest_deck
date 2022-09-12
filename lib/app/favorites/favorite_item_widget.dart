import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:provider/provider.dart';
import 'package:zest/app/deck_list/deck_list_provider.dart';
import 'package:zest/app/favorites/favorites_provider.dart';
import 'package:zest/app/main/main_provider.dart';
import 'package:zest/app/main/theme_provider.dart';
import 'package:zest/app/resource/resource_icon.dart';
import 'package:zest/app/resource/resource_icon_error.dart';

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
    final themeProvider = context.watch<ThemeProvider>();
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: LayoutBuilder(builder: (context, constraints) {
        final borderRadius = BorderRadius.circular(constraints.maxHeight / 70);
        return GestureDetector(
          onTap: () => context
              .read<MainProvider>()
              .navigateToResource(favorite!.second, favorite!.first),
          child: SizedBox.square(
            dimension: constraints.maxHeight,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    flex: 30,
                    child: LayoutBuilder(builder: (context, constraints) {
                      return Hero(
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
                      );
                    }),
                  ),
                  const Expanded(flex: 1, child: SizedBox.shrink()),
                  Expanded(
                    flex: 4,
                    child: Container(
                      decoration: ShapeDecoration(
                        shape:
                            RoundedRectangleBorder(borderRadius: borderRadius),
                        color: themeProvider.deckDetailsBackgroundColour,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Center(
                          child: AutoSizeText(
                            favorite!.first.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 30,
                              color: context
                                  .watch<ThemeProvider>()
                                  .foregroundColour,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
