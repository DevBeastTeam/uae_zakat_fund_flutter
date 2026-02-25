class LookupData {
  dynamic name;
  dynamic nameAr;
  dynamic code;
  int value;
  dynamic icon;

  LookupData({
    required this.name,
    this.nameAr,
    this.code,
    this.icon,
    required this.value,
  });

  factory LookupData.fromJson(Map<String, dynamic> json) => LookupData(
      name: json["name"] ?? json["nameEN"],
      nameAr: json["nameAr"] ?? json["nameAR"],
      code: json["code"]??"",
      icon: json["icon"]??"",
      value: json["value"] ?? json["id"]??0);

  factory LookupData.bankFromJson(Map<String, dynamic> json) => LookupData(
      name: json["bankName"],
      nameAr: json["bankNameArabic"],
      code: json["swiftCode"],
      value: json["id"]??0);

  factory LookupData.nationalityFromJson(Map<String, dynamic> json) =>
      LookupData(
          name: json["nationalityName"],
          code: json["code"]??"",
          nameAr: json["nationalityNameAR"],
          value: json["value"] ?? 0);

  factory LookupData.countriesFromJson(Map<String, dynamic> json) =>
      LookupData(
          name: json["name"],
          code: json["code"]??"",
          nameAr: json["nameAr"],
          value: json["value"] ?? 0);


}
