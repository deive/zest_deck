// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'section.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SectionAdapter extends TypeAdapter<Section> {
  @override
  final int typeId = 9;

  @override
  Section read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Section(
      id: fields[0] as UuidValue,
      index: fields[1] as int,
      title: fields[2] as String,
      subtitle: fields[3] as String,
      type: fields[4] as SectionType,
      resources: (fields[5] as List).cast<UuidValue>(),
      path: fields[6] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Section obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.index)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.subtitle)
      ..writeByte(4)
      ..write(obj.type)
      ..writeByte(5)
      ..write(obj.resources)
      ..writeByte(6)
      ..write(obj.path);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SectionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SectionTypeAdapter extends TypeAdapter<SectionType> {
  @override
  final int typeId = 14;

  @override
  SectionType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return SectionType.headline;
      case 1:
        return SectionType.normal;
      case 2:
        return SectionType.minor;
      default:
        return SectionType.headline;
    }
  }

  @override
  void write(BinaryWriter writer, SectionType obj) {
    switch (obj) {
      case SectionType.headline:
        writer.writeByte(0);
        break;
      case SectionType.normal:
        writer.writeByte(1);
        break;
      case SectionType.minor:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SectionTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
