
class Recipients {
  int id;
  int campaignId;
  int userId;
  dynamic detail;
  bool isSend;
  String? fromAddress;
  String toAddress;
  String type;
  String userName;
  DateTime createdDate;
  String language;

  Recipients({
    required this.id,
    required this.campaignId,
    required this.userId,
    required this.detail,
    required this.isSend,
    required this.fromAddress,
    required this.toAddress,
    required this.type,
    required this.userName,
    required this.createdDate,
    required this.language,
  });

  factory Recipients.fromJson(Map<String, dynamic> json) => Recipients(
    id: json["id"],
    campaignId: json["campaignId"],
    userId: json["userID"],
    detail: json["detail"],
    isSend: json["isSend"],
    fromAddress: json["fromAddress"],
    toAddress: json["toAddress"],
    type: json["type"],
    userName: json["userName"],
    createdDate: DateTime.parse(json["createdDate"]).toLocal(),
    language: json["language"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "campaignId": campaignId,
    "userID": userId,
    "detail": detail,
    "isSend": isSend,
    "fromAddress": fromAddress,
    "toAddress": toAddress,
    "type": type,
    "userName": userName,
    "createdDate": createdDate.toIso8601String(),
    "language": language,
  };
}
