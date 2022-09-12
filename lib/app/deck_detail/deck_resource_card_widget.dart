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

class DeckResourceCardWidget extends StatefulWidget {
  const DeckResourceCardWidget(
      {Key? key,
      required this.deck,
      required this.section,
      required this.resource})
      : super(key: key);

  final Deck deck;
  final Section section;
  final Resource resource;

  @override
  State<StatefulWidget> createState() => DeckResourceCardWidgetState();
}

class DeckResourceCardWidgetState extends State<DeckResourceCardWidget> {
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final borderRadius = mediaQuery.size.height / 70;
    final themeProvider = context.watch<ThemeProvider>();
    final mq = MediaQuery.of(context);
    final sectionType = widget.section.type;
    final iconSize = sectionType.getUIIconHeight(mq);
    final titleTextHeight = sectionType.getUITitleTextHeight(mq);
    final marginHeight = sectionType.getUIMarginFromHeight(mq);
    final textMarginHeight = sectionType.getUITextMarginFromHeight(mq);
    final width = iconSize + (marginHeight * 2);

    return Column(
      children: [
        Container(
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(borderRadius),
              ),
            ),
            color: themeProvider.deckIconBackgroundColour,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: marginHeight),
              Hero(
                tag:
                    "icon_${widget.deck.id}_${widget.section.id}_${widget.resource.id}",
                child: ResourceIconWidget(
                  dimension: iconSize,
                  borderRadius: BorderRadius.circular(borderRadius),
                  companyId: widget.deck.companyId!,
                  fileId: widget.resource.thumbnailFile!,
                  progress: (context) => Center(
                    child: PlatformCircularProgressIndicator(),
                  ),
                  error: (context) => const ResourceIconErrorWidget(),
                ),
              ),
              SizedBox(height: marginHeight),
              SizedBox(
                height: titleTextHeight,
                width: width,
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
                        color: context.watch<ThemeProvider>().backgroundColour,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: marginHeight),
            ],
          ),
        ),
        Container(
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(borderRadius),
              ),
            ),
            color: themeProvider.deckDetailsBackgroundColour,
          ),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            SizedBox(height: textMarginHeight),
            SizedBox(
              height: sectionType.getUICardDetailsTextHeight(mq),
              width: width,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: AutoSizeText(
                  widget.resource.description,
                  minFontSize: 8,
                  overflow: TextOverflow.fade,
                  style: TextStyle(
                    fontSize: 14,
                    color: context.watch<ThemeProvider>().backgroundColour,
                  ),
                ),
              ),
            ),
            SizedBox(height: textMarginHeight),
            if (sectionType == SectionType.cardFull)
              ..._details(sectionType, width, textMarginHeight),
          ]),
        ),
      ],
    );
  }

  List<Widget> _details(
          SectionType sectionType, double width, double marginHeight) =>
      [
        _detailsText(sectionType, width, "Type: ${widget.resource.type}"),
        _detailsText(
            sectionType, width, "Date: ${widget.resource.modifiedLongFormat}"),
        SizedBox(height: marginHeight),
      ];

  Widget _detailsText(SectionType sectionType, double width, String text) =>
      SizedBox(
        height: sectionType.getUICardMetadataTextHeight(MediaQuery.of(context)),
        width: width,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            text,
            maxLines: 1,
            style: TextStyle(
              fontSize: 10,
              color: context.watch<ThemeProvider>().backgroundColour,
            ),
          ),
        ),
      );
}
