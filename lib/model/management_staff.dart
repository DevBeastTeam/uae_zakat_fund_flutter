
class ManagementStaff {
  int id;
  int accountId;
  String firstName;
  String lastName;
  String firstNameArabic;
  String lastNameArabic;
  String phone;
  String email;
  String jobDescription;
  int nationalityId;
  String emirateId;
  bool emailConfirmed;
  bool phoneNumberConfirmed;
  int accountCategory;
  int roleId;
  int customRoleId;
  bool isDisabled;
  DateTime? createdDate;
  int gender;
  int status;
  bool isActive;

  ManagementStaff({
    required this.id,
    required this.accountId,
    required this.firstName,
    required this.lastName,
    required this.firstNameArabic,
    required this.lastNameArabic,
    required this.phone,
    required this.email,
    required this.jobDescription,
    required this.nationalityId,
    required this.emirateId,
    required this.emailConfirmed,
    required this.phoneNumberConfirmed,
    required this.accountCategory,
    required this.roleId,
    required this.isDisabled,
    required this.createdDate,
    required this.gender,
    required this.status,
    required this.isActive,
    required this.customRoleId,
  });

  ManagementStaff.sahemEmployees({
    required this.id,
    required this.accountId,
    required this.firstName,
    required this.lastName,
    required this.firstNameArabic,
    required this.lastNameArabic,
    required this.phone,
    required this.email,
    required this.jobDescription,
    required this.nationalityId,
    required this.emirateId,
    required this.emailConfirmed,
    required this.phoneNumberConfirmed,
    required this.accountCategory,
    required this.roleId,
    required this.isDisabled,
    required this.createdDate,
    required this.gender,
    required this.status,
    required this.isActive,
    required this.customRoleId,
  });

  factory ManagementStaff.fromJson(Map<String, dynamic> json) => ManagementStaff(
    id: json["id"],
    gender: json["gender"]??1,
    accountId: json["accountID"]??0,
    customRoleId: json["customRoleId"]??0,
    status: json["status"]??0,
    firstName: json["firstName"]??"",
    lastName: json["lastName"]??"",
    firstNameArabic: json["firstNameArabic"]??"",
    lastNameArabic: json["lastNameArabic"]??"",
    phone: json["phone"]??"",
    email: json["email"]??"",
    jobDescription: json["jobDescription"]??"",
    nationalityId: json["nationalityId"]??0,
    emirateId: json["emirateID"]??"",
    emailConfirmed: json["emailConfirmed"],
    phoneNumberConfirmed: json["phoneNumberConfirmed"],
    accountCategory: json["accountCategory"]??0,
    roleId: json["roleId"]??0,
    isDisabled: json["isDisabled"],
    isActive: json["isActive"]??false,
    createdDate: json["createdDate"]!=null?DateTime.parse(json["createdDate"]).toLocal():DateTime.now().toLocal(),
  );

  factory ManagementStaff.fromJson1(Map<String, dynamic> json) => ManagementStaff(
    id: json["id"],
    gender: json["gender"]??1,
    accountId: json["accountID"]??0,
    customRoleId: json["customRoleId"]??0,
    status: json["status"]??0,
    firstName: json["firstName"]??"",
    lastName: json["lastName"]??"",
    firstNameArabic: json["firstNameArabic"]??"",
    lastNameArabic: json["lastNameArabic"]??"",
    phone: json["phone"]??"",
    email: json["email"]??"",
    jobDescription: json["jobDescription"]??"",
    nationalityId: json["nationalityId"]??0,
    emirateId: json["emirateID"]??"",
    emailConfirmed: json["emailConfirmed"],
    phoneNumberConfirmed: json["phoneNumberConfirmed"],
    accountCategory: json["accountCategory"]??0,
    roleId: json["roleId"]??0,
    isDisabled: json["isDisabled"],
    isActive: json["isActive"]??false,
    createdDate: json["createdDate"]!=null?DateTime.parse(json["createdDate"]).toLocal():DateTime.now().toLocal(),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "accountID": accountId,
    "firstName": firstName,
    "lastName": lastName,
    "firstNameArabic": firstNameArabic,
    "lastNameArabic": lastNameArabic,
    "phone": phone,
    "email": email,
    "jobDescription": jobDescription,
    "nationalityId": nationalityId,
    "emirateID": emirateId,
    "emailConfirmed": emailConfirmed,
    "phoneNumberConfirmed": phoneNumberConfirmed,
    "accountCategory": accountCategory,
    "roleId": roleId,
    "isActive": isActive,
    "isDisabled": isDisabled,
  };
}


class SahemEmployees {
  int id;
  String firstName;
  String lastName;
  String firstNameArabic;
  String lastNameArabic;
  bool isActive;

  SahemEmployees({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.firstNameArabic,
    required this.lastNameArabic,
    required this.isActive,
  });

  factory SahemEmployees.fromJson(Map<String, dynamic> json) => SahemEmployees(
    id: json["id"],
    firstName: json["firstName"]??"",
    lastName: json["lastName"]??"",
    firstNameArabic: json["firstNameArabic"]??"",
    lastNameArabic: json["lastNameArabic"]??"",
    isActive: json["isActive"]??false,
  );

}