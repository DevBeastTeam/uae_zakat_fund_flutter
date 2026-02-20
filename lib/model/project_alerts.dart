class ProjectAlerts {
  String? notificationMethods;
  List<ProjectAlertsDetail> projectAlertsDetails;

  ProjectAlerts({
    required this.notificationMethods,
    required this.projectAlertsDetails,
  });

  factory ProjectAlerts.fromJson(Map<String, dynamic> json) => ProjectAlerts(
    notificationMethods: json["notificationMethods"],
    projectAlertsDetails: json["projectAlertsDetails"]!=null?List<ProjectAlertsDetail>.from(json["projectAlertsDetails"].map((x) => ProjectAlertsDetail.fromJson(x))):[],
  );


}

class ProjectAlertsDetail {
  int projectAlertId;
  int projectCategoryId;
  int projectAlertFrequency;

  ProjectAlertsDetail({
    required this.projectAlertId,
    required this.projectCategoryId,
    required this.projectAlertFrequency,
  });

  factory ProjectAlertsDetail.fromJson(Map<String, dynamic> json) => ProjectAlertsDetail(
    projectAlertId: json["projectAlertId"],
    projectCategoryId: json["projectCategoryId"],
    projectAlertFrequency: json["projectAlertFrequency"],
  );

  Map<String, dynamic> toJson() => {
    "projectAlertId": projectAlertId,
    "projectCategoryId": projectCategoryId,
    "projectAlertFrequency": projectAlertFrequency,
  };
}
