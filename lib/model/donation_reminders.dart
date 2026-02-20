class DonationReminder {
  int id;
  bool enableDonationReminder;
  String reminderName;
  int projectId;
  String projectNameEn;
  String projectNameAr;
  double donationAmount;
  int reminderFrequency;
  int reminderDateMonthly;
  DateTime? reminderDate;
  bool isAnnualReminder;
  String notificationMethods;

  DonationReminder({
    required this.id,
    required this.enableDonationReminder,
    required this.reminderName,
    required this.projectId,
    required this.projectNameEn,
    required this.projectNameAr,
    required this.donationAmount,
    required this.reminderFrequency,
    required this.reminderDateMonthly,
    required this.reminderDate,
    required this.isAnnualReminder,
    required this.notificationMethods,
  });

  factory DonationReminder.fromJson(Map<String, dynamic> json) => DonationReminder(
    id: json["id"],
    enableDonationReminder: json["enableDonationReminder"],
    reminderName: json["reminderName"],
    projectId: json["projectId"],
    projectNameEn: json["projectNameEn"],
    projectNameAr: json["projectNameAr"],
    donationAmount: json["donationAmount"],
    reminderFrequency: json["reminderFrequency"],
    reminderDateMonthly: json["reminderDateMonthly"],
    reminderDate: json["reminderDate"]!=null?DateTime.parse(json["reminderDate"]).toLocal():null,
    isAnnualReminder: json["isAnnualReminder"],
    notificationMethods: json["notificationMethods"],
  );

}
