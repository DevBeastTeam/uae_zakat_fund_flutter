
class AssociationAndCompanyInfo {
  int accountContactId;
  int userId;
  String accountName;
  String accountNameArabic;
  String email;
  String mobile;
  dynamic fax;
  String website;
  String accountLogo;
  int status;
  int requestStatus;

  AssociationAndCompanyInfo({
    required this.accountContactId,
    required this.userId,
    required this.accountName,
    required this.accountNameArabic,
    required this.email,
    required this.mobile,
    required this.fax,
    required this.website,
    required this.accountLogo,
    required this.status,
    required this.requestStatus,
  });

  factory AssociationAndCompanyInfo.fromJson(Map<String, dynamic> json) => AssociationAndCompanyInfo(
    accountContactId: json["accountContactId"],
    userId: json["userId"],
    accountName: json["accountName"],
    accountNameArabic: json["accountNameArabic"],
    email: json["email"],
    mobile: json["mobile"],
    fax: json["fax"],
    website: json["website"],
    accountLogo: json["accountLogo"]??"",
    status: json["status"]??1,
    requestStatus: json["requestStatus"]??1,
  );

}
