class DonorDashboardData {
  int numberOfProjectDonated;
  double totalContribution;
  int totalBeneficiaries;
  double totalRefund;

  DonorDashboardData({
    required this.numberOfProjectDonated,
    required this.totalContribution,
    required this.totalBeneficiaries,
    required this.totalRefund,
  });

  factory DonorDashboardData.fromJson(Map<String, dynamic> json) =>
      DonorDashboardData(
        numberOfProjectDonated: json["numberOfProjectDonated"] ?? 0,
        totalContribution: json["totalContribution"] ?? 0,
        totalBeneficiaries: json["totalBeneficiaries"] ?? 0,
        totalRefund: json["totalRefund"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "numberOfProjectDonated": numberOfProjectDonated,
        "totalContribution": totalContribution,
        "totalBeneficiaries": totalBeneficiaries,
        "totalRefund": totalRefund,
      };
}
