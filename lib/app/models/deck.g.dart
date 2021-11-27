// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'deck.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DeckAdapter extends TypeAdapter<Deck> {
  @override
  final int typeId = 3;

  @override
  Deck read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Deck(
      id: fields[0] as UuidValue,
      companyId: fields[1] as UuidValue?,
      version: fields[2] as UuidValue?,
      resources: (fields[3] as List).cast<Resource>(),
      files: (fields[4] as List).cast<ResourceFile>(),
      thumbnail: fields[5] as UuidValue?,
      thumbnailFile: fields[6] as UuidValue?,
      rank: fields[7] as int,
      title: fields[8] as String,
      subtitle: fields[9] as String,
      modified: fields[10] as DateTime?,
      sections: (fields[11] as List).cast<Section>(),
      permissions: (fields[12] as List?)?.cast<UuidValue>(),
      metadata: (fields[13] as Map?)?.cast<String, String>(),
    );
  }

  @override
  void write(BinaryWriter writer, Deck obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.companyId)
      ..writeByte(2)
      ..write(obj.version)
      ..writeByte(3)
      ..write(obj.resources)
      ..writeByte(4)
      ..write(obj.files)
      ..writeByte(5)
      ..write(obj.thumbnail)
      ..writeByte(6)
      ..write(obj.thumbnailFile)
      ..writeByte(7)
      ..write(obj.rank)
      ..writeByte(8)
      ..write(obj.title)
      ..writeByte(9)
      ..write(obj.subtitle)
      ..writeByte(10)
      ..write(obj.modified)
      ..writeByte(11)
      ..write(obj.sections)
      ..writeByte(12)
      ..write(obj.permissions)
      ..writeByte(13)
      ..write(obj.metadata);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DeckAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
