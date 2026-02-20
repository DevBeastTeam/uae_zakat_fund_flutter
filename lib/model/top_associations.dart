class Top5Associations {
  int associationId;
  String associationName;
  String associationNameArabic;
  double collectedAmount;

  Top5Associations({
    required this.associationId,
    required this.associationName,
    required this.associationNameArabic,
    required this.collectedAmount,
  });

  factory Top5Associations.fromJson(Map<String, dynamic> json) => Top5Associations(
    associationId: json["associationId"],
    associationName: json["associationName"],
    associationNameArabic: json["associationNameArabic"],
    collectedAmount: json["collectedAmount"],
  );

  Map<String, dynamic> toJson() => {
    "associationId": associationId,
    "associationName": associationName,
    "associationNameArabic": associationNameArabic,
    "collectedAmount": collectedAmount,
  };
}
