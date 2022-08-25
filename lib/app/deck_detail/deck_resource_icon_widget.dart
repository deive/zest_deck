import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:provider/provider.dart';
import 'package:zest/api/models/deck.dart';
import 'package:zest/api/models/resource.dart';
import 'package:zest/api/models/section.dart';
import 'package:zest/app/deck_detail/deck_section_widget.dart';
import 'package:zest/app/main/theme_provider.dart';
import 'package:zest/app/resource/resource_icon.dart';
import 'package:zest/app/resource/resource_icon_error.dart';

class DeckResourceIconWidget extends StatefulWidget {
  const DeckResourceIconWidget(
      {Key? key,
      required this.deck,
      required this.section,
      required this.resource})
      : super(key: key);

  final Deck deck;
  final Section section;
  final Resource resource;

  @override
  State<StatefulWidget> createState() => DeckResourceIconWidgetState();
}

class DeckResourceIconWidgetState extends State<DeckResourceIconWidget> {
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final borderRadius = BorderRadius.circular(mediaQuery.size.height / 70);
    final themeProvider = context.watch<ThemeProvider>();
    final iconSize = widget.section.type.getUIIconHeight(context);
    final textHeight = widget.section.type.getUITitleTextHeight(context);
    final marginHeight = widget.section.type.getUIMarginFromHeight(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Hero(
          tag:
              "icon_${widget.deck.id}_${widget.section.id}_${widget.resource.id}",
          child: ResourceIconWidget(
            dimension: iconSize,
            borderRadius: borderRadius,
            companyId: widget.deck.companyId!,
            fileId: widget.resource.thumbnailFile!,
            progress: (context) => Center(
              child: PlatformCircularProgressIndicator(),
            ),
            error: (context) => const ResourceIconErrorWidget(),
          ),
        ),
        SizedBox(height: marginHeight),
        Container(
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(borderRadius: borderRadius),
            color: themeProvider.deckDetailsBackgroundColour,
          ),
          height: textHeight,
          width: iconSize,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Center(
              child: AutoSizeText(
                widget.resource.name,
                maxLines: 1,
                minFontSize: 8,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 20,
                  color: context.watch<ThemeProvider>().foregroundColour,
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: marginHeight),
      ],
    );
  }
}
