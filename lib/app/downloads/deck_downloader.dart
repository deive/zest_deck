import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';
import 'package:zest_deck/app/decks/deck.dart';
import 'package:zest_deck/app/decks/decks_provider.dart';
import 'package:zest_deck/app/downloads/deck_download.dart';
import 'package:zest_deck/app/downloads/deck_file_download.dart';
import 'package:zest_deck/app/downloads/deck_file_downloader.dart';
import 'package:zest_deck/app/downloads/decks_download_provider.dart';
import 'package:zest_deck/app/models/resource.dart';

class DeckDownloader with ChangeNotifier {
  DeckDownload get download => _download;
  bool get hasAuthFail => _fileDownloads == null
      ? false
      : _fileDownloads!.any((element) => element.hasAuthFail);
  int get numDownloads => _fileDownloads == null ? 0 : _fileDownloads!.length;
  int get numDownloaded => _fileDownloads == null
      ? 0
      : _fileDownloads!
          .where(
              (element) => element.download.status == DownloadStatus.downloaded)
          .length;

  final DecksDownloadProvider _downloads;
  final DecksProvider _decks;
  final Box<DeckDownload> _data;
  final String _dataId;
  DeckDownload _download;
  List<DeckFileDownloader>? _fileDownloads;
  bool _started = false;
  late Deck _deck;

  DeckDownloader(
      this._downloads, this._decks, this._data, this._dataId, this._download);

  start() async {
    if (!_started) {
      _started = true;
      _deck = _decks.decks!
          .singleWhere((element) => element.id == _download.deckId);
      if (_download.status == DeckDownloadStatus.validating) {
        _doValidate();
      } else if (_download.status != DeckDownloadStatus.downloaded) {
        _doDownload();
      }
    }
  }

  bool matches(Deck deck) =>
      _download.companyId == deck.companyId && _download.deckId == deck.id;

  _doDownload() async {
    _download = _download.copyWith(status: DeckDownloadStatus.downloading);
    _onDownloadUpdate();

    await _loadFileDownloads();
    _fileDownloads!.forEach((element) async {
      log("Starting ${element.download.fileId}");
      await element.start();
      notifyListeners();
    });

    if (_fileDownloads!
        .any((element) => element.download.status == DownloadStatus.error)) {
      _download = _download.copyWith(status: DeckDownloadStatus.error);
    } else {
      _download = _download.copyWith(status: DeckDownloadStatus.downloaded);
    }
    _onDownloadUpdate();
  }

  _doValidate() async {
    await _loadFileDownloads();
    // if (await _downloadedFile.exists()) {
    //   // Later, we could also do some checksumming?
    //   _download = _download.copyWith(status: DownloadStatus.downloaded);
    // } else {
    //   _download = _download.copyWith(status: DownloadStatus.requested);
    // }
    // TODO: Validate all downloads.
    _onDownloadUpdate();
    if (_download.status != DeckDownloadStatus.downloaded) {
      _doDownload();
    }
  }

  _loadFileDownloads() async {
    if (_fileDownloads == null) {
      _fileDownloads = [];
      _allDeckFiles().forEach((element) async {
        final dl = await _downloads.getDownload(_deck, element);
        _fileDownloads!.add(dl);
        // dl.addListener(_onFileDownloadUpdate);
      });
      notifyListeners();
    }
  }

  List<ResourceFile> _allDeckFiles() {
    final thumbnails =
        _deck.resources.map((e) => e.thumbnailFile).filterNotNull();
    final resources = _deck.resources
        .map((resource) {
          return resource.type == ResourceType.image
              ? resource.files[ResourceFileType.content]
              : resource.files[ResourceFileType.imageContent];
        })
        .where((fileIds) => fileIds != null)
        .expand((fileIds) => fileIds!);

    return [thumbnails, resources]
        .expand((element) => element)
        .toSet()
        .map((fileId) =>
            _deck.files.singleWhere((element) => element.id == fileId))
        .toList();
  }

  _onDownloadUpdate() {
    notifyListeners();
    _data.put(_dataId, _download);
  }
}
