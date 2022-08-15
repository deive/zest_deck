import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import "package:universal_html/html.dart" as html;
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:zest/api/models/deck.dart';
import 'package:zest/app/deck_list/deck_list_provider.dart';
import 'package:zest/app/resource/resource_icon_error.dart';

class ResourceIconOnlineWidget extends StatefulWidget {
  const ResourceIconOnlineWidget({
    Key? key,
    required this.deck,
    required this.fileId,
    this.progress,
    this.error,
  }) : super(key: key);

  final Deck deck;
  final UuidValue fileId;
  final Widget Function(BuildContext context)? progress;
  final Widget Function(BuildContext context)? error;

  @override
  State<StatefulWidget> createState() => ResourceIconOnlineWidgetState();
}

class ResourceIconOnlineWidgetState extends State<ResourceIconOnlineWidget> {
  String? _url;
  bool _disposed = false;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  @override
  Widget build(BuildContext context) {
    return _url == null
        ? Center(
            child: widget.progress != null
                ? widget.progress!(context)
                : PlatformCircularProgressIndicator())
        : Image.network(
            _url!,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return widget.error != null
                  ? widget.error!(context)
                  : const ResourceIconErrorWidget();
            },
          );
  }

  @override
  void dispose() {
    _disposed = true;
    if (_url != null) html.Url.revokeObjectUrl(_url!);
    super.dispose();
  }

  _loadImage() async {
    final decks = context.read<DeckListProvider>();
    final url = decks.fileStorePath(widget.deck.companyId!, widget.fileId);
    final res =
        await http.get(Uri.parse(url), headers: decks.fileStoreHeaders());
    final blob = html.Blob([res.bodyBytes]);
    if (!_disposed) {
      setState(() {
        _url = html.Url.createObjectUrlFromBlob(blob);
      });
    }
  }
}
