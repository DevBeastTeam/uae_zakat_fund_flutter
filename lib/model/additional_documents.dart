import 'package:flutter/cupertino.dart';
import 'package:zakat_fund/utils/utils.dart';

class AdditionalDocuments {
  int id;
  dynamic uploadedDocuemntId;
  String documentName;
  String documentNameAr;
  bool isRequired;
  bool requiresDate;
  String dateType;
  int documentAssociatedWith;
  String? startDate;
  String? startDateAr;
  String? endDate;
  String? endDateAr;
  String allowedFileTypes;
  String selectedFileName;
  dynamic startDateValue;
  dynamic endDateValue;
  TextEditingController fileController;
  TextEditingController startDateController;
  TextEditingController endDateController;

  AdditionalDocuments({
    required this.id,
    required this.uploadedDocuemntId,
    required this.documentName,
    required this.documentNameAr,
    required this.isRequired,
    required this.requiresDate,
    required this.dateType,
    required this.documentAssociatedWith,
    required this.startDate,
    required this.startDateAr,
    required this.endDate,
    required this.endDateAr,
    required this.allowedFileTypes,
    required this.selectedFileName,
    required this.startDateValue,
    required this.endDateValue,
    required this.fileController,
    required this.startDateController,
    required this.endDateController,
  });

  factory AdditionalDocuments.fromJson(Map<String, dynamic> json) {
    String startDate = json["startDateValue"]??"";
    String endDate = json["endDateValue"]??"";
    if(startDate!=""){
      DateTime startDateTime = DateTime.parse(startDate);
      startDate = Utils.dateFormat1.format(startDateTime);
    }
    if(endDate!=""){
      DateTime endDateTime = DateTime.parse(endDate);
      endDate = Utils.dateFormat1.format(endDateTime);
    }
    return AdditionalDocuments(
        id: json["id"],
        uploadedDocuemntId: json["uploadedDocuemntId"],
        documentName: json["documentName"]??"",
        documentNameAr: json["documentNameAr"]??"",
        isRequired: json["isRequired"]??false,
        requiresDate: json["requiresDate"]??false,
        dateType: json["dateType"]??"",
        documentAssociatedWith: json["documentAssociatedWith"]??0,
        startDate: json["startDate"]??"",
        startDateAr: json["startDateAr"]??"",
        endDate: json["endDate"]??"",
        endDateAr: json["endDateAr"]??"",
        allowedFileTypes: json["allowedFileTypes"]??"",
        selectedFileName: json["selectedFileName"],
        startDateValue: json["startDateValue"],
        endDateValue: json["endDateValue"],
        fileController: TextEditingController(text: json["selectedFileName"]),
        startDateController: TextEditingController(text: startDate),
        endDateController: TextEditingController(text: endDate),
      );
  }
}
