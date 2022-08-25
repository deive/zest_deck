import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import 'package:zest/app/app.dart';
import 'package:zest/app/app_provider.dart';
import 'package:zest/app/download/download_provider.dart';
import 'package:zest/app/download/downloader.dart';
import 'package:zest/app/download/file_download.dart';
import 'package:zest/app/shared/provider.dart';

class DownloadableFileProvider with ChangeNotifier, Disposable {
  DownloadableFileProvider(
    this.companyId,
    this.fileId,
    this.forRequest,
    this._app,
    this._downloadProvider,
    DownloadableFileProvider? previous,
  ) {
    if (previous?._initComplete != true) {
      _init();
    } else {
      _copyInit(previous!);
    }
  }

  final UuidValue companyId;
  final UuidValue fileId;
  final FileDownloadRequest forRequest;
  final AppProvider _app;
  final DownloadProvider? _downloadProvider;

  bool _initComplete = false;
  FileDownload? _fileDownload;
  bool _isDownloaded = false;
  DownloadProgress? _downloadProgress;
  late File _localFile;
  late File _downloadFile;

  _loadDownloadRequest() async {
    _fileDownload ??= await _downloadProvider!.downloadRequest(
      companyId,
      fileId,
      forRequest,
    );
    _isDownloaded = await _localFile.exists();
    await _downloadIfRequired();
  }

  _downloadIfRequired() async {
    if (!_isDownloaded && _fileDownload != null) {
      final authToken = _downloadProvider!.authToken;
      if (authToken != null &&
          _downloadProvider!.isCurrentUserAPISessionValid!) {
        _downloadProgress = await appDownloader.submit(
          _fileDownload!,
          _downloadFile,
          _localFile,
          authToken,
        );
        _downloadProgress?.addListener(notifyListenersIfNotDisposed);
      }
    }
  }

  Future<void> _init() async {
    if (!kIsWeb &&
        _downloadProvider != null &&
        _downloadProvider!.initComplete) {
      _localFile = File("${await _app.getHiveDirectory()}/$companyId/$fileId");
      _downloadFile = File("$_localFile.bak");
      await _loadDownloadRequest();
      _initComplete = true;
      notifyListenersIfNotDisposed();
    }
  }

  Future<void> _copyInit(DownloadableFileProvider previous) async {
    if (!kIsWeb &&
        _downloadProvider != null &&
        _downloadProvider!.initComplete) {
      _localFile = previous._localFile;
      _downloadFile = previous._downloadFile;
      _fileDownload = previous._fileDownload;
      _isDownloaded = previous._isDownloaded;

      if (_fileDownload == null) {
        await _loadDownloadRequest();
      } else {
        await _downloadIfRequired();
      }
      _initComplete = true;
      notifyListenersIfNotDisposed();
    }
  }

  @override
  void dispose() {
    _downloadProgress?.removeListener(notifyListenersIfNotDisposed);
    super.dispose();
  }
}
