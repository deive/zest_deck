// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'resource.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ResourceAdapter extends TypeAdapter<Resource> {
  @override
  final int typeId = 6;

  @override
  Resource read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Resource(
      id: fields[0] as UuidValue,
      type: fields[1] as ResourceType,
      name: fields[2] as String,
      description: fields[3] as String,
      mime: fields[4] as String,
      filename: fields[5] as String,
      tags: (fields[6] as List).cast<String>(),
      modified: fields[7] as DateTime?,
      version: fields[8] as UuidValue,
      task: fields[9] as Task?,
      path: (fields[10] as List).cast<String>(),
      stage: fields[11] as ResourceProcessingStage,
      properties: (fields[12] as List).cast<ResourceProperty>(),
      files: (fields[13] as Map).map((dynamic k, dynamic v) =>
          MapEntry(k as ResourceFileType, (v as List).cast<UuidValue>())),
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
  final int typeId = 7;

  @override
  ResourceFile read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ResourceFile(
      id: fields[0] as UuidValue,
      resourceId: fields[1] as UuidValue?,
      companyId: fields[2] as UuidValue?,
      mimeType: fields[3] as String?,
      ext: fields[4] as String?,
      size: fields[5] as int?,
      metadata: (fields[6] as Map?)?.cast<String, String>(),
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
      ..write(obj.size)
      ..writeByte(6)
      ..write(obj.metadata);
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

class ResourceFileTypeAdapter extends TypeAdapter<ResourceFileType> {
  @override
  final int typeId = 10;

  @override
  ResourceFileType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ResourceFileType.content;
      case 1:
        return ResourceFileType.original;
      case 2:
        return ResourceFileType.thumbnail;
      case 3:
        return ResourceFileType.chosenThumbnail;
      case 4:
        return ResourceFileType.thumbnailUser;
      case 5:
        return ResourceFileType.logo;
      case 6:
        return ResourceFileType.imageContent;
      default:
        return ResourceFileType.content;
    }
  }

  @override
  void write(BinaryWriter writer, ResourceFileType obj) {
    switch (obj) {
      case ResourceFileType.content:
        writer.writeByte(0);
        break;
      case ResourceFileType.original:
        writer.writeByte(1);
        break;
      case ResourceFileType.thumbnail:
        writer.writeByte(2);
        break;
      case ResourceFileType.chosenThumbnail:
        writer.writeByte(3);
        break;
      case ResourceFileType.thumbnailUser:
        writer.writeByte(4);
        break;
      case ResourceFileType.logo:
        writer.writeByte(5);
        break;
      case ResourceFileType.imageContent:
        writer.writeByte(6);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ResourceFileTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ResourceProcessingStageAdapter
    extends TypeAdapter<ResourceProcessingStage> {
  @override
  final int typeId = 11;

  @override
  ResourceProcessingStage read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ResourceProcessingStage.pending;
      case 1:
        return ResourceProcessingStage.processing;
      case 2:
        return ResourceProcessingStage.processing25;
      case 3:
        return ResourceProcessingStage.processing50;
      case 4:
        return ResourceProcessingStage.processing75;
      case 5:
        return ResourceProcessingStage.complete;
      default:
        return ResourceProcessingStage.pending;
    }
  }

  @override
  void write(BinaryWriter writer, ResourceProcessingStage obj) {
    switch (obj) {
      case ResourceProcessingStage.pending:
        writer.writeByte(0);
        break;
      case ResourceProcessingStage.processing:
        writer.writeByte(1);
        break;
      case ResourceProcessingStage.processing25:
        writer.writeByte(2);
        break;
      case ResourceProcessingStage.processing50:
        writer.writeByte(3);
        break;
      case ResourceProcessingStage.processing75:
        writer.writeByte(4);
        break;
      case ResourceProcessingStage.complete:
        writer.writeByte(5);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ResourceProcessingStageAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ResourcePropertyAdapter extends TypeAdapter<ResourceProperty> {
  @override
  final int typeId = 12;

  @override
  ResourceProperty read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ResourceProperty.canEmail;
      case 1:
        return ResourceProperty.allowOpen;
      default:
        return ResourceProperty.canEmail;
    }
  }

  @override
  void write(BinaryWriter writer, ResourceProperty obj) {
    switch (obj) {
      case ResourceProperty.canEmail:
        writer.writeByte(0);
        break;
      case ResourceProperty.allowOpen:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ResourcePropertyAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ResourceTypeAdapter extends TypeAdapter<ResourceType> {
  @override
  final int typeId = 13;

  @override
  ResourceType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ResourceType.document;
      case 1:
        return ResourceType.image;
      case 2:
        return ResourceType.video;
      case 3:
        return ResourceType.microsite;
      case 4:
        return ResourceType.link;
      case 5:
        return ResourceType.folder;
      case 6:
        return ResourceType.unset;
      default:
        return ResourceType.document;
    }
  }

  @override
  void write(BinaryWriter writer, ResourceType obj) {
    switch (obj) {
      case ResourceType.document:
        writer.writeByte(0);
        break;
      case ResourceType.image:
        writer.writeByte(1);
        break;
      case ResourceType.video:
        writer.writeByte(2);
        break;
      case ResourceType.microsite:
        writer.writeByte(3);
        break;
      case ResourceType.link:
        writer.writeByte(4);
        break;
      case ResourceType.folder:
        writer.writeByte(5);
        break;
      case ResourceType.unset:
        writer.writeByte(6);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ResourceTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
