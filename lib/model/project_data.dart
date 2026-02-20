import 'package:flutter/material.dart';

class ProjectData {
  int projectId;
  int amount;
  String? name;
  TextEditingController? controller;
  FocusNode? focusNode;

  ProjectData({
    required this.projectId,
    required this.amount,
     this.name,
     this.controller,
     this.focusNode,
  });

  Map<String, dynamic> toJson() {
    return {
      'projectId': projectId,
      'amount': amount,
    };
  }

  Map<String, dynamic> cashCollectionToJson() {
    return {
      'id': projectId,
      'amount': amount,
    };
  }

}
