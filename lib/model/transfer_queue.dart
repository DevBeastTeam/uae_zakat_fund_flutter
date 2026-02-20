class TransferQueue {
  int total;
  int accepted;
  int pending;
  int rejected;
  int totalCount;
  int totalPages;
  int currentPage;
  int pageSize;
  List<Queue> queues;

  TransferQueue({
    required this.total,
    required this.accepted,
    required this.pending,
    required this.rejected,
    required this.totalCount,
    required this.totalPages,
    required this.currentPage,
    required this.pageSize,
    required this.queues,
  });

  factory TransferQueue.fromJson(Map<String, dynamic> json) => TransferQueue(
    total: json["total"],
    accepted: json["accepted"],
    pending: json["pending"],
    rejected: json["rejected"],
    totalCount: json["totalCount"],
    totalPages: json["totalPages"],
    currentPage: json["currentPage"],
    pageSize: json["pageSize"],
    queues: List<Queue>.from(json["items"].map((x) => Queue.fromJson(x))),
  );

}

class Queue {
  BatchJob? batchJob;
  int id;
  int associationId;
  String associationName;
  double amount;
  int requestStatus;
  int fundTransferStatus;
  dynamic comments;
  dynamic rejectNote;
  dynamic rejectDocument;
  dynamic sahemBankAccountId;

  Queue({
    required this.batchJob,
    required this.id,
    required this.associationId,
    required this.associationName,
    required this.amount,
    required this.requestStatus,
    required this.fundTransferStatus,
    required this.comments,
    required this.rejectNote,
    required this.rejectDocument,
    required this.sahemBankAccountId,
  });

  factory Queue.fromJson(Map<String, dynamic> json) => Queue(
    batchJob: json["batchJob"]!=null?BatchJob.fromJson(json["batchJob"]):null,
    id: json["id"],
    associationId: json["associationId"],
    associationName: json["associationName"],
    amount: json["amount"],
    requestStatus: json["requestStatus"],
    fundTransferStatus: json["fundTransferStatus"],
    comments: json["comments"],
    rejectNote: json["rejectNote"],
    rejectDocument: json["rejectDocument"],
    sahemBankAccountId: json["sahemBankAccountId"],
  );

}

class BatchJob {
  int id;
  String name;
  int fundTransferId;
  dynamic rejectReason;
  dynamic currentStepId;
  dynamic startAt;
  dynamic endAt;
  int status;
  int createdBy;
  DateTime createdDate;

  BatchJob({
    required this.id,
    required this.name,
    required this.fundTransferId,
    required this.rejectReason,
    required this.currentStepId,
    required this.startAt,
    required this.endAt,
    required this.status,
    required this.createdBy,
    required this.createdDate,
  });

  factory BatchJob.fromJson(Map<String, dynamic> json) => BatchJob(
    id: json["id"],
    name: json["name"],
    fundTransferId: json["fundTransferId"],
    rejectReason: json["rejectReason"],
    currentStepId: json["currentStepId"],
    startAt: json["startAt"],
    endAt: json["endAt"],
    status: json["status"],
    createdBy: json["createdBy"],
    createdDate: DateTime.parse(json["createdDate"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "fundTransferId": fundTransferId,
    "rejectReason": rejectReason,
    "currentStepId": currentStepId,
    "startAt": startAt,
    "endAt": endAt,
    "status": status,
    "createdBy": createdBy,
    "createdDate": createdDate.toIso8601String(),
  };
}
