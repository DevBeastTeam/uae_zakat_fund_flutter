class CampaignFundingGap {
  int projectId;
  String projectName;
  String projectNameArabic;
  double targetedAmount;
  double collectedAmount;
  double fundingGap;

  CampaignFundingGap({
    required this.projectId,
    required this.projectName,
    required this.projectNameArabic,
    required this.targetedAmount,
    required this.collectedAmount,
    required this.fundingGap,
  });

  factory CampaignFundingGap.fromJson(Map<String, dynamic> json) => CampaignFundingGap(
    projectId: json["projectID"],
    projectName: json["projectName"],
    projectNameArabic: json["projectNameArabic"],
    targetedAmount: json["targetedAmount"],
    collectedAmount: json["collectedAmount"],
    fundingGap: json["fundingGap"],
  );

  Map<String, dynamic> toJson() => {
    "projectID": projectId,
    "projectName": projectName,
    "projectNameArabic": projectNameArabic,
    "targetedAmount": targetedAmount,
    "collectedAmount": collectedAmount,
    "fundingGap": fundingGap,
  };
}
