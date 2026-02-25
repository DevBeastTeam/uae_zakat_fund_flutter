class AssociationFundRequest {
  int id;
  int associationId;
  dynamic associationName;
  double amount;
  int requestStatus;
  int fundTransferStatus;
  dynamic comments;
  dynamic rejectNote;
  dynamic rejectDocument;
  DateTime createdDate;

  AssociationFundRequest({
    required this.id,
    required this.associationId,
    required this.associationName,
    required this.amount,
    required this.requestStatus,
    required this.fundTransferStatus,
    required this.comments,
    required this.rejectNote,
    required this.rejectDocument,
    required this.createdDate,
  });

  factory AssociationFundRequest.fromJson(Map<String, dynamic> json) => AssociationFundRequest(
    id: json["id"],
    associationId: json["associationId"],
    associationName: json["associationName"],
    amount: json["amount"],
    requestStatus: json["requestStatus"],
    fundTransferStatus: json["fundTransferStatus"],
    comments: json["comments"],
    rejectNote: json["rejectNote"],
    rejectDocument: json["rejectDocument"],
    createdDate: DateTime.parse(json["createdDate"]),
  );


}
