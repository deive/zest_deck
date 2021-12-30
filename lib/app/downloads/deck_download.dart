import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import 'package:zest_deck/app/app_data.dart';
import 'package:zest_deck/app/decks/deck.dart';

part 'deck_download.g.dart';

@HiveType(typeId: HiveDataType.deckDownload)
class DeckDownload {
  @HiveField(0)
  final UuidValue companyId;
  @HiveField(1)
  final UuidValue deckId;
  @HiveField(2)
  final UuidValue deckVersion;
  @HiveField(3)
  final DeckDownloadStatus status;

  DeckDownload(this.companyId, this.deckId, this.deckVersion, this.status);

  DeckDownload.newFor(Deck deck)
      : this(deck.companyId!, deck.id, deck.version!, DeckDownloadStatus.icons);

  copyWith(
          {UuidValue? companyId,
          UuidValue? deckId,
          UuidValue? deckVersion,
          DeckDownloadStatus? status,
          bool? autoDownload}) =>
      DeckDownload(
        companyId ?? this.companyId,
        deckId ?? this.deckId,
        deckVersion ?? this.deckVersion,
        status ?? this.status,
      );

  @override
  int get hashCode => companyId.hashCode * deckId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DeckDownload &&
          runtimeType == other.runtimeType &&
          companyId == other.companyId &&
          deckId == other.deckId;
}

@HiveType(typeId: HiveDataType.deckDownloadStatus)
enum DeckDownloadStatus {
  @HiveField(0)
  icons,
  @HiveField(1)
  requested,
  @HiveField(2)
  downloading,
  @HiveField(3)
  validating,
  @HiveField(4)
  downloaded,
  @HiveField(5)
  error,
}
