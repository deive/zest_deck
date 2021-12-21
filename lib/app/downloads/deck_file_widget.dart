import 'package:flutter/widgets.dart';
import 'package:zest_deck/app/downloads/deck_file_download.dart';
import 'package:zest_deck/app/downloads/deck_file_downloading_widget.dart';
import 'package:zest_deck/app/downloads/deck_file_error_widget.dart';
import 'package:zest_deck/app/downloads/decks_download_provider.dart';

class DeckFileWidget extends StatefulWidget {
  const DeckFileWidget(
      {Key? key,
      required this.fileDownloader,
      required this.width,
      required this.height,
      this.fit = BoxFit.cover})
      : super(key: key);

  final Future<DeckFileDownloader> fileDownloader;
  final double width;
  final double height;
  final BoxFit fit;

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
              : const DeckFileDownloadingWidget());

  Widget _forDownload(DeckFileDownloader dl) {
    dl.addListener(() {
      setState(() {});
    });
    final isDownloading = dl.download.status != DownloadStatus.downloaded;
    final isError = dl.download.status == DownloadStatus.error;
    return AnimatedSwitcher(
        child: isDownloading
            ? isError
                ? DeckFileErrorWidget(
                    downloader: dl,
                    width: widget.width,
                    height: widget.height,
                  )
                : const DeckFileDownloadingWidget()
            : Image.file(
                dl.downloadedFile!,
                width: widget.width,
                height: widget.height,
                fit: widget.fit,
              ),
        duration: const Duration(seconds: 1));
  }
}
