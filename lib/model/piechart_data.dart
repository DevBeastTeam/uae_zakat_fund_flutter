
class PieChartData {
  String donorType;
  int donorCount;
  int percentage;

  PieChartData({
    required this.donorType,
    required this.donorCount,
    required this.percentage,
  });

  factory PieChartData.fromJson(Map<String, dynamic> json) => PieChartData(
    donorType: json["donorType"],
    donorCount: json["donorCount"],
    percentage: json["percentage"],
  );

  Map<String, dynamic> toJson() => {
    "donorType": donorType,
    "donorCount": donorCount,
    "percentage": percentage,
  };
}
