// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_request_response.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ZestAPIRequestResponseAdapter
    extends TypeAdapter<ZestAPIRequestResponse> {
  @override
  final int typeId = 2;

  @override
  ZestAPIRequestResponse read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ZestAPIRequestResponse(
      user: fields[0] as User?,
      companies: (fields[1] as List?)?.cast<Company>(),
      decks: (fields[2] as List?)?.cast<Deck>(),
      files: (fields[3] as List?)?.cast<ResourceFile>(),
      tasks: (fields[4] as List?)?.cast<Task>(),
      companyId: fields[5] as UuidValue?,
      resourceId: fields[6] as UuidValue?,
      resources: (fields[7] as List?)?.cast<Resource>(),
      metadata: (fields[8] as Map?)?.cast<String, String>(),
    );
  }

  @override
  void write(BinaryWriter writer, ZestAPIRequestResponse obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.user)
      ..writeByte(1)
      ..write(obj.companies)
      ..writeByte(2)
      ..write(obj.decks)
      ..writeByte(3)
      ..write(obj.files)
      ..writeByte(4)
      ..write(obj.tasks)
      ..writeByte(5)
      ..write(obj.companyId)
      ..writeByte(6)
      ..write(obj.resourceId)
      ..writeByte(7)
      ..write(obj.resources)
      ..writeByte(8)
      ..write(obj.metadata);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ZestAPIRequestResponseAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
