
class Transactions {
  int id;
  dynamic userId;
  double amount;
  dynamic associationId;
  dynamic status;
  String? sessionId;
  DateTime createdDate;
  String? createdBy;
  double totalAmount;
  String zfTransactionId;
  int paymentType;
  dynamic collectionDate;
  dynamic collectionTime;
  dynamic collectionPoint;
  dynamic bankId;
  dynamic chequeNo;
  dynamic chequePhoto;
  dynamic chequeDate;
  dynamic firstName;
  dynamic lastName;
  dynamic emailAddress;
  dynamic phoneNumber;
  dynamic payersName;
  int requestStatus;
  bool isRefundApplied;

  Transactions({
    required this.id,
    required this.requestStatus,
    required this.userId,
    required this.amount,
    required this.associationId,
    required this.status,
    required this.sessionId,
    required this.createdDate,
    required this.createdBy,
    required this.totalAmount,
    required this.zfTransactionId,
    required this.paymentType,
    required this.collectionDate,
    required this.collectionTime,
    required this.collectionPoint,
    required this.bankId,
    required this.chequeNo,
    required this.chequePhoto,
    required this.chequeDate,
    required this.firstName,
    required this.lastName,
    required this.emailAddress,
    required this.phoneNumber,
    required this.payersName,
    required this.isRefundApplied,
  });

  factory Transactions.fromJson(Map<String, dynamic> json) => Transactions(
    id: json["id"],
    userId: json["userId"],
    amount: json["amount"],
    requestStatus: json["requestStatus"],

    associationId: json["associationId"],
    isRefundApplied: json["isRefundApplied"]??false,
    status: json["status"],
    sessionId: json["sessionId"],
    createdDate: DateTime.parse(json["createdDate"]),
    createdBy: json["createdBy"],
    totalAmount: json["totalAmount"],
    zfTransactionId: json["zfTransactionId"]??json["newTransactionId"]??"",
    paymentType: json["paymentType"],
    collectionDate: json["collectionDate"],
    collectionTime: json["collectionTime"],
    collectionPoint: json["collectionPoint"],
    bankId: json["bankId"],
    chequeNo: json["chequeNo"],
    chequePhoto: json["chequePhoto"],
    chequeDate: json["chequeDate"],
    firstName: json["firstName"],
    lastName: json["lastName"],
    emailAddress: json["emailAddress"],
    phoneNumber: json["phoneNumber"],
    payersName: json["payersName"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "userId": userId,
    "amount": amount,
    "associationId": associationId,
    "status": status,
    "sessionId": sessionId,
    "createdDate": createdDate.toIso8601String(),
    "createdBy": createdBy,
    "totalAmount": totalAmount,
    "zfTransactionId": zfTransactionId,
    "paymentType": paymentType,
    "collectionDate": collectionDate,
    "collectionTime": collectionTime,
    "collectionPoint": collectionPoint,
    "bankId": bankId,
    "chequeNo": chequeNo,
    "chequePhoto": chequePhoto,
    "chequeDate": chequeDate,
    "firstName": firstName,
    "lastName": lastName,
    "emailAddress": emailAddress,
    "phoneNumber": phoneNumber,
    "payersName": payersName,
  };
}
