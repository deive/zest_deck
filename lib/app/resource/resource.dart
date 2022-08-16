import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:uuid/uuid.dart';
import 'package:zest/api/models/deck.dart';
import 'package:zest/app/resource/resource_icon_error.dart';
import 'package:zest/app/resource/resource_online.dart';

class ResourceWidget extends StatefulWidget {
  const ResourceWidget({
    Key? key,
    required this.deck,
    required this.resourceId,
    this.progress,
    this.error,
  }) : super(key: key);

  final Deck deck;
  final UuidValue resourceId;
  final Widget Function(BuildContext context)? progress;
  final Widget Function(BuildContext context)? error;

  @override
  State<StatefulWidget> createState() => ResourceWidgetState();
}

class ResourceWidgetState extends State<ResourceWidget> {
  @override
  Widget build(BuildContext context) {
    return ResourceWebOrLocalWidget(
      deck: widget.deck,
      resourceId: widget.resourceId,
      keepAspectRatio: true,
      progress: widget.progress,
      error: widget.error,
    );
  }
}

class ResourceWebOrLocalWidget extends StatefulWidget {
  const ResourceWebOrLocalWidget({
    Key? key,
    required this.deck,
    required this.resourceId,
    this.keepAspectRatio = false,
    this.progress,
    this.error,
  }) : super(key: key);

  final Deck deck;
  final UuidValue resourceId;
  final bool keepAspectRatio;
  final Widget Function(BuildContext context)? progress;
  final Widget Function(BuildContext context)? error;

  @override
  State<StatefulWidget> createState() => ResourceWebOrLocalWidgetState();
}

class ResourceWebOrLocalWidgetState extends State<ResourceWebOrLocalWidget> {
  @override
  Widget build(BuildContext context) {
    return kIsWeb
        ? ResourceOnlineWidget(
            deck: widget.deck,
            fileId: widget.resourceId,
            keepAspectRatio: widget.keepAspectRatio,
            progress: widget.progress,
            error: widget.error,
          )
        : widget.error != null
            ? widget.error!(context)
            : const ResourceIconErrorWidget();
  }
}
