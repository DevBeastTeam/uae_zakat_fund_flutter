import 'dart:convert';

Individual individualFromJson(String str) =>
    Individual.fromJson(json.decode(str));

String individualToJson(Individual data) => json.encode(data.toJson());

class Individual {
  AccountInfo? accountInfo;
  DonorContactInfo? contactInfo;

  Individual({
    this.accountInfo,
    this.contactInfo,
  });

  factory Individual.fromJson(Map<String, dynamic> json) => Individual(
        accountInfo: AccountInfo.fromJson(json["accountInfo"]),
        contactInfo: DonorContactInfo.fromJson(json["contactInfo"]),
      );

  Map<String, dynamic> toJson() => {
        "accountInfo": accountInfo?.toJson(),
        "contactInfo": contactInfo?.toJson(),
      };
}

class AccountInfo {
  int userId;
  String userName;
  dynamic email;
  bool emailConfirmed;
  dynamic firstNameArabic;
  dynamic lastNameArabic;
  dynamic firstName;
  dynamic lastName;
  DateTime? dob;
  dynamic gender;
  dynamic emirateId;
  dynamic nationalityId;
  dynamic photo;
  int status;
  double totalDonation;
  DateTime createdDate;

  AccountInfo(
      {required this.userId,
      required this.userName,
      required this.email,
      required this.emailConfirmed,
      required this.firstNameArabic,
      required this.lastNameArabic,
      required this.firstName,
      required this.lastName,
      this.dob,
      required this.gender,
      required this.emirateId,
      required this.nationalityId,
      required this.photo,
      required this.status,
        required this.totalDonation,
      required this.createdDate});

  factory AccountInfo.fromJson(Map<String, dynamic> json) => AccountInfo(
        userId: json["userId"],
        userName: json["userName"] ?? "",
        email: json["email"] ?? "",
        emailConfirmed: json["emailConfirmed"],
        firstNameArabic: json["firstNameArabic"] ?? "",
        lastNameArabic: json["lastNameArabic"] ?? "",
        firstName: json["firstName"] ?? "",
        lastName: json["lastName"] ?? "",
        dob: json["dob"] != null ? DateTime.parse(json["dob"]).toLocal() : null,
        gender: json["gender"],
        emirateId: json["emirateId"] ?? "",
        nationalityId: json["nationalityId"],
        photo: json["photo"],
        status: json["status"],
    totalDonation: json["totalDonation"]??0,
        createdDate: DateTime.parse(json["createdDate"]).toLocal(),
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "userName": userName,
        "email": email,
        "firstNameArabic": firstNameArabic,
        "lastNameArabic": lastNameArabic,
        "firstName": firstName,
        "lastName": lastName,
        if(dob!=null)"dob": dob?.toString(),
        if(gender!=null)"gender": gender,
        if(emirateId!=null&&emirateId.isNotEmpty)"emirateId": emirateId,
        if(nationalityId!=null)"nationalityId": nationalityId,
        if(photo!=null)"photo": photo,
      };
}

class DonorContactInfo {
  int userId;
  dynamic mobile;
  dynamic additionalMobileNumber;
  dynamic countryResidenceId;
  dynamic stateId;
  dynamic cityId;
  dynamic poBox;
  List<Address> addresses;
  int status;
  bool phoneNumberConfirmed;
  bool isActive;

  DonorContactInfo({
    required this.userId,
    required this.mobile,
    required this.additionalMobileNumber,
    required this.countryResidenceId,
    required this.stateId,
    required this.cityId,
    required this.poBox,
    required this.addresses,
    required this.status,
    required this.phoneNumberConfirmed,
    required this.isActive,
  });

  factory DonorContactInfo.fromJson(Map<String, dynamic> json) => DonorContactInfo(
        userId: json["userId"],
        mobile: json["mobile"] ?? "",
    isActive: json["isActive"] ?? false,
        additionalMobileNumber: json["additionalMobileNumber"] ?? "",
        countryResidenceId: json["countryResidenceId"],
        stateId: json["stateId"],
        cityId: json["cityId"],
        poBox: json["poBox"] ?? "",
        addresses: List<Address>.from(
            json["addresses"].map((x) => Address.fromJson(x))),
        status: json["status"],
        phoneNumberConfirmed: json["phoneNumberConfirmed"],
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "mobile": mobile,
        "additionalMobileNumber": additionalMobileNumber,
        "countryResidenceId": countryResidenceId,
        if(stateId!=null)"stateId": stateId,
        "cityId": cityId,
        if(poBox!=null&&poBox.isNotEmpty)"poBox": poBox,
        "addresses": List<dynamic>.from(addresses.map((x) => x.toJson())),
      };
}

class Address {
  int? id;
  int? userId;
  int addressType;
  String street;
  String building;
  String landmark;
  bool isDefault;
  double latitude;
  double longitude;

  Address({
    this.id,
    this.userId,
    required this.addressType,
    required this.street,
    required this.building,
    required this.landmark,
    required this.isDefault,
    required this.latitude,
    required this.longitude,
  });

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        id: json["id"]??0,
        userId: json["userId"]??0,
        addressType: json["addressType"],
        street: json["street"],
        building: json["building"],
        landmark: json["landmark"],
        isDefault: json["isDefault"],
        latitude: json["latitude"],
        longitude: json["longitude"],
      );

  Map<String, dynamic> toJson() => {
        "id": id??0,
        "userId": userId??0,
        "addressType": addressType,
        "street": street,
        "building": building,
        "landmark": landmark,
        "isDefault": isDefault,
        "latitude": latitude,
        "longitude": longitude,
      };
}

class NotificationPreferences {
  int userId;
  bool isEmailNotification;
  bool isSmsNotification;
  bool isInAppNotification;
  int preferredLanguageId;

  NotificationPreferences({
    required this.userId,
    required this.isEmailNotification,
    required this.isSmsNotification,
    required this.isInAppNotification,
    required this.preferredLanguageId,
  });

  factory NotificationPreferences.fromJson(Map<String, dynamic> json) =>
      NotificationPreferences(
        userId: json["userId"],
        isEmailNotification: json["isEmailNotification"],
        isSmsNotification: json["isSMSNotification"],
        isInAppNotification: json["isInAppNotification"],
        preferredLanguageId: json["preferredLanguageId"],
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "isEmailNotification": isEmailNotification,
        "isSMSNotification": isSmsNotification,
        "isInAppNotification": isInAppNotification,
        "preferredLanguageId": preferredLanguageId,
      };
}
