// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'deck_download.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DeckDownloadAdapter extends TypeAdapter<DeckDownload> {
  @override
  final int typeId = 17;

  @override
  DeckDownload read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DeckDownload(
      fields[0] as UuidValue,
      fields[1] as UuidValue,
      fields[2] as UuidValue,
      fields[3] as DeckDownloadStatus,
      fields[4] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, DeckDownload obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.companyId)
      ..writeByte(1)
      ..write(obj.deckId)
      ..writeByte(2)
      ..write(obj.deckVersion)
      ..writeByte(3)
      ..write(obj.status)
      ..writeByte(4)
      ..write(obj.autoStart);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DeckDownloadAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DeckDownloadStatusAdapter extends TypeAdapter<DeckDownloadStatus> {
  @override
  final int typeId = 18;

  @override
  DeckDownloadStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return DeckDownloadStatus.notRequested;
      case 1:
        return DeckDownloadStatus.downloadingThumbnails;
      case 2:
        return DeckDownloadStatus.downloading;
      case 3:
        return DeckDownloadStatus.validating;
      case 4:
        return DeckDownloadStatus.downloaded;
      case 5:
        return DeckDownloadStatus.error;
      default:
        return DeckDownloadStatus.notRequested;
    }
  }

  @override
  void write(BinaryWriter writer, DeckDownloadStatus obj) {
    switch (obj) {
      case DeckDownloadStatus.notRequested:
        writer.writeByte(0);
        break;
      case DeckDownloadStatus.downloadingThumbnails:
        writer.writeByte(1);
        break;
      case DeckDownloadStatus.downloading:
        writer.writeByte(2);
        break;
      case DeckDownloadStatus.validating:
        writer.writeByte(3);
        break;
      case DeckDownloadStatus.downloaded:
        writer.writeByte(4);
        break;
      case DeckDownloadStatus.error:
        writer.writeByte(5);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DeckDownloadStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
