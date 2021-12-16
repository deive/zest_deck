import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';
import 'package:zest_deck/app/api/api_provider.dart';
import 'package:zest_deck/app/app_provider.dart';
import 'package:zest_deck/app/decks/deck.dart';
import 'package:zest_deck/app/decks/decks_provider.dart';
import 'package:zest_deck/app/downloads/deck_file_download.dart';
import 'package:zest_deck/app/models/resource.dart';
import 'package:zest_deck/app/users/users_provider.dart';

class DecksDownloadProvider
    with
        ChangeNotifier,
        AppAndAPIProvider,
        UsersAndAPIProvider,
        DecksAndAPIProvider {
  static const _downloadBox = 'downloads';
  Box<DeckFileDownload>? _downloadData;

  List<DeckFileDownloader> _downloads = [];
  final http.Client _client = http.Client();

  Future<DeckFileDownloader> getThumbnailDownload(
      Deck deck, Resource resource) async {
    await _ensureBoxOpen();
    return _getOrCreateDownload(
        deck,
        deck.files
            .singleWhere((element) => element.id == resource.thumbnailFile));
  }

  Future<DeckFileDownloader> getFileDownload(
      Deck deck, UuidValue fileId) async {
    await _ensureBoxOpen();
    return _getOrCreateDownload(
        deck, deck.files.singleWhere((element) => element.id == fileId));
  }

  List<DeckFileDownloader>? getContentDownloads(Deck deck, Resource resource) =>
      resource.files[ResourceFileType.imageContent]
          ?.map((fileId) =>
              deck.files.singleWhere((element) => element.id == fileId))
          .map((file) => _getOrCreateDownload(deck, file))
          .toList();

  List<DeckFileDownloader> ensureDeckDownloaded(Deck deck) {
    final thumbnails =
        deck.resources.map((e) => e.thumbnailFile).filterNotNull();
    final resources = deck.resources
        .map((resource) => resource.files[ResourceFileType.imageContent])
        .where((fileIds) => fileIds != null)
        .expand((fileIds) => fileIds!);

    return [thumbnails, resources]
        .expand((element) => element)
        .toSet()
        .map((fileId) =>
            deck.files.singleWhere((element) => element.id == fileId))
        .map((file) => _getOrCreateDownload(deck, file))
        .toList();
  }

  DecksDownloadProvider onUpdate(AppProvider app, APIProvider api,
      UsersProvider user, DecksProvider deck) {
    onDeckProviderUpdate(app, api, user, deck);
    return this;
  }

  init() async {
    Hive.registerAdapter(DeckFileDownloadAdapter());
    Hive.registerAdapter(DownloadStatusAdapter());
  }

  @override
  void onLogin() async {
    _downloadData = await Hive.openBox<DeckFileDownload>(_downloadBox,
        path: await decks.getDataDirectory());

    _downloads = _downloadData!.keys.map((e) {
      final data = _downloadData!.get(e)!;
      if (data.status == DownloadStatus.downloading) {
        // Re-download on next use as this didn't complete
        return DeckFileDownloader(decks, _client, _downloadData!, e,
            data.copyWith(status: DownloadStatus.requested))
          ..start();
      } else if (data.status == DownloadStatus.downloaded) {
        // Re-validate on next use after app restart
        return DeckFileDownloader(decks, _client, _downloadData!, e,
            data.copyWith(status: DownloadStatus.validating))
          ..start();
      } else {
        return DeckFileDownloader(decks, _client, _downloadData!, e, data)
          ..start();
      }
    }).toList();
  }

  @override
  void onLogout() {
    _downloadData?.compact();
    _downloadData?.close();
    _downloads = [];
  }

  @override
  void onRecievedAuthToken() {
    // TODO: Start all wanted downloads
  }

  @override
  void onLostAuthToken() {
    // TODO: Stop all current downloads
  }

  DeckFileDownloader _getOrCreateDownload(Deck deck, ResourceFile file) {
    DeckFileDownloader downloader;
    try {
      downloader =
          _downloads.firstWhere((element) => element.matches(deck, file));
    } on StateError {
      final dataId = const Uuid().v4();
      downloader = DeckFileDownloader(decks, _client, _downloadData!, dataId,
          DeckFileDownload.newFor(deck, file));
      _downloads.add(downloader);
      _downloadData!.put(dataId, downloader._download);
      downloader.start();
    }
    return downloader;
  }

  _ensureBoxOpen() async {
    while (_downloadData == null) {
      await Future.delayed(const Duration(milliseconds: 100));
    }
  }
}

class DeckFileDownloader with ChangeNotifier {
  DeckFileDownload get download => _download;
  File? get downloadedFile => _downloadedFile;

  final DecksProvider _decks;
  final http.Client _client;
  final Box<DeckFileDownload> _data;
  final String _dataId;
  DeckFileDownload _download;
  late File _downloadedFile;

  DeckFileDownloader(
      this._decks, this._client, this._data, this._dataId, this._download);

  start() async {
    _downloadedFile = File(
        "${await _decks.getDataDirectory()}/${_download.companyId}/${_download.fileId}");

    if (_download.status == DownloadStatus.validating) {
      _doValidate();
    } else if (_download.status != DownloadStatus.downloaded) {
      _doDownload();
    }
  }

  bool matches(Deck deck, ResourceFile file) =>
      _download.companyId == deck.companyId && _download.fileId == file.id;

  _doDownload() async {
    _download = _download.copyWith(status: DownloadStatus.downloading);
    _onDownloadUpdate();

    await _downloadedFile.create(recursive: true);
    final url = _decks.fileStorePath(_download.companyId, _download.fileId);
    final headers = _decks.fileStoreHeaders();
    if (!kReleaseMode) log("Download starting: $url");

    final res = await _client.readBytes(Uri.parse(url), headers: headers);
    await _downloadedFile.writeAsBytes(res);
    if (!kReleaseMode) log("Download complete: ${_downloadedFile.path}");

    _download = _download.copyWith(status: DownloadStatus.downloaded);
    _downloadedFile = _downloadedFile;
    _onDownloadUpdate();
  }

  _doValidate() async {
    if (await _downloadedFile.exists()) {
      // Later, we could also do some checksumming?
      _download = _download.copyWith(status: DownloadStatus.downloaded);
    } else {
      _download = _download.copyWith(status: DownloadStatus.requested);
    }
    _onDownloadUpdate();
    if (_download.status != DownloadStatus.downloaded) {
      _doDownload();
    }
  }

  _onDownloadUpdate() {
    notifyListeners();
    _data.put(_dataId, _download);
  }
}

extension FilterNotNull<T> on Iterable<T?> {
  /// Given an Iterable on a nullable type T?, filters out
  /// any null elements and cast the resulting Iterable to
  /// Iterable<T>.
  Iterable<T> filterNotNull() {
    return where((e) => e != null).cast();
  }
}
