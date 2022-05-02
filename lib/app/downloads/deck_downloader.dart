import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
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
  List<DeckFileDownloader>? _thumbnailDownloads;
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

  void ensureAutoStart() {
    if (!_download.autoStart) {
      _download = _download.copyWith(autoStart: true);
      _data.put(_dataId, _download);
    }
  }

  bool matches(Deck deck) =>
      _download.companyId == deck.companyId && _download.deckId == deck.id;

  _doDownload() async {
    _download =
        _download.copyWith(status: DeckDownloadStatus.downloadingThumbnails);
    _onDownloadUpdate();
    await _loadFileDownloads();
    await Future.forEach(_thumbnailDownloads!, _startThumbnail);

    _download = _download.copyWith(status: DeckDownloadStatus.downloading);
    _onDownloadUpdate();
    await Future.forEach(_fileDownloads!, _start);

    final thumbnailErrors = _thumbnailDownloads!
        .any((element) => element.download.status != DownloadStatus.downloaded);
    final fileErrors = _fileDownloads!
        .any((element) => element.download.status != DownloadStatus.downloaded);
    if (thumbnailErrors || fileErrors) {
      _download = _download.copyWith(status: DeckDownloadStatus.error);
    } else {
      _download = _download.copyWith(status: DeckDownloadStatus.downloaded);
    }
    _onDownloadUpdate();
  }

  _startThumbnail(DeckFileDownloader downloader) async {
    if (_downloads.canStartDownload() &&
        downloader.download.status != DownloadStatus.downloaded) {
      if (!kReleaseMode) {
        log("Starting Thumbnail ${downloader.download.fileId}");
      }
      await downloader.start();
    }
  }

  _start(DeckFileDownloader downloader) async {
    if (_downloads.canStartDownload()) {
      if (!kReleaseMode) {
        log("Starting ${downloader.download.fileId}");
      }
      await downloader.start();
    } else if (downloader.download.status != DownloadStatus.downloaded) {
      // TODO: mark as prev has error or something....
    }
    notifyListeners();
  }

  _doValidate() async {
    await _loadFileDownloads();
    await Future.forEach(_thumbnailDownloads!, _validateDownload);
    await Future.forEach(_fileDownloads!, _validateDownload);

    final thumbnailsComplete = _thumbnailDownloads!
        .any((element) => element.download.status == DownloadStatus.downloaded);
    final filesComplete = _fileDownloads!
        .any((element) => element.download.status == DownloadStatus.downloaded);
    if (thumbnailsComplete && filesComplete) {
      _download = _download.copyWith(status: DeckDownloadStatus.downloaded);
    } else {
      _download =
          _download.copyWith(status: DeckDownloadStatus.downloadingThumbnails);
    }
    _onDownloadUpdate();
    if (_download.status == DeckDownloadStatus.downloadingThumbnails) {
      _doDownload();
    }
  }

  _validateDownload(DeckFileDownloader downloader) async {
    await downloader.validate();
  }

  _loadFileDownloads() async {
    if (_thumbnailDownloads == null) {
      _thumbnailDownloads = [];
      _fileDownloads = [];
      _loadFileDownload(
          _deck.resources.map((e) => e.thumbnailFile), _thumbnailDownloads!);
      _loadFileDownload(
          _deck.resources
              .map((resource) {
                return resource.type == ResourceType.image
                    ? resource.files[ResourceFileType.content]
                    : resource.files[ResourceFileType.imageContent];
              })
              .where((fileIds) => fileIds != null)
              .expand((fileIds) => fileIds!),
          _fileDownloads!,
          autoStart: false);
      notifyListeners();
    }
  }

  _loadFileDownload(
      Iterable<UuidValue?> fileIds, List<DeckFileDownloader> toList,
      {bool autoStart = true}) {
    fileIds
        .filterNotNull()
        .toSet()
        .map((fileId) =>
            _deck.files.singleWhere((element) => element.id == fileId))
        .forEach((element) async {
      final dl =
          await _downloads.getDownload(_deck, element, autoStart: autoStart);
      if (dl != null) {
        toList.add(dl);
      }
    });
  }

  void _onDownloadUpdate() {
    notifyListeners();
    _data.put(_dataId, _download);
  }
}
