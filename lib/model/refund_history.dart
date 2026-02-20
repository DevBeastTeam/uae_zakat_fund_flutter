class RefundHistory {
  int id;
  String zfTransactionId;
  String sessionId;
  String projectName;
  String projectNameArabic;
  DateTime createdDate;
  double amount;
  double refundAmount;
  int refundType;
  int requestStatus;

  RefundHistory({
    required this.id,
    required this.sessionId,
    required this.projectName,
    required this.projectNameArabic,
    required this.createdDate,
    required this.amount,
    required this.refundAmount,
    required this.refundType,
    required this.requestStatus,
    required this.zfTransactionId,
  });

  factory RefundHistory.fromJson(Map<String, dynamic> json) => RefundHistory(
    id: json["id"],
    sessionId: json["sessionId"],
    zfTransactionId: json["zfTransactionId"]??"",
    projectName: json["projectName"],
    projectNameArabic: json["projectNameArabic"],
    createdDate: DateTime.parse(json["createdDate"]),
    amount: json["amount"],
    refundAmount: json["refundAmount"],
    refundType: json["refundType"],
    requestStatus: json["requestStatus"]??1,
  );

}
