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
      id: fields[1] as int,
      accountId: fields[14] as int?,
      userName: fields[2] as String,
      firstName: fields[3] as dynamic,
      lastName: fields[4] as dynamic,
      firstNameArabic: fields[5] as dynamic,
      lastNameArabic: fields[6] as dynamic,
      email: fields[7] as dynamic,
      mobile: fields[8] as dynamic,
      bearerToken: fields[9] as String,
      isAuthenticated: fields[10] as bool,
      photo: fields[11] as dynamic,
      roles: (fields[12] as List).cast<String>(),
      status: fields[13] as dynamic,
      provider: fields[15] as dynamic,
      uuid: fields[16] as String?,
      isAdmin: fields[17] as bool,
      companyList: (fields[18] as List).cast<CompanyAndAssociationInfo>(),
      associationList: (fields[19] as List).cast<CompanyAndAssociationInfo>(),
      customRoleId: (fields[20] as List?)?.cast<int>(),
      isEmployeeAndDonor: fields[21] as bool,
      empId: fields[22] as int?,
      userTypeID: fields[23] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, User obj) {
    writer
      ..writeByte(23)
      ..writeByte(1)
      ..write(obj.id)
      ..writeByte(14)
      ..write(obj.accountId)
      ..writeByte(2)
      ..write(obj.userName)
      ..writeByte(3)
      ..write(obj.firstName)
      ..writeByte(4)
      ..write(obj.lastName)
      ..writeByte(5)
      ..write(obj.firstNameArabic)
      ..writeByte(6)
      ..write(obj.lastNameArabic)
      ..writeByte(7)
      ..write(obj.email)
      ..writeByte(8)
      ..write(obj.mobile)
      ..writeByte(9)
      ..write(obj.bearerToken)
      ..writeByte(10)
      ..write(obj.isAuthenticated)
      ..writeByte(11)
      ..write(obj.photo)
      ..writeByte(12)
      ..write(obj.roles)
      ..writeByte(13)
      ..write(obj.status)
      ..writeByte(15)
      ..write(obj.provider)
      ..writeByte(16)
      ..write(obj.uuid)
      ..writeByte(17)
      ..write(obj.isAdmin)
      ..writeByte(18)
      ..write(obj.companyList)
      ..writeByte(19)
      ..write(obj.associationList)
      ..writeByte(20)
      ..write(obj.customRoleId)
      ..writeByte(21)
      ..write(obj.isEmployeeAndDonor)
      ..writeByte(22)
      ..write(obj.empId)
      ..writeByte(23)
      ..write(obj.userTypeID);
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

class BiometricUserAdapter extends TypeAdapter<BiometricUser> {
  @override
  final int typeId = 5;

  @override
  BiometricUser read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BiometricUser(
      userName: fields[1] as String,
      type: fields[2] as String,
      userId: fields[3] as int,
      showChangePassword: fields[4] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, BiometricUser obj) {
    writer
      ..writeByte(4)
      ..writeByte(1)
      ..write(obj.userName)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.userId)
      ..writeByte(4)
      ..write(obj.showChangePassword);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BiometricUserAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
