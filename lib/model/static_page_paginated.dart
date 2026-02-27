import 'package:zakat_fund/model/static_page.dart';

class StaticPagePaginated {
  int totalRecords;
  StaticPageStats stats;
  bool success;
  List<StaticPage> staticPages;
  int statusCode;
  dynamic errors;
  dynamic message;

  StaticPagePaginated({
    required this.totalRecords,
    required this.stats,
    required this.success,
    required this.staticPages,
    required this.statusCode,
    required this.errors,
    required this.message,
  });

  factory StaticPagePaginated.fromJson(Map<String, dynamic> json) => StaticPagePaginated(
    totalRecords: json["totalRecords"] ?? 0,
    stats: StaticPageStats.fromJson(json["stats"]),
    success: json["success"] ?? false,
    staticPages: List<StaticPage>.from(json["data"].map((x) => StaticPage.fromJson(x))),
    statusCode: json["statusCode"] ?? 0,
    errors: json["errors"],
    message: json["message"],
  );
}

class StaticPageStats {
  int total;
  int accepted;
  int pending;
  int rejected;
  int returned;
  int drafted;

  StaticPageStats({
    required this.total,
    required this.accepted,
    required this.pending,
    required this.rejected,
    required this.returned,
    required this.drafted,
  });

  factory StaticPageStats.fromJson(Map<String, dynamic> json) => StaticPageStats(
    total: json["total"] ?? 0,
    accepted: json["accepted"] ?? 0,
    pending: json["pending"] ?? 0,
    rejected: json["rejected"] ?? 0,
    returned: json["returned"] ?? 0,
    drafted: json["drafted"] ?? 0,
  );
}
