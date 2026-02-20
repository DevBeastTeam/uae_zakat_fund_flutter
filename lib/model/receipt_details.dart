
class ReceiptDetails {
  int id;
  String donorName;
  DateTime createdDate;
  String mobile;
  String email;
  String transactionId;
  double totalAmount;
  List<Detail> projects;
  dynamic paymentType;
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
  bool isRefunded;
  int requestStatus;
  int taskStatus;
  String uniqueCode;
  String donorNameAr;


  ReceiptDetails({
    required this.id,
    required this.donorName,
    required this.createdDate,
    required this.mobile,
    required this.email,
    required this.transactionId,
    required this.totalAmount,
    required this.projects,
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
    required this.isRefunded,
    required this.requestStatus,
    required this.uniqueCode,
    required this.donorNameAr,
    required this.taskStatus,
  });

  factory ReceiptDetails.fromJson(Map<String, dynamic> json) => ReceiptDetails(
    id: json["id"],
    uniqueCode: json["uniqueCode"]??"",
    donorName: json["donorName"]??"",
    donorNameAr: json["donorNameAr"]??"",
    createdDate: DateTime.parse(json["createdDate"]).toLocal(),
    mobile: json["mobile"]??"",
    email: json["email"]??"",
    requestStatus: json["requestStatus"]??0,
    taskStatus: json["taskStatus"]??0,
    transactionId: json["transactionId"],
    totalAmount: json["totalAmount"],
    projects: List<Detail>.from(json["details"].map((x) => Detail.fromJson(x))),
    paymentType: json["paymentType"],
    collectionDate: json["collectionDate"]!=null?DateTime.parse(json["collectionDate"]).toLocal():null,
    collectionTime: json["collectionTime"],
    collectionPoint: json["collectionPoint"],
    bankId: json["bankId"],
    chequeNo: json["chequeNo"],
    chequePhoto: json["chequePhoto"],
    chequeDate: json["chequeDate"]!=null?DateTime.parse(json["chequeDate"]).toLocal():DateTime.now(),
    firstName: json["firstName"]??"",
    lastName: json["lastName"]??"",
    emailAddress: json["emailAddress"]??"",
    phoneNumber: json["phoneNumber"]??"",
    payersName: json["payersName"]??"",
    isRefunded: json["isRefunded"]??false,
  );

}

class Detail {
  int id;
  int projectId;
  double amount;
  dynamic status;
  String? sessionId;
  String projectName;
  String projectNameArabic;
  DateTime createdDate;
  dynamic createdBy;
  dynamic refundType;
  double? refundAmount;
  dynamic email;
  dynamic zfTransactionId;

  Detail({
    required this.id,
    required this.projectId,
    required this.amount,
    required this.status,
    required this.sessionId,
    required this.projectName,
    required this.createdDate,
    required this.createdBy,
    required this.refundType,
    required this.refundAmount,
    required this.email,
    required this.projectNameArabic,
    required this.zfTransactionId,
  });

  factory Detail.fromJson(Map<String, dynamic> json) => Detail(
    id: json["id"],
    projectId: json["projectId"],
    amount: json["amount"],
    status: json["status"],
    sessionId: json["sessionId"],
    projectName: json["projectName"],
    projectNameArabic: json["projectNameArabic"]??"",
    createdDate: DateTime.parse(json["createdDate"]).toLocal(),
    createdBy: json["createdBy"],
    refundType: json["refundType"],
    refundAmount: json["refundAmount"],
    email: json["email"],
    zfTransactionId: json["zfTransactionId"],
  );

}
