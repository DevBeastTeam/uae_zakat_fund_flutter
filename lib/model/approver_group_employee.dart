class ApproverGroupEmployee {
  int id;
  String firstName;
  String lastName;
  String firstNameArabic;
  String lastNameArabic;
  String userRoleName;
  bool selected;

  ApproverGroupEmployee({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.firstNameArabic,
    required this.lastNameArabic,
    required this.userRoleName,
    required this.selected,
  });

  factory ApproverGroupEmployee.fromJson(Map<String, dynamic> json) => ApproverGroupEmployee(
    id: json["id"],
    firstName: json["firstName"],
    lastName: json["lastName"],
    firstNameArabic: json["firstNameArabic"],
    lastNameArabic: json["lastNameArabic"],
    userRoleName: json["userRoleName"],
    selected: false,
  );

}
