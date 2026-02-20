
class DonationHistory {
  int id;
  dynamic sessionId;
  String zfTransactionId;
  DateTime createdDate;
  double payment;
  int paymentType;
  int requestStatus;

  DonationHistory({
    required this.id,
    required this.sessionId,
    required this.zfTransactionId,
    required this.createdDate,
    required this.payment,
    required this.paymentType,
    required this.requestStatus,
  });

  factory DonationHistory.fromJson(Map<String, dynamic> json) => DonationHistory(
    id: json["id"],
    sessionId: json["sessionId"],
    zfTransactionId: json["zfTransactionId"],
    createdDate: DateTime.parse(json["createdDate"]),
    payment: json["payment"],
    paymentType: json["paymentType"],
    requestStatus: json["requestStatus"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "sessionId": sessionId,
    "zfTransactionId": zfTransactionId,
    "createdDate": createdDate.toIso8601String(),
    "payment": payment,
    "paymentType": paymentType,
    "requestStatus": requestStatus,
  };
}
