class DonationsSummary {
  int numberOfProjectDonated;
  int totalContribution;
  int totalBeneficiaries;
  int totalRefund;

  DonationsSummary({
    required this.numberOfProjectDonated,
    required this.totalContribution,
    required this.totalBeneficiaries,
    required this.totalRefund,
  });

  factory DonationsSummary.fromJson(Map<String, dynamic> json) => DonationsSummary(
    numberOfProjectDonated: json["numberOfProjectDonated"],
    totalContribution: json["totalContribution"],
    totalBeneficiaries: json["totalBeneficiaries"],
    totalRefund: json["totalRefund"],
  );

  Map<String, dynamic> toJson() => {
    "numberOfProjectDonated": numberOfProjectDonated,
    "totalContribution": totalContribution,
    "totalBeneficiaries": totalBeneficiaries,
    "totalRefund": totalRefund,
  };
}
