// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'resource.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ResourceAdapter extends TypeAdapter<Resource> {
  @override
  final int typeId = 4;

  @override
  Resource read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Resource(
      id: fields[0] as Uuid,
      type: fields[1] as ResourceType,
      name: fields[2] as String,
      description: fields[3] as String,
      mime: fields[4] as String,
      filename: fields[5] as String,
      tags: (fields[6] as List).cast<String>(),
      modified: fields[7] as DateTime?,
      version: fields[8] as Uuid,
      task: fields[9] as Task?,
      path: (fields[10] as List).cast<String>(),
      stage: fields[11] as ResourceProcessingStage,
      properties: (fields[12] as List).cast<ResourceProperty>(),
      files: (fields[13] as Map).map((dynamic k, dynamic v) =>
          MapEntry(k as ResourceFileType, (v as List).cast<Uuid>())),
      metadata: (fields[14] as Map?)?.cast<String, String>(),
    );
  }

  @override
  void write(BinaryWriter writer, Resource obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.mime)
      ..writeByte(5)
      ..write(obj.filename)
      ..writeByte(6)
      ..write(obj.tags)
      ..writeByte(7)
      ..write(obj.modified)
      ..writeByte(8)
      ..write(obj.version)
      ..writeByte(9)
      ..write(obj.task)
      ..writeByte(10)
      ..write(obj.path)
      ..writeByte(11)
      ..write(obj.stage)
      ..writeByte(12)
      ..write(obj.properties)
      ..writeByte(13)
      ..write(obj.files)
      ..writeByte(14)
      ..write(obj.metadata);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ResourceAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ResourceFileAdapter extends TypeAdapter<ResourceFile> {
  @override
  final int typeId = 5;

  @override
  ResourceFile read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ResourceFile(
      id: fields[0] as Uuid,
      resourceId: fields[1] as Uuid?,
      companyId: fields[2] as Uuid?,
      mimeType: fields[3] as String?,
      ext: fields[4] as String?,
      metadata: (fields[5] as Map?)?.cast<String, String>(),
      size: fields[6] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, ResourceFile obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.resourceId)
      ..writeByte(2)
      ..write(obj.companyId)
      ..writeByte(3)
      ..write(obj.mimeType)
      ..writeByte(4)
      ..write(obj.ext)
      ..writeByte(5)
      ..write(obj.metadata)
      ..writeByte(6)
      ..write(obj.size);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ResourceFileAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
