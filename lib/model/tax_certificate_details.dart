class TaxCertificateDetails {
  String emirateId;
  String donorName;
  String accountName;
  String donorNameAr;
  String accountNameAr;
  String nationalityName;
  String nationalityNameAr;
  DateTime createdDate;
  List<Detail> details;
  String firstName;
  String lastName;
  String emailAddress;
  String phoneNumber;
  String uniqueCode;
  String address;
  int roleId;

  TaxCertificateDetails({
    required this.emirateId,
    required this.donorName,
    required this.accountName,
    required this.donorNameAr,
    required this.accountNameAr,
    required this.nationalityName,
    required this.nationalityNameAr,
    required this.createdDate,
    required this.details,
    required this.firstName,
    required this.lastName,
    required this.emailAddress,
    required this.phoneNumber,
    required this.uniqueCode,
    required this.address,
    required this.roleId,
  });

  factory TaxCertificateDetails.fromJson(Map<String, dynamic> json) => TaxCertificateDetails(
    emirateId: json["emirateId"]??"",
    donorName: json["donorName"]??"",
    accountName: json["accountName"]??"",
    donorNameAr: json["donorNameAr"]??"",
    accountNameAr: json["accountNameAr"]??"",
    nationalityName: json["nationalityName"]??"",
    nationalityNameAr: json["nationalityNameAr"]??"",
    createdDate: DateTime.parse(json["createdDate"]),
    details: List<Detail>.from(json["details"].map((x) => Detail.fromJson(x))),
    firstName: json["firstName"]??"",
    lastName: json["lastName"]??"",
    emailAddress: json["emailAddress"]??"",
    phoneNumber: json["phoneNumber"]??"",
    uniqueCode: json["uniqueCode"]??"",
    address: json["address"]??"",
    roleId: json["roleId"],
  );

  Map<String, dynamic> toJson() => {
    "emirateId": emirateId,
    "donorName": donorName,
    "accountName": accountName,
    "donorNameAr": donorNameAr,
    "accountNameAr": accountNameAr,
    "nationalityName": nationalityName,
    "nationalityNameAr": nationalityNameAr,
    "createdDate": createdDate.toIso8601String(),
    "details": List<dynamic>.from(details.map((x) => x.toJson())),
    "firstName": firstName,
    "lastName": lastName,
    "emailAddress": emailAddress,
    "phoneNumber": phoneNumber,
    "uniqueCode": uniqueCode,
    "address": address,
    "roleId": roleId,
  };
}

class Detail {
  double amount;
  String projectName;
  String projectNameArabic;
  int paymentType;
  DateTime createdDate;

  Detail({
    required this.amount,
    required this.projectName,
    required this.projectNameArabic,
    required this.paymentType,
    required this.createdDate,
  });

  factory Detail.fromJson(Map<String, dynamic> json) => Detail(
    amount: json["amount"],
    projectName: json["projectName"],
    projectNameArabic: json["projectNameArabic"],
    paymentType: json["paymentType"],
    createdDate: DateTime.parse(json["createdDate"]),
  );

  Map<String, dynamic> toJson() => {
    "amount": amount,
    "projectName": projectName,
    "projectNameArabic": projectNameArabic,
    "paymentType": paymentType,
    "createdDate": createdDate.toIso8601String(),
  };
}
