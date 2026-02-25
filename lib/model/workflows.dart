import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

class Workflows {
  int id;
  String workflowName;
  String workflowNameArabic;
  String workflowDescription;
  String requestType;
  bool isActive;
  List<WorkflowLevel> workflowLevels;

  Workflows({
    required this.id,
    required this.workflowName,
    required this.workflowNameArabic,
    required this.workflowDescription,
    required this.requestType,
    required this.isActive,
    required this.workflowLevels,
  });

  factory Workflows.fromJson(Map<String, dynamic> json) => Workflows(
        id: json["id"],
        workflowName: json["workflowName"],
        workflowNameArabic: json["workflowNameArabic"],
        workflowDescription: json["workflowDescription"],
        requestType: json["requestType"],
        isActive: json["isActive"],
        workflowLevels: List<WorkflowLevel>.from(
            json["workflowLevels"].map((x) => WorkflowLevel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "workflowName": workflowName,
        "workflowNameArabic": workflowNameArabic,
        "workflowDescription": workflowDescription,
        "requestType": requestType,
        "isActive": isActive,
        "workflowLevels":
            List<dynamic>.from(workflowLevels.map((x) => x.toJson())),
      };
}

class WorkflowLevel {
  int id;
  int workflowId;
  int approverGroupId;
  String levelName;
  String levelNameArabic;
  String levelDescription;
  int levelSla;

  WorkflowLevel({
    required this.id,
    required this.workflowId,
    required this.approverGroupId,
    required this.levelName,
    required this.levelNameArabic,
    required this.levelDescription,
    required this.levelSla,
  });

  factory WorkflowLevel.fromJson(Map<String, dynamic> json) => WorkflowLevel(
        id: json["id"],
        workflowId: json["workflowId"],
        approverGroupId: json["approverGroupId"],
        levelName: json["levelName"],
        levelNameArabic: json["levelNameArabic"],
        levelDescription: json["levelDescription"],
        levelSla: json["levelSLA"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "workflowId": workflowId,
        "approverGroupId": approverGroupId,
        "levelName": levelName,
        "levelNameArabic": levelNameArabic,
        "levelDescription": levelDescription,
        "levelSLA": levelSla,
      };
}

class NewWorkflowLevel {
  int id,workflowId,approverGroupId;
  Rxn selectedGroup = Rxn<String>();
  TextEditingController levelNameInEnglishController;
  TextEditingController levelNameInArabicController;
  TextEditingController levelDescriptionController;
  TextEditingController slaHoursController;
  FocusNode slaHoursNode;
  FocusNode levelDescriptionNode;
  List<KeyboardActionsItem> subKeyboardActionsItem;

  NewWorkflowLevel({
    required this.levelNameInEnglishController,
    required this.levelNameInArabicController,
    required this.levelDescriptionController,
    required this.slaHoursController,
    required this.selectedGroup,
    required this.slaHoursNode,
    required this.levelDescriptionNode,
    required this.subKeyboardActionsItem,
     this.id=0,
     this.approverGroupId=0,
     this.workflowId=0,
  });
}
