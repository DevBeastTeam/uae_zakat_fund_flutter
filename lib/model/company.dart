import 'dart:convert';

import 'package:zakat_fund/model/association.dart';
import 'package:zakat_fund/model/association_company_info.dart';
import 'package:zakat_fund/model/individual.dart';

Company companyFromJson(String str) => Company.fromJson(json.decode(str));

class Company {
  CompanyInfo? accountInfo;
  ContactInfo? accountContact;
  AccountRepresentative? accountRepresentative;
  BankAccount? bankAccount;

  Company({
    this.accountInfo,
    this.accountContact,
    this.accountRepresentative,
    this.bankAccount,
  });

  factory Company.fromJson(Map<String, dynamic> json) => Company(
        accountInfo: json["accountInfo"] != null
            ? CompanyInfo.fromJson(json["accountInfo"])
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

class ContactInfo {
  dynamic accountId;
  dynamic email;
  dynamic mobile;
  dynamic fax;
  dynamic website;
  dynamic countryId;
  dynamic stateId;
  dynamic cityId;
  dynamic poBox;
  dynamic address;
  dynamic addressArabic;
  dynamic facebook;
  dynamic linkedIn;
  dynamic twitter;
  dynamic instagram;
  bool emailConfirmed;
  bool phoneNumberConfirmed;
  List<Address> addresses;
  List<SupportDocument> supportDocument;

  ContactInfo({
    required this.emailConfirmed,
    required this.phoneNumberConfirmed,
    required this.accountId,
    required this.email,
    required this.mobile,
    required this.fax,
    required this.website,
    required this.countryId,
    required this.stateId,
    required this.cityId,
    required this.poBox,
    required this.address,
    required this.addressArabic,
    required this.facebook,
    required this.linkedIn,
    required this.twitter,
    required this.instagram,
    required this.supportDocument,
    required this.addresses,
  });

  factory ContactInfo.fromJson(Map<String, dynamic> json) => ContactInfo(
        accountId: json["accountID"],
        email: json["email"] ?? "",
        mobile: json["mobile"] ?? "",
        fax: json["fax"] ?? "",
        website: json["website"] ?? "",
        countryId: json["countryId"],
        stateId: json["stateId"],
        cityId: json["cityId"],
        poBox: json["poBox"] ?? '',
        address: json["address"] ?? "",
        addresses: json["addresses"] != null
            ? List<Address>.from(
                json["addresses"].map((x) => Address.fromJson(x)))
            : [],
        addressArabic: json["addressArabic"] ?? "",
        facebook: json["facebook"],
        linkedIn: json["linkedIn"],
        twitter: json["twitter"],
        instagram: json["instagram"],
        phoneNumberConfirmed: json["phoneNumberConfirmed"] ?? false,
        emailConfirmed: json["emailConfirmed"] ?? false,
        supportDocument: json["supportDocument"] != null
            ? List<SupportDocument>.from(
                json["supportDocument"].map((x) => SupportDocument.fromJson(x)))
            : [],
      );

  Map<String, dynamic> toJson() => {
        "accountID": accountId,
        "email": email,
        "mobile": mobile,
        "fax": fax,
        "website": website,
        "countryId": countryId,
        "stateId": stateId,
        "cityId": cityId,
        "poBox": poBox,
        "address": address,
        "addressArabic": addressArabic,
        "addresses": List<dynamic>.from(addresses.map((x) => x.toJson())),
        "supportDocument": List<dynamic>.from(supportDocument.map((x) => x)),
        "facebook": facebook,
        "linkedIn": linkedIn,
        "twitter": twitter,
        "instagram": instagram,
        "phoneNumberConfirmed": phoneNumberConfirmed,
        "emailConfirmed": emailConfirmed,
      };
}

class SupportDocument {
  int id;
  String documentName;
  String documentFileName;
  int accountId;

  SupportDocument({
    required this.id,
    required this.documentName,
    required this.documentFileName,
    required this.accountId,
  });

  factory SupportDocument.fromJson(Map<String, dynamic> json) =>
      SupportDocument(
        id: json["id"],
        documentName: json["documentName"],
        documentFileName: json["documentFileName"],
        accountId: json["accountID"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "documentName": documentName,
        "documentFileName": documentFileName,
        "accountID": accountId,
      };
}

class CompanyInfo {
  int userId;
  int? accountId;
  String accountName;
  String accountNameArabic;
  DateTime? establishmentDate;
  int? accountTypeId;
  String? accountLogo;
  dynamic associationCoverPhoto;
  String? license;
  String? issuingAuthority;
  DateTime? licenseExpiryDate;
  int requestStatus;
  String? agreementUrl;
  bool isActive;

  CompanyInfo({
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
    required this.agreementUrl,
    required this.isActive,
  });

  factory CompanyInfo.fromJson(Map<String, dynamic> json) => CompanyInfo(
        userId: json["userId"],
        requestStatus: json["requestStatus"] ?? 1,
        accountId: json["accountID"],
        accountName: json["accountName"] ?? "",
        accountNameArabic: json["accountNameArabic"] ?? "",
        establishmentDate: json["establishmentDate"] != null
            ? DateTime.parse(json["establishmentDate"]).toLocal()
            : null,
        accountTypeId: json["accountTypeID"],
        accountLogo: json["accountLogo"],
        associationCoverPhoto: json["associationCoverPhoto"],
        license: json["license"],
        agreementUrl: json["agreementUrl"],
        issuingAuthority: json["issuingAuthority"],
        isActive: json["isActive"] ?? false,
        licenseExpiryDate: json["licenseExpiryDate"] != null
            ? DateTime.parse(json["licenseExpiryDate"]).toLocal()
            : null,
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "accountID": accountId,
        "accountName": accountName,
        "accountNameArabic": accountNameArabic,
        if (establishmentDate != null)
          "establishmentDate": establishmentDate!.toIso8601String(),
        "accountTypeID": accountTypeId,
        "accountLogo": accountLogo,
        "associationCoverPhoto": associationCoverPhoto,
        "license": license,
        "issuingAuthority": issuingAuthority,
        if (licenseExpiryDate != null)
          "licenseExpiryDate": licenseExpiryDate!.toIso8601String(),
        "requestStatus": requestStatus,
        "agreementUrl": agreementUrl,
        "isActive": isActive,
      };
}

class AccountRepresentative {
  dynamic id;
  dynamic accountId;
  dynamic firstName;
  dynamic lastName;
  dynamic firstNameArabic;
  dynamic lastNameArabic;
  dynamic email;
  dynamic phone;
  dynamic jobDescription;
  dynamic nationalityId;
  dynamic emirateId;

  AccountRepresentative({
    required this.id,
    required this.accountId,
    required this.firstName,
    required this.lastName,
    required this.firstNameArabic,
    required this.lastNameArabic,
    required this.email,
    required this.phone,
    required this.jobDescription,
    required this.nationalityId,
    required this.emirateId,
  });

  factory AccountRepresentative.fromJson(Map<String, dynamic> json) =>
      AccountRepresentative(
        id: json["id"],
        accountId: json["accountID"],
        firstName: json["firstName"] ?? "",
        lastName: json["lastName"] ?? "",
        firstNameArabic: json["firstNameArabic"] ?? "",
        lastNameArabic: json["lastNameArabic"] ?? "",
        email: json["email"] ?? "",
        phone: json["phone"] ?? "",
        jobDescription: json["jobDescription"] ?? "",
        nationalityId: json["nationalityId"],
        emirateId: json["emirateId"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "accountID": accountId,
        "firstName": firstName,
        "lastName": lastName,
        "firstNameArabic": firstNameArabic,
        "lastNameArabic": lastNameArabic,
        "email": email,
        "phone": phone,
        "jobDescription": jobDescription,
        "nationalityId": nationalityId,
        "emirateId": emirateId,
        "emailConfirmed": false,
        "phoneNumberConfirmed": false,
      };
}

class BankAccount {
  dynamic id;
  dynamic accountId;
  dynamic bankName;
  dynamic swiftCode;
  dynamic iban;

  BankAccount({
    required this.id,
    required this.accountId,
    required this.bankName,
    required this.swiftCode,
    required this.iban,
  });

  factory BankAccount.fromJson(Map<String, dynamic> json) => BankAccount(
        id: json["id"],
        accountId: json["accountID"],
        bankName: json["bankName"],
        swiftCode: json["swiftCode"],
        iban: json["iban"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "accountID": accountId,
        "bankName": bankName,
        "swiftCode": swiftCode,
        "iban": iban,
      };
}

class CompanyItemData {
  final String id, name, nameAr, email, mobile, website, logo;
  final int status;
  final int? requestStatus;
  final bool isActive;
  final Association? association;
  final Company? company;
  final AssociationAndCompanyInfo? info;

  CompanyItemData({
    required this.id,
    required this.name,
    required this.nameAr,
    required this.email,
    required this.mobile,
    required this.website,
    required this.logo,
    required this.status,
    this.isActive = false,
    this.association,
    this.company,
    this.info,
    this.requestStatus,
  });
}
