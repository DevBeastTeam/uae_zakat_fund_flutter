class MyRefund {
  int id;
  String sessionId;
  DateTime createdDate;
  int refundType;
  double refundAmount;
  int requestStatus;
  String projectName;
  String projectNameArabic;

  MyRefund({
    required this.id,
    required this.sessionId,
    required this.createdDate,
    required this.refundType,
    required this.refundAmount,
    required this.requestStatus,
    required this.projectName,
    required this.projectNameArabic,
  });

  factory MyRefund.fromJson(Map<String, dynamic> json) => MyRefund(
    id: json["id"],
    sessionId: json["sessionId"],
    createdDate: DateTime.parse(json["createdDate"]),
    refundType: json["refundType"],
    refundAmount: json["refundAmount"],
    requestStatus: json["requestStatus"],
    projectName: json["projectName"],
    projectNameArabic: json["projectNameArabic"]??"",
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "sessionId": sessionId,
    "createdDate": createdDate.toIso8601String(),
    "refundType": refundType,
    "refundAmount": refundAmount,
    "requestStatus": requestStatus,
  };
}
