// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AuthSessionAdapter extends TypeAdapter<AuthSession> {
  @override
  final int typeId = 2;

  @override
  AuthSession read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AuthSession(
      fields[0] as String,
      fields[1] as int,
      fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, AuthSession obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.accessToken)
      ..writeByte(1)
      ..write(obj.expiresOn)
      ..writeByte(2)
      ..write(obj.refreshToken);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthSessionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
