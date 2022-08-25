import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';
import 'package:zest/app/download/file_download.dart';

class Downloader {
  final http.Client _client = http.Client();
  final List<DownloadInfo> _downloads = [];
  DownloadInfo? currentDownload;

  Future<DownloadProgress> submit(
    FileDownload request,
    File downloadFile,
    File localFile,
    String authToken,
  ) async {
    final info = _get(request);
    if (info == null) {
      final newDownload = DownloadProgress(downloadFile, localFile);
      _downloads.add(DownloadInfo(request, newDownload));
      await _poke(authToken);
      return newDownload;
    } else {
      return info.second;
    }
  }

  _poke(String authToken) async {
    if (currentDownload == null && _downloads.isNotEmpty) {
      currentDownload = _downloads.removeAt(0);
      _startCurrentDownload(authToken);
    }
  }

  _startCurrentDownload(String authToken) async {
    final info = currentDownload!.first;
    final progress = currentDownload!.second;
    progress.setDownloading();

    final url = fileStorePath(info.companyId, info.fileId);
    final headers = fileStoreHeaders(authToken);
    final downloadFile = progress.downloadFile;
    bool tryNext = true;
    try {
      if (!kReleaseMode) log("Downloading: ${downloadFile.path}");
      await downloadFile.create(recursive: true);

      final res = await _client.readBytes(Uri.parse(url), headers: headers);
      await downloadFile.writeAsBytes(res);
      if (!kReleaseMode) log("Download complete: ${downloadFile.path}");

      downloadFile.rename(progress.localFile.path);
      progress.setDownloaded();
    } catch (e) {
      if (!kReleaseMode) log("Download error: ${downloadFile.path}", error: e);
      if (e is http.ClientException) {
        // TODO: Unauth error handling?
        tryNext = false;
      }
      progress.setError();
    }

    currentDownload = null;
    if (tryNext) {
      await _poke(authToken);
    }
  }

  fileStorePath(UuidValue companyId, UuidValue fileId) =>
      "https://dev.zestdeck.com/file-store/bucket/object?bucket=$companyId&object=$fileId";

  fileStoreHeaders(String authToken) => {"AuthToken": authToken};

  DownloadInfo? _get(FileDownload file) {
    try {
      return _downloads.firstWhere((d) => d.first == file);
    } catch (_) {
      return null;
    }
  }
}

enum DownloadState {
  waiting,
  downloading,
  error,
  downloaded,
}

class DownloadProgress with ChangeNotifier {
  final File downloadFile;
  final File localFile;

  DownloadProgress(this.downloadFile, this.localFile);

  DownloadState get state => _state;
  DownloadState _state = DownloadState.waiting;

  setDownloading() => _setState(DownloadState.downloading);
  setDownloaded() => _setState(DownloadState.downloaded);
  setError() => _setState(DownloadState.error);

  _setState(DownloadState newState) {
    _state = newState;
    notifyListeners();
  }
}

class DownloadInfo extends PairKeyEquals<FileDownload, DownloadProgress> {
  DownloadInfo(super.first, super.second);
}

class PairKeyEquals<T1, T2> {
  final T1 first;
  final T2 second;
  PairKeyEquals(this.first, this.second);

  @override
  bool operator ==(final Object other) {
    return other is PairKeyEquals &&
        other.runtimeType == runtimeType &&
        first == other.first;
  }

  @override
  int get hashCode => first.hashCode;
}
