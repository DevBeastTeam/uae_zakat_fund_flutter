class MoneyTransferred {
  String date;
  String transferId;
  String amount;
  String totalAmount;

  MoneyTransferred({
    required this.date,
    required this.transferId,
    required this.amount,
    required this.totalAmount,
  });

  factory MoneyTransferred.fromJson(Map<String, dynamic> json) => MoneyTransferred(
    date: json["date"],
    transferId: json["transferID"],
    amount: json["amount"],
    totalAmount: json["totalAmount"],
  );

  Map<String, dynamic> toJson() => {
    "date": date,
    "transferID": transferId,
    "amount": amount,
    "totalAmount": totalAmount,
  };
}
