// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CartAdapter extends TypeAdapter<Cart> {
  @override
  final int typeId = 2;

  @override
  Cart read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Cart(
      cartId: fields[1] as int,
      projectId: fields[2] as int,
      projectNameArabic: fields[3] as String,
      projectName: fields[4] as String,
      projectDescriptionShortArabic: fields[5] as String,
      projectDescriptionShort: fields[6] as String,
      associationName: fields[7] as String,
      associationNameArabic: fields[8] as String,
      amount: fields[9] as double,
      projectImage: fields[10] as String?,
      minimumAmount: fields[11] as double,
    );
  }

  @override
  void write(BinaryWriter writer, Cart obj) {
    writer
      ..writeByte(10)
      ..writeByte(1)
      ..write(obj.cartId)
      ..writeByte(2)
      ..write(obj.projectId)
      ..writeByte(3)
      ..write(obj.projectNameArabic)
      ..writeByte(4)
      ..write(obj.projectName)
      ..writeByte(5)
      ..write(obj.projectDescriptionShortArabic)
      ..writeByte(6)
      ..write(obj.projectDescriptionShort)
      ..writeByte(7)
      ..write(obj.associationName)
      ..writeByte(8)
      ..write(obj.associationNameArabic)
      ..writeByte(9)
      ..write(obj.amount)
      ..writeByte(10)
      ..write(obj.projectImage)
      ..writeByte(11)
      ..write(obj.minimumAmount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CartAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
