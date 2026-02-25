
class AssociationDonations{
  int projectId;
  String projectName;
  String projectNameArabic;
  double targetedAmount;
  double collectedAmount;
  double totalTransfer;
  double availableBalance;

  AssociationDonations({
    required this.projectId,
    required this.projectName,
    required this.projectNameArabic,
    required this.targetedAmount,
    required this.collectedAmount,
    required this.totalTransfer,
    required this.availableBalance,
  });

  factory AssociationDonations.fromJson(Map<String, dynamic> json) => AssociationDonations(
    projectId: json["projectID"],
    projectName: json["projectName"],
    projectNameArabic: json["projectNameArabic"],
    targetedAmount: json["targetedAmount"]??0,
    collectedAmount: json["collectedAmount"]??0,
    totalTransfer: json["totalTransfer"]??0,
    availableBalance: json["collectedAmount"]??0-json["totalTransfer"]??0,
  );



  Map<String, dynamic> toJson() => {
    "projectID": projectId,
    "projectName": projectName,
    "projectNameArabic": projectNameArabic,
    "targetedAmount": targetedAmount,
    "collectedAmount": collectedAmount,
    "totalTransfer": totalTransfer,
    "availableBalance": availableBalance,
  };
}
