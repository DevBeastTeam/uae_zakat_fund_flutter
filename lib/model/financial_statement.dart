
class FinancialStatementBalance {
  double overAllCollectedDonations;
  double initialFundBalance;
  double overAllMoneyTransferredTillDate;

  FinancialStatementBalance({
    required this.overAllCollectedDonations,
    required this.initialFundBalance,
    required this.overAllMoneyTransferredTillDate,
  });

  factory FinancialStatementBalance.fromJson(Map<String, dynamic> json) => FinancialStatementBalance(
    overAllCollectedDonations: json["overAllCollectedDonations"],
    initialFundBalance: json["initialFundBalance"],
    overAllMoneyTransferredTillDate: json["overAllMoneyTransferredTillDate"],
  );

  Map<String, dynamic> toJson() => {
    "overAllCollectedDonations": overAllCollectedDonations,
    "initialFundBalance": initialFundBalance,
    "overAllMoneyTransferredTillDate": overAllMoneyTransferredTillDate,
  };
}

class FinancialStatementByMonth {
  int projectId;
  String projectName;
  String projectNameAr;
  String year;
  String month;
  String monthName;
  String totalAmount;
  bool isExpanded;

  FinancialStatementByMonth({
    required this.projectId,
    required this.projectName,
    required this.projectNameAr,
    required this.year,
    required this.month,
    required this.monthName,
    required this.totalAmount,
    required this.isExpanded,
  });

  factory FinancialStatementByMonth.fromJson(Map<String, dynamic> json) => FinancialStatementByMonth(
    projectId: json["projectId"],
    projectName: json["projectName"],
    projectNameAr: json["projectNameAr"],
    year: json["year"],
    month: json["month"],
    monthName: json["monthName"],
      isExpanded:false,
    totalAmount: json["totalAmount"].replaceAll("٫","."),
  );

  Map<String, dynamic> toJson() => {
    "projectId": projectId,
    "projectName": projectName,
    "projectNameAr": projectNameAr,
    "year": year,
    "month": month,
    "monthName": monthName,
    "totalAmount": totalAmount,
  };
}
