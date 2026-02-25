// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'package:hive/hive.dart';
import 'package:zakat_fund/model/company_association_info.dart';

part 'user.g.dart';

@HiveType(typeId: 1)
class User {
  @HiveField(1)
  int id;
  @HiveField(14)
  int? accountId;
  @HiveField(2)
  String userName;
  @HiveField(3)
  dynamic firstName;
  @HiveField(4)
  dynamic lastName;
  @HiveField(5)
  dynamic firstNameArabic;
  @HiveField(6)
  dynamic lastNameArabic;
  @HiveField(7)
  dynamic email;
  @HiveField(8)
  dynamic mobile;
  @HiveField(9)
  String bearerToken;
  @HiveField(10)
  bool isAuthenticated;
  @HiveField(11)
  dynamic photo;
  @HiveField(12)
  List<String> roles;
  @HiveField(13)
  dynamic status;
  @HiveField(15)
  dynamic provider;
  @HiveField(16)
  String? uuid;
  @HiveField(17)
  bool isAdmin;
  @HiveField(18)
  List<CompanyAndAssociationInfo> companyList;
  @HiveField(19)
  List<CompanyAndAssociationInfo> associationList;
  @HiveField(20)
  List<int>? customRoleId;
  @HiveField(21)
  bool isEmployeeAndDonor;
  @HiveField(22)
  int? empId;
  @HiveField(23)
  int? userTypeID;

  User({
    required this.id,
    required this.accountId,
    required this.userName,
    required this.firstName,
    required this.lastName,
    required this.firstNameArabic,
    required this.lastNameArabic,
    required this.email,
    required this.mobile,
    required this.bearerToken,
    required this.isAuthenticated,
    required this.photo,
    required this.roles,
    required this.status,
    required this.provider,
    required this.uuid,
    required this.isAdmin,
    required this.companyList,
    required this.associationList,
    required this.customRoleId,
    required this.isEmployeeAndDonor,
    this.empId,
    this.userTypeID,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    accountId: json["accountId"],
    userName: json["userName"],
    firstName: json["firstName"],
    lastName: json["lastName"],
    empId: json["empId"],
    firstNameArabic: json["firstNameArabic"],
    lastNameArabic: json["lastNameArabic"],
    email: json["email"],
    userTypeID: json["userTypeID"]??0,
    mobile: json["mobile"],
    customRoleId: json["customRoleId"]!=null?List<int>.from(json["customRoleId"].map((x) => x)):null,
    bearerToken: json["bearerToken"],
    isAuthenticated: json["isAuthenticated"],
    photo: json["photo"],
    provider: json["provider"],
    roles: List<String>.from(json["roles"].map((x) => x)),
    status: json["status"],
    uuid: json["uuid"],
    isEmployeeAndDonor: json["isEmployeeAndDonor"]??false,
    isAdmin: json["isAdmin"]??false,
    companyList: json["companyList"] != null
        ? List<CompanyAndAssociationInfo>.from(
        json["companyList"].map((x) => CompanyAndAssociationInfo.fromJson(x)))
        : [],
    associationList: json["associationList"] != null
        ? List<CompanyAndAssociationInfo>.from(
        json["associationList"].map((x) => CompanyAndAssociationInfo.fromJson(x)))
        : [],

  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "accountId": accountId,
    "userName": userName,
    "firstName": firstName,
    "userTypeID": userTypeID,
    "lastName": lastName,
    "firstNameArabic": firstNameArabic,
    "lastNameArabic": lastNameArabic,
    "email": email,
    "mobile": mobile,
    "bearerToken": bearerToken,
    "isAuthenticated": isAuthenticated,
    "photo": photo,
    "roles": List<dynamic>.from(roles.map((x) => x)),
    "status": status,
    "empId": empId,
    "isAdmin": isAdmin,
    "customRoleId": customRoleId,
    "isEmployeeAndDonor": isEmployeeAndDonor,
  };

  User clone() {
    return User(
      id: id,
      accountId: accountId,
      userName: userName,
      firstName: firstName,
      lastName: lastName,
      firstNameArabic: firstNameArabic,
      lastNameArabic: lastNameArabic,
      email: email,
      mobile: mobile,
      bearerToken: bearerToken,
      isAuthenticated: isAuthenticated,
      photo: photo,
      roles: List<String>.from(roles),
      status: status,
      provider: provider,
      uuid: uuid,
      isAdmin: isAdmin,
      companyList: companyList.map((e) => e.clone()).toList(),
      associationList: associationList.map((e) => e.clone()).toList(),
      customRoleId: customRoleId != null ? List<int>.from(customRoleId!) : null,
      isEmployeeAndDonor: isEmployeeAndDonor,
      empId: empId,
      userTypeID: userTypeID,
    );
  }

}

@HiveType(typeId: 5)
class BiometricUser{

  @HiveField(1)
  String userName;
  @HiveField(2)
  String type;
  @HiveField(3)
  int userId;
  @HiveField(4)
  bool showChangePassword;

  BiometricUser({required this.userName, required this.type, required this.userId, required this.showChangePassword});
}