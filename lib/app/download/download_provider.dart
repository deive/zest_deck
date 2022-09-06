import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import 'package:zest/app/download/file_download.dart';
import 'package:zest/app/main/auth_provider.dart';
import 'package:zest/app/shared/provider.dart';

class DownloadProvider with ChangeNotifier, Disposable {
  DownloadProvider(
    this._auth,
    DownloadProvider? previous,
  ) {
    if (previous?._initComplete != true) {
      _init();
    } else {
      _downloadData = previous!._downloadData;
      _initComplete = true;
    }
  }

  bool get initComplete => _initComplete;
  String? get authToken => _auth?.loginData?.authToken;
  bool? get isCurrentUserAPISessionValid => _auth?.isCurrentUserAPISessionValid;

  final AuthProvider? _auth;
  bool _initComplete = false;

  static const _downloadBox = 'download';
  Box<FileDownload>? _downloadData;

  /// Add/gets requested file download request.
  Future<FileDownload?> downloadRequest(
    UuidValue companyId,
    UuidValue fileId,
    FileDownloadRequest request,
  ) async {
    final boxKey = "$companyId:$fileId";
    final currentDownload = _downloadData!.get(boxKey);

    if (currentDownload == null) {
      final newDownload = FileDownload.request(companyId, fileId, request);
      await _downloadData!.put(boxKey, newDownload);
      return newDownload;
    } else {
      final currentRequest = _find(currentDownload.requests, request);
      if (currentRequest == null) {
        final updatedDownload = currentDownload.addRequest(request);
        await _downloadData!.put(boxKey, updatedDownload);
      }
      return currentDownload;
    }
  }

  FileDownloadRequest? _find(
    List<FileDownloadRequest> from,
    FileDownloadRequest request,
  ) {
    try {
      return from.firstWhere((r) => r == request);
    } catch (_) {
      return null;
    }
  }

  // /// Ensures all outer files are downloaded for the given deck.
  // /// E.g. The main deck icon.
  // Future<void> ensureDeckOuter(Deck deck) async {}

  // /// Ensures all inner files are downloaded for the given deck.
  // /// E.g. The icons for all resources in sections.
  // Future<void> ensureDeckInner(Deck deck) async {}

  // /// Ensures all files are downloaded for the given deck.
  // Future<void> ensureDeck(Deck deck) async {}

  // /// Ensures the given file for the given resource is downloaded,
  // /// as the user is viewing.
  // Future<FileDownload> ensureViewable(
  //         Deck deck, Resource resource, UuidValue file) async =>
  //     await _ensureFile(deck, resource, file, DownloadRequestType.userView);

  // /// Ensures the given file for the given resource is downloaded,
  // /// as the user has favorited.
  // Future<FileDownload> ensureFavorite(
  //         Deck deck, Resource resource, UuidValue file) async =>
  //     await _ensureFile(deck, resource, file, DownloadRequestType.userFavorite);

  // Future<FileDownload> _ensureFile(Deck deck, Resource resource, UuidValue file,
  //     DownloadRequestType type) async {
  //   final id = "${deck.id}$file";
  //   final request = FileDownloadRequest(type, deck.id, resource.id);
  //   var d = _downloadData!.get(id);
  //   if (d == null) {
  //     d = FileDownload.newFor(deck.companyId!, file, request);
  //   } else {
  //     d = d.addRequest(request);
  //   }
  //   appDownloader.download(d);
  //   return d;
  // }

  Future<void> _init() async {
    if (_auth != null) {
      final dir = await _auth!.getDataDirectory();
      if (dir != null) {
        _downloadData = await Hive.openBox<FileDownload>(
          _downloadBox,
          path: dir,
        );
        _initComplete = true;
        notifyListenersIfNotDisposed();
      }
    }
  }
}
