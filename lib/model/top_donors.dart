class TopDonors {
  int userId;
  String firstName;
  String? firstNameArabic;
  String lastName;
  String email;
  String? lastNameArabic;
  double totalContributions;
  String mobile;

  TopDonors({
    required this.userId,
    required this.firstName,
    required this.firstNameArabic,
    required this.lastName,
    required this.lastNameArabic,
    required this.totalContributions,
    required this.email,
    required this.mobile,
  });

  factory TopDonors.fromJson(Map<String, dynamic> json) => TopDonors(
    userId: json["userID"],
    firstName: json["firstName"]??"",
    firstNameArabic: json["firstNameArabic"]??"",
    lastName: json["lastName"]??"",
    email: json["email"]??"",
    lastNameArabic: json["lastNameArabic"]??"",
    totalContributions: json["totalContributions"],
    mobile: json["mobile"]??"",
  );

  Map<String, dynamic> toJson() => {
    "userID": userId,
    "firstName": firstName,
    "firstNameArabic": firstNameArabic,
    "lastName": lastName,
    "lastNameArabic": lastNameArabic,
    "totalContributions": totalContributions,
  };
}
