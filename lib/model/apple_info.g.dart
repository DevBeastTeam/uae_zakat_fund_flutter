// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'apple_info.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AppleInfoAdapter extends TypeAdapter<AppleInfo> {
  @override
  final int typeId = 3;

  @override
  AppleInfo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AppleInfo(
      firstName: fields[1] as dynamic,
      lastName: fields[2] as dynamic,
      email: fields[3] as dynamic,
      identifier: fields[4] as dynamic,
    );
  }

  @override
  void write(BinaryWriter writer, AppleInfo obj) {
    writer
      ..writeByte(4)
      ..writeByte(1)
      ..write(obj.firstName)
      ..writeByte(2)
      ..write(obj.lastName)
      ..writeByte(3)
      ..write(obj.email)
      ..writeByte(4)
      ..write(obj.identifier);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppleInfoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
