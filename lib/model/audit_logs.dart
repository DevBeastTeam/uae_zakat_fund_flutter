class AuditLogs {
  int id;
  String nameEn;
  String nameAr;
  String actionEn;
  String actionAr;
  String entityTypeEn;
  String entityTypeAr;
  int entityId;
  String userRole;
  String ipAddress;
  String status;
  String comments;
  String commentsAr;
  DateTime createdDate;
  List<AuditLogDetail> auditLogDetails;

  AuditLogs({
    required this.id,
    required this.nameEn,
    required this.nameAr,
    required this.actionEn,
    required this.actionAr,
    required this.entityTypeEn,
    required this.entityTypeAr,
    required this.entityId,
    required this.userRole,
    required this.ipAddress,
    required this.status,
    required this.comments,
    required this.commentsAr,
    required this.createdDate,
    required this.auditLogDetails,
  });

  factory AuditLogs.fromJson(Map<String, dynamic> json) => AuditLogs(
        id: json["id"],
        nameEn: json["nameEn"]??"",
        nameAr: json["nameAr"]??"",
        actionEn: json["actionEn"]??"",
        actionAr: json["actionAr"]??"",
        entityTypeEn: json["entityTypeEn"]??"",
        entityTypeAr: json["entityTypeAr"]??"",
        entityId: json["entityID"]??0,
        userRole: json["userRole"]??"",
        ipAddress: json["ipAddress"]??"",
        status: json["status"]??"",
        comments: json["comments"]??"",
    commentsAr: json["commentsAr"]??"",
        createdDate: DateTime.parse(json["createdDate"]).toLocal(),
        auditLogDetails: List<AuditLogDetail>.from(
            json["auditLogDetails"].map((x) => AuditLogDetail.fromJson(x))),
      );
}

class AuditLogDetail {
  int id;
  int auditLogId;
  String fieldName;
  String oldValue;
  String newValue;

  AuditLogDetail({
    required this.id,
    required this.auditLogId,
    required this.fieldName,
    required this.oldValue,
    required this.newValue,
  });

  factory AuditLogDetail.fromJson(Map<String, dynamic> json) => AuditLogDetail(
        id: json["id"]??0,
        auditLogId: json["auditLogId"]??0,
        fieldName: json["fieldName"]??"",
        oldValue: json["oldValue"]??"",
        newValue: json["newValue"]??"",
      );
}
