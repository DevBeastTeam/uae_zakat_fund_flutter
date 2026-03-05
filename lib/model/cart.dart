import 'package:hive/hive.dart';

part 'cart.g.dart';

@HiveType(typeId: 2)
class Cart {
  @HiveField(1)
  int cartId;
  @HiveField(2)
  int projectId;
  @HiveField(3)
  String projectNameArabic;
  @HiveField(4)
  String projectName;
  @HiveField(5)
  String projectDescriptionShortArabic;
  @HiveField(6)
  String projectDescriptionShort;
  @HiveField(7)
  String? associationName;
  @HiveField(8)
  String? associationNameArabic;
  @HiveField(9)
  double amount;
  @HiveField(10)
  String? projectImage;
  @HiveField(11)
  double minimumAmount;

  Cart({
    required this.cartId,
    required this.projectId,
    required this.projectNameArabic,
    required this.projectName,
    required this.projectDescriptionShortArabic,
    required this.projectDescriptionShort,
    this.associationName,
    this.associationNameArabic,
    required this.amount,
    required this.projectImage,
    required this.minimumAmount,
  });

  factory Cart.fromJson(Map<String, dynamic> json) => Cart(
        cartId: json["cartId"],
        projectId: json["projectId"],
        projectNameArabic: json["projectNameArabic"] ?? "",
        projectName: json["projectName"] ?? "",
        projectDescriptionShortArabic:
            json["projectDescriptionShortArabic"] ?? "",
        projectDescriptionShort: json["projectDescriptionShort"] ?? "",
        associationName: json["associationName"],
        associationNameArabic: json["associationNameArabic"],
        amount: json["amount"]?.toDouble() ?? 0.0,
        projectImage: json["projectImage"],
        minimumAmount: json["minimumAmount"]?.toDouble() ?? 0.0,
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
      };
}
