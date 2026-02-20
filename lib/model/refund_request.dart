class RefundRequest {
  int id;

  int projectId;
  int userId;
  double amount;
  String zfTransactionId;
  dynamic status;
  String sessionId;
  String projectName;
  DateTime createdDate;
  String createdBy;
  int refundType;
  double refundAmount;
  int requestStatus;

  RefundRequest({
    required this.id,
    required this.projectId,
    required this.userId,
    required this.amount,
    required this.zfTransactionId,
    required this.status,
    required this.sessionId,
    required this.projectName,
    required this.createdDate,
    required this.createdBy,
    required this.refundType,
    required this.refundAmount,
    required this.requestStatus,
  });

  factory RefundRequest.fromJson(Map<String, dynamic> json) => RefundRequest(
    id: json["id"],
    requestStatus: json["requestStatus"]??0,
    projectId: json["projectId"],
    userId: json["userId"],
    amount: json["amount"],
    zfTransactionId: json["zfTransactionId"]??"",
    status: json["status"],
    sessionId: json["sessionId"]??"",
    projectName: json["projectName"],
    createdDate: DateTime.parse(json["createdDate"]).toLocal(),
    createdBy: json["createdBy"],
    refundType: json["refundType"],
    refundAmount: json["refundAmount"],
  );

}
