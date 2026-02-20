import 'package:hive_flutter/hive_flutter.dart';

part 'company_association_info.g.dart';
@HiveType(typeId: 4)
class CompanyAndAssociationInfo {
  @HiveField(1)
  int accountContactId;
  @HiveField(2)
  int accountId;
  @HiveField(3)
  int userId;
  @HiveField(4)
  String accountName;
  @HiveField(5)
  String accountNameArabic;
  @HiveField(6)
  String email;
  @HiveField(7)
  String mobile;
  @HiveField(8)
  String fax;
  @HiveField(9)
  String website;
  @HiveField(10)
  String accountLogo;

  CompanyAndAssociationInfo({
    required this.accountContactId,
    required this.accountId,
    required this.userId,
    required this.accountName,
    required this.accountNameArabic,
    required this.email,
    required this.mobile,
    required this.fax,
    required this.website,
    required this.accountLogo,
  });

  factory CompanyAndAssociationInfo.fromJson(Map<String, dynamic> json) => CompanyAndAssociationInfo(
    accountContactId: json["accountContactId"]??0,
    accountId: json["accountId"]??json["accountID"],
    userId: json["userId"],
    accountName: json["accountName"],
    accountNameArabic: json["accountNameArabic"],
    email: json["email"]??"",
    mobile: json["mobile"]??"",
    fax: json["fax"]??"",
    website: json["website"]??"",
    accountLogo: json["accountLogo"]??"",
  );

  Map<String, dynamic> toJson() => {
    "accountContactId": accountContactId,
    "accountId": accountId,
    "userId": userId,
    "accountName": accountName,
    "accountNameArabic": accountNameArabic,
    "email": email,
    "mobile": mobile,
    "fax": fax,
    "website": website,
    "accountLogo": accountLogo,
  };

  CompanyAndAssociationInfo clone() {
    return CompanyAndAssociationInfo(
      accountContactId: accountContactId,
      accountId: accountId,
      userId: userId,
      accountName: accountName,
      accountNameArabic: accountNameArabic,
      email: email,
      mobile: mobile,
      fax: fax,
      website: website,
      accountLogo: accountLogo,
    );
  }

}
