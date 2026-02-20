
class TaskDetails {
  int id;
  String requesterName;
  String requestType;
  String requesterNameAr;
  String requestTypeAr;
  int priority;
  String assignedTo;
  int status;
  int entityId;
  dynamic action;
  int roleId;
  DateTime createdDate;
  dynamic sessionId;
  dynamic rejectNote;
  dynamic rejectionDocument;
  DateTime collectionDate;
  String collectionTime;
  String collectionPoint;
  double totalAmount;

  TaskDetails({
    required this.id,
    required this.requesterName,
    required this.requestType,
    required this.requesterNameAr,
    required this.requestTypeAr,
    required this.priority,
    required this.assignedTo,
    required this.status,
    required this.entityId,
    required this.action,
    required this.roleId,
    required this.createdDate,
    required this.sessionId,
    required this.rejectNote,
    required this.rejectionDocument,
    required this.collectionDate,
    required this.collectionTime,
    required this.collectionPoint,
    required this.totalAmount,
  });

  factory TaskDetails.fromJson(Map<String, dynamic> json) => TaskDetails(
    id: json["id"],
    requesterName: json["requesterName"],
    requestType: json["requestType"],
    requesterNameAr: json["requesterNameAr"],
    requestTypeAr: json["requestTypeAr"],
    priority: json["priority"],
    assignedTo: json["assignedTo"],
    status: json["status"],
    entityId: json["entityId"],
    action: json["action"],
    roleId: json["roleId"],
    createdDate: DateTime.parse(json["createdDate"]),
    sessionId: json["sessionId"],
    rejectNote: json["rejectNote"],
    rejectionDocument: json["rejectionDocument"],
    collectionDate: DateTime.parse(json["collectionDate"]),
    collectionTime: json["collectionTime"],
    collectionPoint: json["collectionPoint"],
    totalAmount: json["totalAmount"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "requesterName": requesterName,
    "requestType": requestType,
    "requesterNameAr": requesterNameAr,
    "requestTypeAr": requestTypeAr,
    "priority": priority,
    "assignedTo": assignedTo,
    "status": status,
    "entityId": entityId,
    "action": action,
    "roleId": roleId,
    "createdDate": createdDate.toIso8601String(),
    "sessionId": sessionId,
    "rejectNote": rejectNote,
    "rejectionDocument": rejectionDocument,
    "collectionDate": collectionDate.toIso8601String(),
    "collectionTime": collectionTime,
    "collectionPoint": collectionPoint,
    "totalAmount": totalAmount,
  };
}
