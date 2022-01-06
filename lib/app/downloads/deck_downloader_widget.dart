import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:zest_deck/app/downloads/deck_download.dart';
import 'package:zest_deck/app/downloads/deck_downloader.dart';

class DeckDownloaderWidget extends StatefulWidget {
  const DeckDownloaderWidget({Key? key, required this.deckDownloader})
      : super(key: key);

  final Future<DeckDownloader> deckDownloader;

  @override
  State<StatefulWidget> createState() => DeckDownloaderWidgetState();
}

class DeckDownloaderWidgetState extends State<DeckDownloaderWidget> {
  DeckDownloader? download;

  @override
  Widget build(BuildContext context) => FutureBuilder(
      future: widget.deckDownloader,
      builder: (context, AsyncSnapshot<DeckDownloader> snapshot) =>
          snapshot.hasData ? _forDeck(snapshot.data!) : _progress());

  Widget _forDeck(DeckDownloader dl) {
    dl.addListener(_onDownloadUpdate);
    download = dl;
    return AnimatedSwitcher(
        child: dl.download.status == DeckDownloadStatus.notRequested
            ? _download()
            : dl.download.status == DeckDownloadStatus.error
                ? dl.hasAuthFail
                    ? _authFail()
                    : _error()
                : dl.download.status == DeckDownloadStatus.downloaded
                    ? _downloaded()
                    : dl.download.status == DeckDownloadStatus.downloading
                        ? _downloading()
                        : _progress(),
        // TODO: Update state
        duration: const Duration(seconds: 1));
  }

  @override
  void dispose() {
    download?.removeListener(_onDownloadUpdate);
    super.dispose();
  }

  _onDownloadUpdate() => setState(() {});

  Widget _download() => Icon(PlatformIcons(context).downArrow);
  Widget _downloaded() => Icon(PlatformIcons(context).checkMark);
  Widget _progress() => PlatformCircularProgressIndicator();
  Widget _downloading() => FittedBox(
      fit: BoxFit.scaleDown,
      child: Text("${download!.numDownloaded}/${download!.numDownloads}"));
  Widget _authFail() => Icon(PlatformIcons(context).padLock);
  Widget _error() => Center(
        child: FractionallySizedBox(
          widthFactor: 0.9,
          heightFactor: 0.9,
          child: Image.asset(
            "assets/logos/zest_icon.png",
            fit: BoxFit.contain,
            color: Colors.grey,
            colorBlendMode: BlendMode.srcATop,
          ),
        ),
      );
}
