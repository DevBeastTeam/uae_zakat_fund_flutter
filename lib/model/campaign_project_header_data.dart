class CampaignAndProjectsHeaderData {
  int activeProjects;
  int campaignSuccessRate;
  int completedProjectsPercentage;

  CampaignAndProjectsHeaderData({
    required this.activeProjects,
    required this.campaignSuccessRate,
    required this.completedProjectsPercentage,
  });

  factory CampaignAndProjectsHeaderData.fromJson(Map<String, dynamic> json) => CampaignAndProjectsHeaderData(
    activeProjects: json["activeProjects"],
    campaignSuccessRate: json["campaignSuccessRate"],
    completedProjectsPercentage: json["completedProjectsPercentage"],
  );

  Map<String, dynamic> toJson() => {
    "activeProjects": activeProjects,
    "campaignSuccessRate": campaignSuccessRate,
    "completedProjectsPercentage": completedProjectsPercentage,
  };
}
