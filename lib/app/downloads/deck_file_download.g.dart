// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'deck_file_download.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DeckFileDownloadAdapter extends TypeAdapter<DeckFileDownload> {
  @override
  final int typeId = 15;

  @override
  DeckFileDownload read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DeckFileDownload(
      fields[0] as UuidValue,
      fields[1] as UuidValue,
      fields[2] as DownloadStatus,
    );
  }

  @override
  void write(BinaryWriter writer, DeckFileDownload obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.companyId)
      ..writeByte(1)
      ..write(obj.fileId)
      ..writeByte(2)
      ..write(obj.status);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DeckFileDownloadAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DownloadStatusAdapter extends TypeAdapter<DownloadStatus> {
  @override
  final int typeId = 16;

  @override
  DownloadStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return DownloadStatus.requested;
      case 1:
        return DownloadStatus.downloading;
      case 2:
        return DownloadStatus.validating;
      case 3:
        return DownloadStatus.downloaded;
      case 4:
        return DownloadStatus.error;
      default:
        return DownloadStatus.requested;
    }
  }

  @override
  void write(BinaryWriter writer, DownloadStatus obj) {
    switch (obj) {
      case DownloadStatus.requested:
        writer.writeByte(0);
        break;
      case DownloadStatus.downloading:
        writer.writeByte(1);
        break;
      case DownloadStatus.validating:
        writer.writeByte(2);
        break;
      case DownloadStatus.downloaded:
        writer.writeByte(3);
        break;
      case DownloadStatus.error:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DownloadStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
