
class AssociationDashboardData {
  int totalProjects;
  double targetedAmount;
  double amountReceived;
  double amountTransferred;
  double availableBalance;
  int activeProjects;

  AssociationDashboardData({
    required this.totalProjects,
    required this.targetedAmount,
    required this.amountReceived,
    required this.amountTransferred,
    required this.availableBalance,
    required this.activeProjects,
  });

  factory AssociationDashboardData.fromJson(Map<String, dynamic> json) => AssociationDashboardData(
    totalProjects: json["totalProjects"]??0,
    targetedAmount: json["targetedAmount"]??0,
    amountReceived: json["amountReceived"]??0,
    amountTransferred: json["amountTransferred"]??0,
    availableBalance: json["availableBalance"]??0,
    activeProjects: json["activeProjects"]??0,
  );

  Map<String, dynamic> toJson() => {
    "totalProjects": totalProjects,
    "targetedAmount": targetedAmount,
    "amountReceived": amountReceived,
    "amountTransferred": amountTransferred,
    "availableBalance": availableBalance,
    "activeProjects": activeProjects,
  };
}

class AssociationAverageSummary {
  double averageDonationPerDonor;
  double refundedDonations;
  double totalDonations;
  double availableBalance;
  double pendingTransfers;
  double transferredAmount;

  AssociationAverageSummary({
    required this.averageDonationPerDonor,
    required this.refundedDonations,
    required this.totalDonations,
    required this.availableBalance,
    required this.pendingTransfers,
    required this.transferredAmount,
  });

  factory AssociationAverageSummary.fromJson(Map<String, dynamic> json) => AssociationAverageSummary(
    averageDonationPerDonor: json["averageDonationPerDonor"]??0,
    refundedDonations: json["refundedDonations"]??0,
    totalDonations: json["totalDonations"]??0,
    availableBalance: json["availableBalance"]??0,
    pendingTransfers: json["pendingTransfers"]??0,
    transferredAmount: json["transferredAmount"]??0,
  );

  Map<String, dynamic> toJson() => {
    "averageDonationPerDonor": averageDonationPerDonor,
    "refundedDonations": refundedDonations,
  };
}

