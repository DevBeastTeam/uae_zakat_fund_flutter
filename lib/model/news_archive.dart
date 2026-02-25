import 'package:zakat_fund/model/news.dart';

class NewsArchive {
  int totalRecords;
  int pageNumber;
  int pageSize;
  int activeCount;
  int inactiveCount;
  bool success;
  List<News> news;
  int statusCode;
  dynamic errors;
  dynamic message;

  NewsArchive({
    required this.totalRecords,
    required this.pageNumber,
    required this.pageSize,
    required this.activeCount,
    required this.inactiveCount,
    required this.success,
    required this.news,
    required this.statusCode,
    required this.errors,
    required this.message,
  });

  factory NewsArchive.fromJson(Map<String, dynamic> json) => NewsArchive(
    totalRecords: json["totalRecords"],
    pageNumber: json["pageNumber"],
    pageSize: json["pageSize"],
    activeCount: json["activeCount"],
    inactiveCount: json["inactiveCount"],
    success: json["success"],
    news: List<News>.from(json["data"].map((x) => News.fromJson(x))),
    statusCode: json["statusCode"],
    errors: json["errors"],
    message: json["message"],
  );

}
