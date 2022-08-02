import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:zest/api/models/deck.dart';
import 'package:zest/api/models/resource.dart';
import 'package:zest/api/models/section.dart';
import 'package:zest/app/main/theme_provider.dart';

class ResourceIconWidget extends StatefulWidget {
  const ResourceIconWidget({
    Key? key,
    this.dimension,
    this.borderRadius,
    this.deck,
    this.section,
    this.resource,
  }) : super(key: key);

  final double? dimension;
  final BorderRadius? borderRadius;
  final Deck? deck;
  final Section? section;
  final Resource? resource;

  @override
  State<StatefulWidget> createState() => ResourceIconWidgetState();
}

class ResourceIconWidgetState extends State<ResourceIconWidget> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    return SizedBox.square(
      dimension: widget.dimension,
      child: ClipRRect(
        borderRadius: widget.borderRadius,
        child: Container(
          color: themeProvider.deckIconBackgroundColour,
          child: FractionallySizedBox(
            heightFactor: 0.6,
            widthFactor: 0.6,
            child: FittedBox(
              child: Icon(
                CupertinoIcons.photo,
                color: themeProvider.deckDetailsBackgroundColour,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
