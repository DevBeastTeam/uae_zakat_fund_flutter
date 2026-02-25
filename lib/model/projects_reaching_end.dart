class ProjectsReachingEnd {
  int projectId;
  String projectName;
  String projectNameArabic;
  double targetedAmount;
  double collectedAmount;
  DateTime endDate;

  ProjectsReachingEnd({
    required this.projectId,
    required this.projectName,
    required this.projectNameArabic,
    required this.targetedAmount,
    required this.collectedAmount,
    required this.endDate,
  });

  factory ProjectsReachingEnd.fromJson(Map<String, dynamic> json) => ProjectsReachingEnd(
    projectId: json["projectID"],
    projectName: json["projectName"],
    projectNameArabic: json["projectNameArabic"],
    targetedAmount: json["targetedAmount"],
    collectedAmount: json["collectedAmount"],
    endDate: DateTime.parse(json["endDate"]),
  );

  Map<String, dynamic> toJson() => {
    "projectID": projectId,
    "projectName": projectName,
    "projectNameArabic": projectNameArabic,
    "targetedAmount": targetedAmount,
    "collectedAmount": collectedAmount,
    "endDate": endDate.toIso8601String(),
  };
}
