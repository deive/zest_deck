import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';
import 'package:zest_deck/app/api/api_provider.dart';
import 'package:zest_deck/app/app_provider.dart';
import 'package:zest_deck/app/decks/deck.dart';
import 'package:zest_deck/app/decks/decks_provider.dart';
import 'package:zest_deck/app/downloads/deck_download.dart';
import 'package:zest_deck/app/downloads/deck_downloader.dart';
import 'package:zest_deck/app/downloads/deck_file_download.dart';
import 'package:zest_deck/app/downloads/deck_file_downloader.dart';
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
  static const _deckDownloadBox = 'deckDownloads';
  Box<DeckDownload>? _deckDownloadData;

  List<DeckFileDownloader> _downloads = [];
  List<DeckDownloader> _deckDownloads = [];
  final http.Client _client = http.Client();

  Future<DeckFileDownloader> getThumbnailDownload(
          Deck deck, Resource resource) async =>
      _getOrCreateDownload(
          deck,
          deck.files
              .singleWhere((element) => element.id == resource.thumbnailFile));

  Future<DeckFileDownloader> getFileDownload(
          Deck deck, UuidValue fileId) async =>
      _getOrCreateDownload(
          deck, deck.files.singleWhere((element) => element.id == fileId));

  Future<DeckDownloader> getDeckDownload(Deck deck, UuidValue fileId) async =>
      _getOrCreateDeckDownload(deck);

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
        path: await getDataDirectory());
    _deckDownloadData = await Hive.openBox<DeckDownload>(_deckDownloadBox,
        path: await getDataDirectory());

    _downloads = _downloadData!.keys.map((e) {
      var data = _downloadData!.get(e)!;
      if (data.status == DownloadStatus.downloading) {
        // Re-download on next use as this didn't complete
        data = data.copyWith(status: DownloadStatus.requested);
      } else if (data.status == DownloadStatus.downloaded) {
        // Re-validate on next use after app restart
        data = data.copyWith(status: DownloadStatus.validating);
      }
      return DeckFileDownloader(user, decks, _client, _downloadData!, e, data)
        ..start();
    }).toList();
    onDecksUpdated();

    _deckDownloads = _deckDownloadData!.keys.map((e) {
      var data = _deckDownloadData!.get(e)!;
      if (data.status == DeckDownloadStatus.downloading) {
        // Re-download on next use as this didn't complete
        data = data.copyWith(status: DeckDownloadStatus.requested);
      } else if (data.status == DeckDownloadStatus.downloaded) {
        // Re-validate on next use after app restart
        data = data.copyWith(status: DeckDownloadStatus.validating);
      }
      return DeckDownloader(this, _deckDownloadData!, e, data)..start();
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
    for (var element in _downloads) {
      element.start();
    }
  }

  @override
  void onLostAuthToken() {
    // TODO: Stop all current downloads
  }

  @override
  void onDecksUpdated() {
    decks.decks?.forEach((element) {
      if (element.thumbnailFile != null) {
        getFileDownload(element, element.thumbnailFile!);
      }
    });
  }

  Future<DeckFileDownloader> _getOrCreateDownload(
      Deck deck, ResourceFile file) async {
    await _ensureDownloadBoxOpen();
    DeckFileDownloader downloader;
    try {
      downloader =
          _downloads.firstWhere((element) => element.matches(deck, file));
    } on StateError {
      final dataId = const Uuid().v4();
      downloader = DeckFileDownloader(user, decks, _client, _downloadData!,
          dataId, DeckFileDownload.newFor(deck, file));
      _downloads.add(downloader);
      _downloadData!.put(dataId, downloader.download);
      downloader.start();
    }
    return downloader;
  }

  Future<DeckDownloader> _getOrCreateDeckDownload(Deck deck) async {
    await _ensureDeckDownloadBoxOpen();
    DeckDownloader downloader;
    try {
      downloader =
          _deckDownloads.firstWhere((element) => element.matches(deck));
    } on StateError {
      final dataId = const Uuid().v4();
      downloader = DeckDownloader(
          this, _deckDownloadData!, dataId, DeckDownload.newFor(deck));
      _deckDownloads.add(downloader);
      _deckDownloadData!.put(dataId, downloader.download);
      downloader.start();
    }
    return downloader;
  }

  _ensureDownloadBoxOpen() async {
    while (_downloadData == null) {
      await Future.delayed(const Duration(milliseconds: 100));
    }
  }

  _ensureDeckDownloadBoxOpen() async {
    while (_deckDownloadData == null) {
      await Future.delayed(const Duration(milliseconds: 100));
    }
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
