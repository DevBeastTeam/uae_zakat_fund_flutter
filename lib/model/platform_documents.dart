class PlatformDocuments {
  int id;
  String documentName;
  int documentType;
  int documentAssociatedWith;
  String dateType;
  dynamic path;
  dynamic accountId;
  dynamic projectId;
  bool isRequired;
  bool requiresDate;
  String startDate;
  String endDate;
  String allowedFileTypes;
  DateTime createdDate;
  int createdBy;
  dynamic createdByUser;
  DateTime modifiedDate;
  int modifiedBy;
  dynamic deletedDate;
  dynamic deletedBy;
  int objectState;
  bool isDeleted;
  bool isActive;
  String documentNameAr;
  String startDateAr;
  String endDateAr;

  PlatformDocuments({
    required this.id,
    required this.documentName,
    required this.documentType,
    required this.documentAssociatedWith,
    required this.dateType,
    required this.path,
    required this.accountId,
    required this.projectId,
    required this.isRequired,
    required this.requiresDate,
    required this.startDate,
    required this.endDate,
    required this.allowedFileTypes,
    required this.createdDate,
    required this.createdBy,
    required this.createdByUser,
    required this.modifiedDate,
    required this.modifiedBy,
    required this.deletedDate,
    required this.deletedBy,
    required this.objectState,
    required this.isDeleted,
    required this.isActive,
    required this.documentNameAr,
    required this.startDateAr,
    required this.endDateAr,
  });

  factory PlatformDocuments.fromJson(Map<String, dynamic> json) => PlatformDocuments(
    documentNameAr: json["documentNameAr"]??"",
    startDateAr: json["startDateAr"]??"",
    endDateAr: json["endDateAr"]==null?"":", ${json["endDateAr"]}",
    id: json["id"],
    documentName: json["documentName"],
    documentType: json["documentType"],
    documentAssociatedWith: json["documentAssociatedWith"],
    dateType: json["dateType"],
    path: json["path"],
    accountId: json["accountID"],
    projectId: json["projectID"],
    isRequired: json["isRequired"],
    requiresDate: json["requiresDate"],
    startDate: json["startDate"]??"",
    endDate: json["endDate"]==null?"":", ${json["endDate"]}",
    allowedFileTypes: json["allowedFileTypes"],
    createdDate: DateTime.parse(json["createdDate"]),
    createdBy: json["createdBy"],
    createdByUser: json["createdByUser"],
    modifiedDate: DateTime.parse(json["modifiedDate"]),
    modifiedBy: json["modifiedBy"],
    deletedDate: json["deletedDate"],
    deletedBy: json["deletedBy"],
    objectState: json["objectState"],
    isDeleted: json["isDeleted"],
    isActive: json["isActive"],
  );

}
