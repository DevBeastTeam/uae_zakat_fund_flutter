class GroupDetails {
  int id;
  int groupId;
  int userId;
  String userName;
  String email;
  String mobile;
  String userNameAr;

  GroupDetails({
    required this.id,
    required this.groupId,
    required this.userId,
    required this.userName,
    required this.email,
    required this.mobile,
    required this.userNameAr,
  });

  factory GroupDetails.fromJson(Map<String, dynamic> json) => GroupDetails(
    id: json["id"],
    groupId: json["groupId"],
    userId: json["userId"],
    userName: json["userName"]??"",
    email: json["email"]??"",
    mobile: json["mobile"]??"",
    userNameAr: json["userNameAr"]??"",
  );

}
