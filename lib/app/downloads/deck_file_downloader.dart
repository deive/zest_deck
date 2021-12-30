import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:zest_deck/app/decks/deck.dart';
import 'package:zest_deck/app/decks/decks_provider.dart';
import 'package:zest_deck/app/downloads/deck_file_download.dart';
import 'package:zest_deck/app/models/resource.dart';
import 'package:zest_deck/app/users/users_provider.dart';

class DeckFileDownloader with ChangeNotifier {
  DeckFileDownload get download => _download;
  File? get downloadedFile => _downloadedFile;
  bool get hasAuthFail => _hasAuthFail;

  final UsersProvider _users;
  final DecksProvider _decks;
  final http.Client _client;
  final Box<DeckFileDownload> _data;
  final String _dataId;
  DeckFileDownload _download;
  late File _downloadedFile;
  bool _hasAuthFail = false;
  bool _started = false;

  DeckFileDownloader(this._users, this._decks, this._client, this._data,
      this._dataId, this._download);

  start() async {
    if (!_started) {
      _started = true;
      _downloadedFile = File(
          "${await _users.getDataDirectory()}/${_download.companyId}/${_download.fileId}");

      if (_download.status == DownloadStatus.validating) {
        _doValidate();
      } else if (_download.status != DownloadStatus.downloaded) {
        _doDownload();
      }
    }
  }

  bool matches(Deck deck, ResourceFile file) =>
      _download.companyId == deck.companyId && _download.fileId == file.id;

  _doDownload() async {
    if (!kReleaseMode) log("Downloading: ${_downloadedFile.path}");
    _download = _download.copyWith(status: DownloadStatus.downloading);
    _onDownloadUpdate();

    final url = _decks.fileStorePath(_download.companyId, _download.fileId);
    try {
      await _downloadedFile.create(recursive: true);
      final headers = _decks.fileStoreHeaders();

      final res = await _client.readBytes(Uri.parse(url), headers: headers);
      await _downloadedFile.writeAsBytes(res);
      if (!kReleaseMode) log("Download complete: ${_downloadedFile.path}");

      _download = _download.copyWith(status: DownloadStatus.downloaded);
      _downloadedFile = _downloadedFile;
      _onDownloadUpdate();
    } catch (e) {
      await _downloadedFile.delete();
      _download = _download.copyWith(status: DownloadStatus.error);
      _onDownloadUpdate();
      _started = false;
      if (e is http.ClientException) {
        _hasAuthFail = true;
        _users.onAPI403();
      } else if (!kReleaseMode) {
        log("Error downloading file: $url", error: e);
      }
    }
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
