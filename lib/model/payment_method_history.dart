class PaymentMethodHistory {
  String paymentType;
  double totalAmount;

  PaymentMethodHistory({
    required this.paymentType,
    required this.totalAmount,
  });

  factory PaymentMethodHistory.fromJson(Map<String, dynamic> json) => PaymentMethodHistory(
    paymentType: json["paymentType"],
    totalAmount: json["totalAmount"],
  );

  Map<String, dynamic> toJson() => {
    "paymentType": paymentType,
    "totalAmount": totalAmount,
  };
}
