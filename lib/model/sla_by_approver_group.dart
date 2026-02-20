class SlaByApproversGroups {
  String groupNameEn;
  String groupNameAr;
  int onTrack;
  int breached;

  SlaByApproversGroups({
    required this.groupNameEn,
    required this.groupNameAr,
    required this.onTrack,
    required this.breached,
  });

  factory SlaByApproversGroups.fromJson(Map<String, dynamic> json) => SlaByApproversGroups(
    groupNameEn: json["groupNameEn"],
    groupNameAr: json["groupNameAr"],
    onTrack: json["onTrack"],
    breached: json["breached"],
  );

  Map<String, dynamic> toJson() => {
    "groupNameEn": groupNameEn,
    "groupNameAr": groupNameAr,
    "onTrack": onTrack,
    "breached": breached,
  };
}
