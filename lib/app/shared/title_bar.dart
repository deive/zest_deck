import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:zest/api/models/deck.dart';
import 'package:zest/app/main/main_provider.dart';
import 'package:zest/app/main/theme_provider.dart';
import 'package:zest/app/resource/resource_icon.dart';
import 'package:zest/app/resource/resource_icon_error.dart';
import 'package:zest/app/shared/gesture_detector_region.dart';
import 'package:zest/app/shared/ui.dart';

class TitleBarWidget extends StatefulWidget {
  const TitleBarWidget({
    Key? key,
    required this.title,
    this.children,
    this.onUp,
  }) : super(key: key);

  final String title;
  final List<Widget>? children;
  final GestureTapCallback? onUp;

  bool get hasChildren => children != null && children!.isNotEmpty;

  @override
  State<StatefulWidget> createState() => TitleBarWidgetState();
}

class TitleBarWidgetState extends State<TitleBarWidget> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final mainProvider = context.watch<MainProvider>();
    final showDeckIcon =
        widget.onUp == null && mainProvider.currentlySelectedDeck != null;

    return Padding(
      padding: EdgeInsets.only(left: themeProvider.navWidth),
      child: AnimatedContainer(
        duration: themeProvider.fastTransitionDuration,
        color: themeProvider.appBarColour,
        child: WrapInSafeAreaIfRequired(
          bottom: false,
          left: false,
          right: false,
          child: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Row(
              children: [
                if (mainProvider.windowStyle == DeckWindowStyle.wide)
                  _hideNavBarIcon(),
                if (showDeckIcon) _deckIcon(),
                if (widget.onUp != null) _upIcon(),
                _title(),
                SizedBox(height: themeProvider.titleHeight),
                ...?widget.children?.map(
                  (e) => SizedBox.square(
                    dimension: themeProvider.titleHeight,
                    child: e,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _upIcon() => GestureDetectorRegion(
        onTap: widget.onUp!,
        child: Icon(
          CupertinoIcons.back,
          color: context.watch<ThemeProvider>().headerTextColour,
        ),
      );

  Widget _hideNavBarIcon() => Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: GestureDetectorRegion(
          onTap: () => context.read<MainProvider>().toggleShowNavigation(),
          child: Icon(
            CupertinoIcons.sidebar_left,
            color: context.watch<ThemeProvider>().headerTextColour,
          ),
        ),
      );

  Widget _deckIcon() {
    final themeProvider = context.watch<ThemeProvider>();
    final mainProvider = context.watch<MainProvider>();
    final deck = mainProvider.currentlySelectedDeck!;
    final dimension = themeProvider.titleHeight - 20;
    if (dimension <= 0) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(
        right: 10,
      ),
      child: Hero(
        tag: "deck_icon_${deck.id}",
        child: ResourceIconWidget(
          borderRadius: BorderRadius.circular(2),
          dimension: dimension,
          companyId: deck.companyId!,
          fileId: deck.thumbnailFile!,
          progress: (context) => const SizedBox.shrink(),
          error: (context) => const ResourceIconErrorWidget(),
        ),
      ),
    );
  }

  Widget _title() {
    final themeProvider = context.watch<ThemeProvider>();

    return Expanded(
      child: AutoSizeText(
        widget.title,
        maxLines: 1,
        style: TextStyle(
          fontSize: 30,
          color: themeProvider.headerTextColour,
        ),
      ),
    );
  }
}
