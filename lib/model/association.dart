import 'package:zakat_fund/model/company.dart';

class Association {
  AssociationInfo? associationInfo;
  ContactInfo? accountContact;
  AccountRepresentative? accountRepresentative;
  BankAccount? bankAccount;

  Association({
    this.associationInfo,
    this.accountContact,
    this.accountRepresentative,
    this.bankAccount,
  });

  factory Association.fromJson(Map<String, dynamic> json) => Association(
        associationInfo: json["accountInfo"] != null
            ? AssociationInfo.fromJson(json["accountInfo"])
            : null,
        accountContact: json["accountContact"] != null
            ? ContactInfo.fromJson(json["accountContact"])
            : null,
        accountRepresentative: json["accountRepresentative"] != null
            ? AccountRepresentative.fromJson(json["accountRepresentative"])
            : null,
        bankAccount: json["bankAccount"] != null
            ? BankAccount.fromJson(json["bankAccount"])
            : null,
      );
}

class AssociationInfo {
  int userId;
  int accountId;
  String accountName;
  String accountNameArabic;
  DateTime? establishmentDate;
  int? accountTypeId;
  String? accountLogo;
  String? associationCoverPhoto;
  String? license;
  String? issuingAuthority;
  String? associationDescriptionEN;
  String? associationDescriptionAR;
  DateTime? licenseExpiryDate;
  int? requestStatus;
  String? agreementUrl;
  bool isActive;

  AssociationInfo({
    required this.userId,
    required this.requestStatus,
    required this.accountId,
    required this.accountName,
    required this.accountNameArabic,
    required this.establishmentDate,
    required this.accountTypeId,
    required this.accountLogo,
    required this.associationCoverPhoto,
    required this.license,
    required this.issuingAuthority,
    required this.licenseExpiryDate,
    required this.associationDescriptionAR,
    required this.associationDescriptionEN,
    required this.agreementUrl,
    required this.isActive,
  });

  factory AssociationInfo.fromJson(Map<String, dynamic> json) =>
      AssociationInfo(
        userId: json["userId"],
        agreementUrl: json["agreementUrl"],
        requestStatus: json["requestStatus"]??1,
        associationDescriptionAR: json["associationDescriptionAR"]??"",
        associationDescriptionEN: json["associationDescriptionEN"]??"",
        accountId: json["accountID"],
        accountName: json["accountName"],
        accountNameArabic: json["accountNameArabic"],
        establishmentDate: json["establishmentDate"] != null
            ? DateTime.parse(json["establishmentDate"]).toLocal()
            : null,
        accountTypeId: json["accountTypeID"],
        accountLogo: json["accountLogo"],
        associationCoverPhoto: json["associationCoverPhoto"],
        license: json["license"],
        issuingAuthority: json["issuingAuthority"],
        isActive: json["isActive"]??false,
        licenseExpiryDate: json["licenseExpiryDate"] != null
            ? DateTime.parse(json["licenseExpiryDate"]).toLocal()
            : null,
      );
}
