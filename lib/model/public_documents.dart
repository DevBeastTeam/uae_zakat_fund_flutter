class PublicDocuments {
  int id;
  String documentName;
  String documentNameAr;
  dynamic accountName;
  dynamic accountNameAr;
  dynamic accountId;
  String userName;
  String userNameAr;
  int documentType;
  dynamic documentAssociatedWith;
  int uploadedBy;
  DateTime uploadedDate;
  String? url;
  bool isActive;

  PublicDocuments({
    required this.id,
    required this.documentName,
    required this.documentNameAr,
    required this.accountName,
    required this.accountId,
    required this.userName,
    required this.documentType,
    required this.documentAssociatedWith,
    required this.uploadedBy,
    required this.uploadedDate,
    required this.url,
    required this.isActive,
    required this.accountNameAr,
    required this.userNameAr,
  });

  factory PublicDocuments.fromJson(Map<String, dynamic> json) =>
      PublicDocuments(
        id: json["id"],
        documentName: json["documentName"],
        documentNameAr: json["documentNameAr"]??"",
        userNameAr: json["userNameAr"]??"",
        accountNameAr: json["accountNameAr"]??"",
        accountName: json["accountName"],
        accountId: json["accountId"],
        userName: json["userName"],
        documentType: json["documentType"]??0,
        documentAssociatedWith: json["documentAssociatedWith"],
        uploadedBy: json["uploadedBy"],
        uploadedDate: DateTime.parse(json["uploadedDate"]),
        url: json["url"],
        isActive: json["isActive"]??false,
      );
}
