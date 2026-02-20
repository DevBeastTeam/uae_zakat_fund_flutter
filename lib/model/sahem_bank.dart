class SahemBank {
  int id;
  String bankName;
  String bankNameArabic;
  int accountNumber;
  String accountHolderName;
  String accountHolderNameArabic;
  String swiftCode;
  bool isDefault;
  dynamic iban;
  bool isActive;
  DateTime createdDate;

  SahemBank({
    required this.id,
    required this.bankName,
    required this.bankNameArabic,
    required this.accountNumber,
    required this.accountHolderName,
    required this.swiftCode,
    required this.isDefault,
    required this.iban,
    required this.isActive,
    required this.createdDate,
    required this.accountHolderNameArabic,
  });

  factory SahemBank.fromJson(Map<String, dynamic> json) => SahemBank(
        id: json["id"] ?? 0,
        bankName: json["bankName"] ?? "",
        accountNumber: json["accountNumber"] ?? 0,
        accountHolderName: json["accountHolderName"] ?? "",
        accountHolderNameArabic:
            json["accountHolderNameArabic"] ?? json["accountHolderName"] ?? "",
        swiftCode: json["swiftCode"] ?? "",
        bankNameArabic: json["bankNameArabic"] ?? json["bankName"] ?? "",
        isDefault: json["isDefault"] ?? false,
        iban: json["iban"],
        isActive: json["isActive"] ?? false,
        createdDate: json["createdDate"] != null
            ? DateTime.parse(json["createdDate"])
            : DateTime.fromMillisecondsSinceEpoch(0),
      );

}
