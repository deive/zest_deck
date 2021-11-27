// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'company.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CompanyAdapter extends TypeAdapter<Company> {
  @override
  final int typeId = 2;

  @override
  Company read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Company(
      fields[0] as UuidValue,
      fields[1] as String,
      fields[2] as String?,
      fields[3] as String?,
      (fields[4] as List?)?.cast<String>(),
      (fields[5] as List?)?.cast<UuidValue>(),
      (fields[6] as Map?)?.cast<String, String>(),
    );
  }

  @override
  void write(BinaryWriter writer, Company obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.contactNumber)
      ..writeByte(3)
      ..write(obj.contactEmail)
      ..writeByte(4)
      ..write(obj.settings)
      ..writeByte(5)
      ..write(obj.users)
      ..writeByte(6)
      ..write(obj.metadata);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CompanyAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
