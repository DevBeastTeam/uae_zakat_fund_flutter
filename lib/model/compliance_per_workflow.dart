class SlaCompliancePerWorkflow {
  String workflowType;
  int levelId;
  int onTrack;
  int breached;

  SlaCompliancePerWorkflow({
    required this.workflowType,
    required this.levelId,
    required this.onTrack,
    required this.breached,
  });

  factory SlaCompliancePerWorkflow.fromJson(Map<String, dynamic> json) => SlaCompliancePerWorkflow(
    workflowType: json["workflowType"],
    levelId: json["levelId"],
    onTrack: json["onTrack"],
    breached: json["breached"],
  );

  Map<String, dynamic> toJson() => {
    "workflowType": workflowType,
    "levelId": levelId,
    "onTrack": onTrack,
    "breached": breached,
  };
}
