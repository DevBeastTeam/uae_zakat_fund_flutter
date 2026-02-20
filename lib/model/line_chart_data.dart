class LineChartModel {
  String monthName;
  double donationAmount;

  LineChartModel({
    required this.monthName,
    required this.donationAmount,
  });

  factory LineChartModel.fromJson(Map<String, dynamic> json) => LineChartModel(
    monthName: json["monthName"],
    donationAmount: json["donationAmount"],
  );

  Map<String, dynamic> toJson() => {
    "monthName": monthName,
    "donationAmount": donationAmount,
  };
}
