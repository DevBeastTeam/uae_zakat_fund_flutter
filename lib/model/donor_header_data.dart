class DonorHeaderData {
  int totalDonor;
  int activeDonor;
  int returningDonor;

  DonorHeaderData({
    required this.totalDonor,
    required this.activeDonor,
    required this.returningDonor,
  });

  factory DonorHeaderData.fromJson(Map<String, dynamic> json) => DonorHeaderData(
    totalDonor: json["totalDonor"],
    activeDonor: json["activeDonor"],
    returningDonor: json["returningDonor"],
  );

  Map<String, dynamic> toJson() => {
    "totalDonor": totalDonor,
    "activeDonor": activeDonor,
    "returningDonor": returningDonor,
  };
}
