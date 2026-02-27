class FavouriteProject {
  int cartId;
  int projectId;
  String projectNameArabic;
  String projectName;
  String projectDescriptionShortArabic;
  String projectDescriptionShort;
  String? associationName;
  String? associationNameArabic;
  dynamic amount;
  String projectImage;
  dynamic minimumAmount;
  dynamic quickAmount;
  dynamic remainingAmount;
  dynamic percentOfCompletion;

  FavouriteProject({
    required this.cartId,
    required this.projectId,
    required this.projectNameArabic,
    required this.projectName,
    required this.projectDescriptionShortArabic,
    required this.projectDescriptionShort,
    required this.associationName,
    required this.associationNameArabic,
    required this.amount,
    required this.projectImage,
    required this.minimumAmount,
    required this.quickAmount,
    required this.percentOfCompletion,
    required this.remainingAmount,
  });

  factory FavouriteProject.fromJson(Map<String, dynamic> json) => FavouriteProject(
    cartId: json["cartId"] ?? 0,
    projectId: json["projectId"] ?? 0,
    projectNameArabic: json["projectNameArabic"] ?? "",
    projectName: json["projectName"] ?? "",
    projectDescriptionShortArabic: json["projectDescriptionShortArabic"] ?? "",
    projectDescriptionShort: json["projectDescriptionShort"] ?? "",
    associationName: json["associationName"],
    associationNameArabic: json["associationNameArabic"],
    amount: json["amount"] ?? 0,
    projectImage: json["projectImage"] ?? "",
    minimumAmount: json["minimumAmount"] ?? 0,
    quickAmount: json["quickAmount"] ?? "",
    remainingAmount: json["remainingAmount"] ?? 0,
    percentOfCompletion: json["percentOfCompletion"] ?? 0,
  );

  Map<String, dynamic> toJson() => {
    "cartId": cartId,
    "projectId": projectId,
    "projectNameArabic": projectNameArabic,
    "projectName": projectName,
    "projectDescriptionShortArabic": projectDescriptionShortArabic,
    "projectDescriptionShort": projectDescriptionShort,
    "associationName": associationName,
    "associationNameArabic": associationNameArabic,
    "amount": amount,
    "projectImage": projectImage,
    "minimumAmount": minimumAmount,
    "quickAmount": quickAmount,
  };
}
