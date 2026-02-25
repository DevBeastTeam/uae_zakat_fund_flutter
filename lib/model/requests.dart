class Requests {
  int id;
  String requesterName;
  String requestType;
  int priority;
  int userRequestId;
  int status;
  int accountID;
  int entityId;
  int? roleId;
  DateTime createdDate;
  String? sessionId;
  String requestTypeAr;
  String requesterNameAr;
  String? rejectNote;
  String? rejectReason;
  String? rejectionDocument;
  int? slaStatus;
  int? currentLevel;
  String elapsedTime;
  dynamic assignedTo;
  int? auditLogId;
  DateTime? slaDeadline;
  bool isClosed;

  Requests({
    required this.id,
    required this.auditLogId,
    required this.requesterName,
    required this.requestType,
    required this.priority,
    required this.status,
    required this.entityId,
    required this.roleId,
    required this.rejectReason,
    required this.createdDate,
    required this.sessionId,
    required this.accountID,
    required this.requesterNameAr,
    required this.requestTypeAr,
    this.rejectNote,
    this.rejectionDocument,
    required this.userRequestId,
    required this.slaStatus,
    required this.currentLevel,
    required this.elapsedTime,
    required this.slaDeadline,
    required this.assignedTo,
    required this.isClosed,
  });

  factory Requests.fromJson(Map<String, dynamic> json) => Requests(
        id: json["id"],
        requesterName: json["requesterName"] ?? "",
        requestType: json["requestType"] ?? json["taskType"],
        priority: json["priority"] ?? json["tasksPriority"],
        status: json["status"] ?? json["tasksStatus"],
        entityId: json["entityId"],
    assignedTo: json["assignedTo"]??"",
        userRequestId: json["userRequestId"] ?? 0,
        accountID: json["accountID"] ?? 0,
        roleId: json["roleId"],
        sessionId: json["sessionId"],
        rejectNote: json["rejectNote"],
    auditLogId: json["auditLogId"],
    rejectReason: json["rejectReason"],
        rejectionDocument: json["rejectionDocument"],
        requesterNameAr: json["requesterNameAr"] ?? "",
        requestTypeAr: json["requestTypeAr"] ?? "",
        createdDate: DateTime.parse(json["createdDate"]).toLocal(),
    slaDeadline: json["slaDeadline"]!=null?DateTime.parse(json["slaDeadline"]).toLocal():null,
        slaStatus: json["slaStatusId"],
        currentLevel: json["currentLevelId"],
        elapsedTime: json["elapsedTime"]??"",
    isClosed: json["isClosed"]??false,
      );
}
