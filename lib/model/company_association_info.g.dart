// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'company_association_info.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CompanyAndAssociationInfoAdapter
    extends TypeAdapter<CompanyAndAssociationInfo> {
  @override
  final int typeId = 4;

  @override
  CompanyAndAssociationInfo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CompanyAndAssociationInfo(
      accountContactId: fields[1] as int,
      accountId: fields[2] as int,
      userId: fields[3] as int,
      accountName: fields[4] as String,
      accountNameArabic: fields[5] as String,
      email: fields[6] as String,
      mobile: fields[7] as String,
      fax: fields[8] as String,
      website: fields[9] as String,
      accountLogo: fields[10] as String,
    );
  }

  @override
  void write(BinaryWriter writer, CompanyAndAssociationInfo obj) {
    writer
      ..writeByte(10)
      ..writeByte(1)
      ..write(obj.accountContactId)
      ..writeByte(2)
      ..write(obj.accountId)
      ..writeByte(3)
      ..write(obj.userId)
      ..writeByte(4)
      ..write(obj.accountName)
      ..writeByte(5)
      ..write(obj.accountNameArabic)
      ..writeByte(6)
      ..write(obj.email)
      ..writeByte(7)
      ..write(obj.mobile)
      ..writeByte(8)
      ..write(obj.fax)
      ..writeByte(9)
      ..write(obj.website)
      ..writeByte(10)
      ..write(obj.accountLogo);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CompanyAndAssociationInfoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
