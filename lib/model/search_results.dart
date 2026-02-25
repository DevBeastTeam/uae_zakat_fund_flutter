class SearchResults {
  String category;
  int itemId;
  String headingEn;
  String headingAr;
  String descriptionEn;
  String descriptionAr;
  String itemUrl;
  DateTime createdDate;

  SearchResults({
    required this.category,
    required this.itemId,
    required this.headingEn,
    required this.headingAr,
    required this.descriptionEn,
    required this.descriptionAr,
    required this.itemUrl,
    required this.createdDate,
  });

  factory SearchResults.fromJson(Map<String, dynamic> json) => SearchResults(
    category: json["category"],
    itemId: json["itemId"],
    headingEn: json["headingEn"],
    headingAr: json["headingAr"],
    descriptionEn: json["descriptionEn"],
    descriptionAr: json["descriptionAr"],
    itemUrl: json["itemUrl"],
    createdDate: DateTime.parse(json["createdDate"]),
  );

  Map<String, dynamic> toJson() => {
    "category": category,
    "itemId": itemId,
    "headingEn": headingEn,
    "headingAr": headingAr,
    "descriptionEn": descriptionEn,
    "descriptionAr": descriptionAr,
    "itemUrl": itemUrl,
    "createdDate": createdDate.toIso8601String(),
  };
}
