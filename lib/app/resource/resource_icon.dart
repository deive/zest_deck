import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:zest/api/models/deck.dart';
import 'package:zest/api/models/resource.dart';
import 'package:zest/api/models/section.dart';
import 'package:zest/app/main/theme_provider.dart';
import 'package:zest/app/resource/resource_icon_error.dart';
import 'package:zest/app/resource/resource_icon_online.dart';

class ResourceIconWidget extends StatefulWidget {
  const ResourceIconWidget({
    Key? key,
    required this.borderRadius,
    required this.deck,
    required this.resourceId,
    required this.dimension,
    this.section,
    this.resource,
  }) : super(key: key);

  final BorderRadius borderRadius;
  final Deck deck;
  final UuidValue resourceId;

  final double dimension;
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
          child: kIsWeb
              ? ResourceIconOnlineWidget(
                  deck: widget.deck,
                  fileId: widget.resourceId,
                )
              : const ResourceIconErrorWidget(),
        ),
      ),
    );
  }
}
