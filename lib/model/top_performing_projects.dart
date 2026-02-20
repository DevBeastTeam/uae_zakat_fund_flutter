class TopPerformingProjects {
  int projectId;
  String projectName;
  String projectNameArabic;
  double targetedAmount;
  double raisedAmount;
  int successPercentage;

  TopPerformingProjects({
    required this.projectId,
    required this.projectName,
    required this.projectNameArabic,
    required this.targetedAmount,
    required this.raisedAmount,
    required this.successPercentage,
  });

  factory TopPerformingProjects.fromJson(Map<String, dynamic> json) => TopPerformingProjects(
    projectId: json["projectID"],
    projectName: json["projectName"],
    projectNameArabic: json["projectNameArabic"],
    targetedAmount: json["targetedAmount"],
    raisedAmount: json["raisedAmount"],
    successPercentage: json["successPercentage"],
  );

  Map<String, dynamic> toJson() => {
    "projectID": projectId,
    "projectName": projectName,
    "projectNameArabic": projectNameArabic,
    "targetedAmount": targetedAmount,
    "raisedAmount": raisedAmount,
    "successPercentage": successPercentage,
  };
}
