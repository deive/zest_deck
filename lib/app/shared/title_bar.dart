import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:zest/app/main/main_provider.dart';
import 'package:zest/app/main/theme_provider.dart';
import 'package:zest/app/resource/resource_icon.dart';

class TitleBarWidget extends StatefulWidget {
  const TitleBarWidget({
    Key? key,
    required this.title,
    this.children,
  }) : super(key: key);

  final String title;
  final List<Widget>? children;

  @override
  State<StatefulWidget> createState() => TitleBarWidgetState();
}

class TitleBarWidgetState extends State<TitleBarWidget> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final mainProvider = context.watch<MainProvider>();

    return Padding(
      padding: EdgeInsets.only(left: themeProvider.navWidth),
      child: AnimatedContainer(
        duration: themeProvider.fastTransitionDuration,
        color: themeProvider.appBarColour,
        child: SizedBox(
          height: themeProvider.titleHeight,
          child: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Row(
              children: [
                if (mainProvider.currentlySelectedDeck != null) _deckIcon(),
                _title(),
                ...?widget.children
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _deckIcon() {
    final themeProvider = context.watch<ThemeProvider>();
    final mainProvider = context.watch<MainProvider>();
    final deck = mainProvider.currentlySelectedDeck!;

    return Padding(
      padding: const EdgeInsets.only(
        right: 10,
      ),
      child: Hero(
        tag: "deck_icon_${deck.id}",
        child: ResourceIconWidget(
          borderRadius: BorderRadius.circular(2),
          dimension: themeProvider.titleHeight - 20,
          deck: deck,
          resourceId: deck.thumbnailFile!,
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
