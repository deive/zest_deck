import 'package:flutter/widgets.dart';
import "package:universal_html/html.dart" as html;
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:zest/app/deck_list/deck_list_provider.dart';

/// Shows a file by using the browser to download.
class OnlineFileWidget extends StatefulWidget {
  const OnlineFileWidget({
    Key? key,
    required this.companyId,
    required this.fileId,
    required this.fit,
    required this.progress,
    required this.error,
  }) : super(key: key);

  final UuidValue companyId;
  final UuidValue fileId;

  final BoxFit fit;
  final Widget Function(BuildContext context) progress;
  final Widget Function(BuildContext context) error;

  @override
  State<StatefulWidget> createState() => OnlineFileWidgetState();
}

class OnlineFileWidgetState extends State<OnlineFileWidget> {
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
        ? widget.progress(context)
        : Image.network(
            _url!,
            fit: widget.fit,
            errorBuilder: (context, error, stackTrace) {
              return widget.error(context);
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
    final url = decks.fileStorePath(widget.companyId, widget.fileId);
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
