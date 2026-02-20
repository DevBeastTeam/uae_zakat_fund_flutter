class ApproverGroups {
  int id;
  String groupName;
  String groupNameArabic;
  String groupDescription;
  bool status;
  List<int> userId;
  DateTime createdDate;

  ApproverGroups({
    required this.id,
    required this.groupName,
    required this.groupNameArabic,
    required this.groupDescription,
    required this.status,
    required this.userId,
    required this.createdDate,
  });

  factory ApproverGroups.fromJson(Map<String, dynamic> json) => ApproverGroups(
    id: json["id"],
    groupName: json["groupName"],
    groupNameArabic: json["groupNameArabic"],
    groupDescription: json["groupDescription"],
    status: json["status"],
    createdDate: json["createdDate"]!=null?DateTime.parse(json["createdDate"]):DateTime.now(),
    userId: json["userId"]!=null?List<int>.from(json["userId"].map((x) => x)):[],
  );

}
