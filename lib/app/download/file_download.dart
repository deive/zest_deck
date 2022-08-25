import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import 'package:zest/app/app_provider.dart';

part 'file_download.g.dart';

/// A file that is to be or has already been downloaded.
@HiveType(typeId: HiveDataType.fileDownload)
class FileDownload {
  @HiveField(0)
  final UuidValue companyId;
  @HiveField(1)
  final UuidValue fileId;
  @HiveField(2)
  final List<FileDownloadRequest> requests;
  @HiveField(3)
  final DateTime? timeStarted;
  @HiveField(4)
  final DateTime? timeComplete;

  FileDownload(
    this.companyId,
    this.fileId,
    this.requests,
    this.timeStarted,
    this.timeComplete,
  );

  FileDownload.request(
    this.companyId,
    this.fileId,
    FileDownloadRequest request,
  )   : requests = [request],
        timeStarted = null,
        timeComplete = null;

  FileDownload addRequest(FileDownloadRequest request) {
    requests.add(request);
    return FileDownload(
      companyId,
      fileId,
      requests,
      timeStarted,
      timeComplete,
    );
  }

  FileDownload asStartedNow() => FileDownload(
        companyId,
        fileId,
        requests,
        DateTime.now().toUtc(),
        null,
      );

  FileDownload asCompletedNow() => FileDownload(
        companyId,
        fileId,
        requests,
        timeStarted,
        DateTime.now().toUtc(),
      );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other is FileDownload) {
      return runtimeType == other.runtimeType &&
          companyId == other.companyId &&
          fileId == other.fileId;
    } else {
      return false;
    }
  }

  @override
  int get hashCode {
    return companyId.hashCode ^ fileId.hashCode;
  }
}

@HiveType(typeId: HiveDataType.fileDownloadRequest)
class FileDownloadRequest {
  @HiveField(0)
  final DownloadRequestType type;
  @HiveField(1)
  final DateTime time;
  @HiveField(2)
  final UuidValue? deckId;
  @HiveField(3)
  final UuidValue? resourceId;

  FileDownloadRequest(
    this.type,
    this.time,
    this.deckId,
    this.resourceId,
  );

  FileDownloadRequest.now(
    this.type,
    this.deckId,
    this.resourceId,
  ) : time = DateTime.now().toUtc();

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other is FileDownloadRequest) {
      return runtimeType == other.runtimeType &&
          type == other.type &&
          deckId == other.deckId &&
          resourceId == other.resourceId;
    } else {
      return false;
    }
  }

  @override
  int get hashCode {
    return type.hashCode ^
        (deckId?.hashCode ?? 0) ^
        (resourceId?.hashCode ?? 0);
  }
}

@HiveType(typeId: HiveDataType.fileDownloadRequestType)
enum DownloadRequestType {
  @HiveField(0)
  deckOuter,
  @HiveField(1)
  deckInner,
  @HiveField(2)
  userView,
  @HiveField(3)
  userFavorite,
  @HiveField(4)
  deckDownload,
}
