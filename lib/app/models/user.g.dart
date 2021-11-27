// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserAdapter extends TypeAdapter<User> {
  @override
  final int typeId = 1;

  @override
  User read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return User(
      id: fields[0] as UuidValue,
      companies: (fields[1] as List).cast<UuidValue>(),
      forename: fields[2] as String?,
      surname: fields[3] as String?,
      email: fields[4] as String?,
      lastAuth: fields[5] as DateTime?,
      token: fields[6] as String?,
      resetToken: fields[7] as String?,
      magicToken: fields[8] as String?,
      companyGrants: (fields[9] as Map?)?.map((dynamic k, dynamic v) =>
          MapEntry(k as UuidValue, (v as List).cast<String>())),
      validated: fields[10] as bool,
      metadata: (fields[11] as Map?)?.cast<String, String>(),
    );
  }

  @override
  void write(BinaryWriter writer, User obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.companies)
      ..writeByte(2)
      ..write(obj.forename)
      ..writeByte(3)
      ..write(obj.surname)
      ..writeByte(4)
      ..write(obj.email)
      ..writeByte(5)
      ..write(obj.lastAuth)
      ..writeByte(6)
      ..write(obj.token)
      ..writeByte(7)
      ..write(obj.resetToken)
      ..writeByte(8)
      ..write(obj.magicToken)
      ..writeByte(9)
      ..write(obj.companyGrants)
      ..writeByte(10)
      ..write(obj.validated)
      ..writeByte(11)
      ..write(obj.metadata);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
