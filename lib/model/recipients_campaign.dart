class RecipientsCampaign {
  int id;
  String groupName;
  String userType;
  int groupType;
  List<Operation> operation;
  DateTime createdDate;
  DateTime updatedDate;
  String createdBy;
  String createdByArabic;
  int userCount;
  int userId;
  bool isActive;

  RecipientsCampaign({
    required this.id,
    required this.groupName,
    required this.userType,
    required this.groupType,
    required this.operation,
    required this.createdDate,
    required this.updatedDate,
    required this.createdBy,
    required this.createdByArabic,
    required this.userCount,
    required this.userId,
    required this.isActive,
  });

  factory RecipientsCampaign.fromJson(Map<String, dynamic> json) => RecipientsCampaign(
    id: json["id"],
    groupName: json["groupName"],
    userType: json["userType"],
    groupType: json["groupType"],
    operation: List<Operation>.from(json["operation"].map((x) => Operation.fromJson(x))),
    createdDate: DateTime.parse(json["createdDate"]),
    updatedDate: DateTime.parse(json["updatedDate"]),
    createdBy: json["createdBy"],
    createdByArabic: json["createdByArabic"],
    userCount: json["userCount"],
    userId: json["userId"],
    isActive: json["isActive"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "groupName": groupName,
    "userType": userType,
    "groupType": groupType,
    "operation": List<dynamic>.from(operation.map((x) => x.toJson())),
    "createdDate": createdDate.toIso8601String(),
    "updatedDate": updatedDate.toIso8601String(),
    "createdBy": createdBy,
    "createdByArabic": createdByArabic,
    "userCount": userCount,
    "userId": userId,
    "isActive": isActive,
  };
}

class Operation {
  int logicalOperator;
  int userType;
  String columnName;
  int operationOperator;
  String value;

  Operation({
    required this.logicalOperator,
    required this.userType,
    required this.columnName,
    required this.operationOperator,
    required this.value,
  });

  factory Operation.fromJson(Map<String, dynamic> json) => Operation(
    logicalOperator: json["logicalOperator"],
    userType: json["userType"],
    columnName: json["columnName"],
    operationOperator: json["operator"],
    value: json["value"],
  );

  Map<String, dynamic> toJson() => {
    "logicalOperator": logicalOperator,
    "userType": userType,
    "columnName": columnName,
    "operator": operationOperator,
    "value": value,
  };
}
