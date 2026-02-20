class DonorDemographic {
  int countryResidenceId;
  String countryName;
  String countryNameArabic;
  String ageGroup;
  int male;
  int female;

  DonorDemographic({
    required this.countryResidenceId,
    required this.countryName,
    required this.countryNameArabic,
    required this.male,
    required this.female,
    required this.ageGroup,
  });

  factory DonorDemographic.fromJson(Map<String, dynamic> json) => DonorDemographic(
    countryResidenceId: json["countryResidenceID"],
    countryName: json["countryName"],
    countryNameArabic: json["countryNameArabic"],
    male: json["male"],
    female: json["female"],
    ageGroup: json["ageGroup"]??"",
  );

}
