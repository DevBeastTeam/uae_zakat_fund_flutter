import 'dart:convert';

import 'package:zakat_fund/model/cash_notes.dart';

class TaskCollectionDetails {
  int id;
  String requesterName;
  String requestType;
  String requesterNameAr;
  String requestTypeAr;
  String assignedTo;
  int status;
  int entityId;
  DateTime createdDate;
  DateTime collectionDate;
  String collectionTime;
  String collectionPoint;
  double totalAmount;
  List<CashNotes> noteDetail;
  String imagePath;

  TaskCollectionDetails({
    required this.id,
    required this.requesterName,
    required this.requestType,
    required this.requesterNameAr,
    required this.requestTypeAr,
    required this.assignedTo,
    required this.status,
    required this.entityId,
    required this.createdDate,
    required this.collectionDate,
    required this.collectionTime,
    required this.collectionPoint,
    required this.totalAmount,
    required this.noteDetail,
    required this.imagePath,
  });

  factory TaskCollectionDetails.fromJson(Map<String, dynamic> json) {
    var noteDetailList = json['noteDetail']!=null?jsonDecode(json['noteDetail']):[];
    List<CashNotes> noteDetailObjects = (noteDetailList as List)
        .map((note) => CashNotes.fromJson(note))
        .toList();
    return TaskCollectionDetails(
    id: json["id"],
    requesterName: json["requesterName"],
    requestType: json["requestType"],
    requesterNameAr: json["requesterNameAr"],
    requestTypeAr: json["requestTypeAr"],
    assignedTo: json["assignedTo"],
    status: json["status"],
    entityId: json["entityId"],
    createdDate: DateTime.parse(json["createdDate"]),
    collectionDate: DateTime.parse(json["collectionDate"]),
    collectionTime: json["collectionTime"],
    collectionPoint: json["collectionPoint"],
    totalAmount: json["totalAmount"],
      noteDetail: noteDetailObjects,
    imagePath: json["imagePath"],
  );
  }

}
