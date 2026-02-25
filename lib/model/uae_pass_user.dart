import 'package:zakat_fund/model/company_association_info.dart';

class UaePassUser {
  int id;
  String? userName;
  String firstName;
  String lastName;
  String? firstNameArabic;
  String? lastNameArabic;
  dynamic provider;
  String email;
  String mobile;
  dynamic bearerToken;
  bool isAuthenticated;
  String? photo;
  List<String> roles;
  int? status;
  int cartCount;
  String? uuid;
  dynamic accountId;
  dynamic isUaePassConfirmed;
  dynamic uaePassCountryCode;
  dynamic fullnameEn;
  dynamic fullnameAr;
  dynamic sub;
  List<CompanyAndAssociationInfo> companyList;
  List<CompanyAndAssociationInfo> associationList;

  UaePassUser({
    required this.id,
    required this.userName,
    required this.firstName,
    required this.lastName,
    required this.firstNameArabic,
    required this.lastNameArabic,
    required this.provider,
    required this.email,
    required this.mobile,
    required this.bearerToken,
    required this.isAuthenticated,
    required this.photo,
    required this.roles,
    required this.status,
    required this.cartCount,
    required this.accountId,
    required this.isUaePassConfirmed,
    required this.uaePassCountryCode,
    required this.fullnameEn,
    required this.fullnameAr,
    required this.sub,
    required this.uuid,
    required this.companyList,
    required this.associationList,
  });

  factory UaePassUser.fromJson(Map<String, dynamic> json) => UaePassUser(
    id: json["id"],
    userName: json["userName"],
    firstName: json["firstName"],
    lastName: json["lastName"],
    firstNameArabic: json["firstNameArabic"],
    lastNameArabic: json["lastNameArabic"],
    provider: json["provider"],
    email: json["email"],
    mobile: json["mobile"],
    bearerToken: json["bearerToken"],
    isAuthenticated: json["isAuthenticated"],
    photo: json["photo"],
    roles: List<String>.from(json["roles"].map((x) => x)),
    status: json["status"],
    cartCount: json["cartCount"],
    accountId: json["accountId"],
    isUaePassConfirmed: json["isUAEPassConfirmed"],
    uaePassCountryCode: json["uaePassCountryCode"],
    fullnameEn: json["fullnameEN"],
    fullnameAr: json["fullnameAR"],
    sub: json["sub"],
    uuid: json["uuid"],
    companyList: json["companyList"] != null
        ? List<CompanyAndAssociationInfo>.from(
        json["companyList"].map((x) => CompanyAndAssociationInfo.fromJson(x)))
        : [],
    associationList: json["associationList"] != null
        ? List<CompanyAndAssociationInfo>.from(
        json["associationList"].map((x) => CompanyAndAssociationInfo.fromJson(x)))
        : [],
  );

}
