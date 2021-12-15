import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import 'package:zest_deck/app/app_data.dart';
import 'package:zest_deck/app/decks/deck.dart';
import 'package:zest_deck/app/models/resource.dart';

part 'deck_file_download.g.dart';

@HiveType(typeId: HiveDataType.deckFileDownload)
class DeckFileDownload {
  @HiveField(0)
  final UuidValue companyId;
  @HiveField(1)
  final UuidValue fileId;
  @HiveField(2)
  final DownloadStatus status;

  DeckFileDownload(this.companyId, this.fileId, this.status);

  DeckFileDownload.newFor(Deck deck, ResourceFile file)
      : this(deck.companyId!, file.id, DownloadStatus.requested);

  copyWith(
          {UuidValue? companyId,
          UuidValue? deckId,
          UuidValue? fileId,
          DownloadStatus? status,
          bool? autoDownload}) =>
      DeckFileDownload(
        companyId ?? this.companyId,
        fileId ?? this.fileId,
        status ?? this.status,
      );

  @override
  int get hashCode => companyId.hashCode * fileId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DeckFileDownload &&
          runtimeType == other.runtimeType &&
          companyId == other.companyId &&
          fileId == other.fileId;
}

@HiveType(typeId: HiveDataType.downloadStatus)
enum DownloadStatus {
  @HiveField(0)
  requested,
  @HiveField(1)
  downloading,
  @HiveField(2)
  validating,
  @HiveField(3)
  downloaded,
}
