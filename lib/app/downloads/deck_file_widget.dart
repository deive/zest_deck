import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:zest_deck/app/downloads/deck_file_download.dart';
import 'package:zest_deck/app/downloads/decks_download_provider.dart';

class DeckFileWidget extends StatefulWidget {
  const DeckFileWidget(
      {Key? key,
      required this.fileDownloader,
      required this.width,
      required this.height})
      : super(key: key);

  final Future<DeckFileDownloader> fileDownloader;
  final double width;
  final double height;

  @override
  State<StatefulWidget> createState() => DeckFileWidgetState();
}

class DeckFileWidgetState extends State<DeckFileWidget> {
  @override
  Widget build(BuildContext context) => FutureBuilder(
      future: widget.fileDownloader,
      builder: (context, AsyncSnapshot<DeckFileDownloader> snapshot) =>
          snapshot.hasData
              ? _forDownload(snapshot.data!)
              : _waitingForDownload());

  Widget _forDownload(DeckFileDownloader dl) {
    dl.addListener(() {
      setState(() {});
    });
    final isDownloading = dl.download.status != DownloadStatus.downloaded;
    return AnimatedSwitcher(
        child: isDownloading
            ? _waitingForDownload()
            : Image.file(
                dl.downloadedFile!,
                width: widget.width,
                height: widget.height,
                fit: BoxFit.cover,
              ),
        duration: const Duration(seconds: 1));
  }

  Widget _waitingForDownload() =>
      Center(child: PlatformCircularProgressIndicator());
}