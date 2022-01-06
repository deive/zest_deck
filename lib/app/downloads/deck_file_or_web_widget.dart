import "package:universal_html/html.dart" as html;
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:zest_deck/app/decks/decks_provider.dart';
import 'package:zest_deck/app/downloads/deck_file_downloader.dart';
import 'package:zest_deck/app/downloads/deck_file_downloading_widget.dart';
import 'package:zest_deck/app/downloads/deck_file_error_widget.dart';
import 'package:zest_deck/app/downloads/deck_file_widget.dart';

class DeckFileOrWebWidget extends StatefulWidget {
  const DeckFileOrWebWidget(
      {Key? key,
      required this.downloadBuilder,
      required this.urlBuilder,
      required this.width,
      required this.height,
      this.fit = BoxFit.cover})
      : super(key: key);

  final Future<DeckFileDownloader> Function() downloadBuilder;
  final String Function() urlBuilder;
  final double width;
  final double height;
  final BoxFit fit;

  @override
  State<StatefulWidget> createState() => DeckFileOrWebWidgetState();
}

class DeckFileOrWebWidgetState extends State<DeckFileOrWebWidget> {
  String? _url;
  bool _disposed = false;

  @override
  void initState() {
    super.initState();
    if (kIsWeb) {
      _loadImage();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      if (_url == null) {
        return const DeckFileDownloadingWidget();
      } else {
        return Image.network(
          _url!,
          width: widget.width,
          height: widget.height,
          fit: widget.fit,
          errorBuilder: (context, error, stackTrace) {
            return DeckFileErrorWidget(
              width: widget.width,
              height: widget.height,
            );
          },
        );
      }
    } else {
      return DeckFileWidget(
        fileDownloader: widget.downloadBuilder(),
        width: widget.width,
        height: widget.height,
        fit: widget.fit,
      );
    }
  }

  @override
  void dispose() {
    _disposed = true;
    if (_url != null) html.Url.revokeObjectUrl(_url!);
    super.dispose();
  }

  _loadImage() async {
    final decks = Provider.of<DecksProvider>(context, listen: false);
    final res = await http.get(Uri.parse(widget.urlBuilder()),
        headers: decks.fileStoreHeaders());
    final blob = html.Blob([res.bodyBytes]);
    if (!_disposed) {
      setState(() {
        _url = html.Url.createObjectUrlFromBlob(blob);
      });
    }
  }
}
