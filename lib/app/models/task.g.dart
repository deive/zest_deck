// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TaskAdapter extends TypeAdapter<Task> {
  @override
  final int typeId = 6;

  @override
  Task read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Task(
      id: fields[0] as UuidValue,
      resourceId: fields[1] as UuidValue?,
      accountId: fields[2] as UuidValue?,
      company: fields[3] as Company?,
      resource: fields[4] as Resource?,
      type: fields[5] as String?,
      progress: fields[6] as String?,
      assigned: fields[7] as UuidValue?,
      assignExpiry: fields[8] as DateTime?,
      error: (fields[9] as Map?)?.cast<String, String>(),
      binaryFiles: (fields[10] as Map?)?.cast<UuidValue, ResourceFile>(),
      files: (fields[11] as Map?)?.map((dynamic k, dynamic v) =>
          MapEntry(k as ResourceFileType, (v as List).cast<UuidValue>())),
      metadata: (fields[12] as Map?)?.cast<String, String>(),
    );
  }

  @override
  void write(BinaryWriter writer, Task obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.resourceId)
      ..writeByte(2)
      ..write(obj.accountId)
      ..writeByte(3)
      ..write(obj.company)
      ..writeByte(4)
      ..write(obj.resource)
      ..writeByte(5)
      ..write(obj.type)
      ..writeByte(6)
      ..write(obj.progress)
      ..writeByte(7)
      ..write(obj.assigned)
      ..writeByte(8)
      ..write(obj.assignExpiry)
      ..writeByte(9)
      ..write(obj.error)
      ..writeByte(10)
      ..write(obj.binaryFiles)
      ..writeByte(11)
      ..write(obj.files)
      ..writeByte(12)
      ..write(obj.metadata);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
