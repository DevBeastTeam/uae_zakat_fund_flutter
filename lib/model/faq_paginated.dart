import 'package:zakat_fund/model/faq.dart';

class FaqPaginated {
  int totalRecords;
  FAQStats stats;
  bool success;
  List<FaQs> faqs;
  int statusCode;
  dynamic errors;
  dynamic message;

  FaqPaginated({
    required this.totalRecords,
    required this.stats,
    required this.success,
    required this.faqs,
    required this.statusCode,
    required this.errors,
    required this.message,
  });

  factory FaqPaginated.fromJson(Map<String, dynamic> json) => FaqPaginated(
    totalRecords: json["totalRecords"],
    stats: FAQStats.fromJson(json["stats"]),
    success: json["success"],
    faqs: List<FaQs>.from(json["data"].map((x) => FaQs.fromJson(x))),
    statusCode: json["statusCode"],
    errors: json["errors"],
    message: json["message"],
  );


}


class FAQStats {
  int total;
  int accepted;
  int pending;
  int rejected;
  int returned;

  FAQStats({
    required this.total,
    required this.accepted,
    required this.pending,
    required this.rejected,
    required this.returned,
  });

  factory FAQStats.fromJson(Map<String, dynamic> json) => FAQStats(
    total: json["total"]??0,
    accepted: json["accepted"]??0,
    pending: json["pending"]??0,
    rejected: json["rejected"]??0,
    returned: json["returned"]??0,
  );

}
