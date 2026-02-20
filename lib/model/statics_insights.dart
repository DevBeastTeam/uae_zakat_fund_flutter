import 'dart:convert';

class StaticsInsights {
  final double totalRegisteredUsers;
  final double activeUsers;
  final double activeDonors;
  final double donorRetentionRate;
  final double growthRate;
  final double totalActiveProjects;
  final double completedProjects;
  final double completionRate;
  final double urgentNeedProjects;
  final double totalAssociationsRegistered;
  final double approvedAssociations;
  final double associationsContributions;
  final double newAssociations;
  final double totalDonors;
  final double uniqueDonors;
  final double averageDonationAmount;
  final String topDonationCategoryEn;
  final String topDonationCategoryAr;
  final double topDonationCategoryDonation;

  StaticsInsights({
    required this.totalRegisteredUsers,
    required this.activeUsers,
    required this.activeDonors,
    required this.donorRetentionRate,
    required this.growthRate,
    required this.totalActiveProjects,
    required this.completedProjects,
    required this.completionRate,
    required this.urgentNeedProjects,
    required this.totalAssociationsRegistered,
    required this.approvedAssociations,
    required this.associationsContributions,
    required this.newAssociations,
    required this.totalDonors,
    required this.uniqueDonors,
    required this.averageDonationAmount,
    required this.topDonationCategoryEn,
    required this.topDonationCategoryAr,
    required this.topDonationCategoryDonation,
  });

  /// Universal safe number parser
  static double _toDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is int) return value.toDouble();
    if (value is double) return value;
    if (value is String) {
      return double.tryParse(value) ?? 0.0;
    }
    return 0.0;
  }

  factory StaticsInsights.fromJson(Map<String, dynamic> json) {
    return StaticsInsights(
      totalRegisteredUsers: _toDouble(json["totalRegisteredUsers"]),
      activeUsers: _toDouble(json["activeUsers"]),
      activeDonors: _toDouble(json["activeDonors"]),
      donorRetentionRate: _toDouble(json["donorRetentionRate"]),
      growthRate: _toDouble(json["growthRate"]),
      totalActiveProjects: _toDouble(json["totalActiveProjects"]),
      completedProjects: _toDouble(json["completedProjects"]),
      completionRate: _toDouble(json["completionRate"]),
      urgentNeedProjects: _toDouble(json["urgentNeedProjects"]),
      totalAssociationsRegistered:
      _toDouble(json["totalAssociationsRegistered"]),
      approvedAssociations: _toDouble(json["approvedAssociations"]),
      associationsContributions:
      _toDouble(json["associationsContributions"]),
      newAssociations: _toDouble(json["newAssociations"]),
      totalDonors: _toDouble(json["totalDonors"]),
      uniqueDonors: _toDouble(json["uniqueDonors"]),
      averageDonationAmount:
      _toDouble(json["averageDonationAmount"]),
      topDonationCategoryEn: json["topDonationCategoryEn"] ?? "",
      topDonationCategoryAr: json["topDonationCategoryAr"] ?? "",
      topDonationCategoryDonation:
      _toDouble(json["topDonationCategoryDonation"]),
    );
  }

  /// Optional helper if you parse from string
  static StaticsInsights fromRawJson(String str) =>
      StaticsInsights.fromJson(json.decode(str));
}
