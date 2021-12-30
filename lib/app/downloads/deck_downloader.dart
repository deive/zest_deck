import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';
import 'package:zest_deck/app/decks/deck.dart';
import 'package:zest_deck/app/downloads/deck_download.dart';
import 'package:zest_deck/app/downloads/deck_file_downloader.dart';
import 'package:zest_deck/app/downloads/decks_download_provider.dart';

class DeckDownloader with ChangeNotifier {
  DeckDownload get download => _download;
  bool get hasAuthFail => _fileDownloads.any((element) => element.hasAuthFail);

  final DecksDownloadProvider _downloads;
  final Box<DeckDownload> _data;
  final String _dataId;
  DeckDownload _download;
  List<DeckFileDownloader> _fileDownloads = [];

  DeckDownloader(this._downloads, this._data, this._dataId, this._download);

  start() async {}

  bool matches(Deck deck) =>
      _download.companyId == deck.companyId && _download.deckId == deck.id;
}


  // Could be used to download a single resource.
  // List<DeckFileDownloader>? getContentDownloads(Deck deck, Resource resource) =>
  //     resource.files[ResourceFileType.imageContent]
  //         ?.map((fileId) =>
  //             deck.files.singleWhere((element) => element.id == fileId))
  //         .map((file) => _getOrCreateDownload(deck, file))
  //         .toList();

  // Could be used to download a single deck.
  // List<DeckFileDownloader> ensureDeckDownloaded(Deck deck) {
  //   final thumbnails =
  //       deck.resources.map((e) => e.thumbnailFile).filterNotNull();
  //   final resources = deck.resources
  //       .map((resource) => resource.files[ResourceFileType.imageContent])
  //       .where((fileIds) => fileIds != null)
  //       .expand((fileIds) => fileIds!);

  //   return [thumbnails, resources]
  //       .expand((element) => element)
  //       .toSet()
  //       .map((fileId) =>
  //           deck.files.singleWhere((element) => element.id == fileId))
  //       .map((file) => _getOrCreateDownload(deck, file))
  //       .toList();
  // }