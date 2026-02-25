import 'dart:convert';

class BaseApiModel {
  dynamic success;
  dynamic data;
  dynamic statusCode;
  dynamic errors;
  dynamic message;
  dynamic path;
  dynamic fileName;
  dynamic totalRecords;
  dynamic activeCount;
  dynamic inactiveCount;
  Stats stats;
  ProjectStats projectsStats;
  String createdBy;
  String createdByAr;
  String modifiedBy;
  String modifiedByAr;
  DateTime? createdDate;
  DateTime? modifiedDate;
  String? paymentUri;
  String? sessionId;

  BaseApiModel({
    required this.success,
    required this.data,
    required this.statusCode,
    required this.fileName,
    required this.path,
    required this.errors,
    required this.message,
    required this.totalRecords,
    required this.activeCount,
    required this.inactiveCount,
    required this.stats,
    required this.projectsStats,
    required this.createdBy,
    required this.createdByAr,
    required this.modifiedBy,
    required this.modifiedByAr,
    required this.createdDate,
    required this.modifiedDate,
    this.paymentUri,
    this.sessionId,
  });

  factory BaseApiModel.fromJson(Map<String, dynamic> json) {
    dynamic dataField = json["data"] ?? json["items"] ?? [];
    if (dataField is String) {
      try {
        dataField = jsonDecode(dataField);
      } catch (_) {
        // Keep original string when it's not JSON.
      }
    }
    final String? paymentUri =
        json["paymentUri"] ?? _extractPaymentUri(dataField);
    return BaseApiModel(
        success: json["success"] ?? json["ValidRequest"],
        activeCount: json["activeCount"] ?? 0,
        inactiveCount: json["inactiveCount"] ?? 0,
        totalRecords: json["totalRecords"] ?? 0,
        path: json["path"],
        sessionId: _extractBatchID(dataField),
        paymentUri: paymentUri,
        fileName: json["fileName"],
        data: dataField,
        statusCode: json["statusCode"] ?? 200,
        errors: json["errors"],
        message: json["message"] ?? "Spmething went wrong try again",
        stats: json["stats"] != null
            ? Stats.fromJson(json["stats"])
            : Stats.empty(),
        projectsStats: json["projectsStats"] != null
            ? ProjectStats.fromJson(json["projectsStats"])
            : ProjectStats.empty(),
        createdBy: json["createdBy"] ?? "",
        createdByAr: json["createdByAr"] ?? "",
        modifiedBy: json["modifiedBy"] ?? "",
        modifiedByAr: json["modifiedByAr"] ?? "",
        createdDate: json["createdDate"] != null
            ? DateTime.parse(json["createdDate"])
            : null,
        modifiedDate: json["modifiedDate"] != null
            ? DateTime.parse(json["modifiedDate"])
            : null,
      );
  }

  static String? _extractPaymentUri(dynamic dataField) {
    if (dataField is Map) {
      final dynamic uriValue =
          dataField["paymentUri"] ?? dataField["uri"] ?? dataField["Uri"];
      if (uriValue is String) {
        return uriValue;
      }
    }
    return null;
  }

  static String? _extractBatchID(dynamic dataField) {
    if (dataField is Map) {
      final dynamic uriValue = dataField["BatchId"];
      if (uriValue is String) {
        return uriValue;
      }
    }
    return null;
  }
}

class Stats {
  int total;
  int accepted;
  int completed;
  int pending;
  int rejected;
  int pendingForCollection;
  int returned;
  int complaints;
  int support;
  int suggestions;
  int active;
  int inActive;
  int overAllReceivedDonations;
  int totalTransferredAmount;
  int totalRequestedFundAmount;
  int availableAmount;
  int totalBeneficiaries;
  int totalRequests;
  int escalationRate;
  int onTrackRate;
  int breachedRate;

  Stats({
    required this.total,
    required this.accepted,
    required this.pending,
    required this.rejected,
    required this.returned,
    required this.complaints,
    required this.suggestions,
    required this.support,
    required this.active,
    required this.inActive,
    required this.totalBeneficiaries,
    required this.overAllReceivedDonations,
    required this.availableAmount,
    required this.totalRequestedFundAmount,
    required this.totalTransferredAmount,
    required this.completed,
    required this.pendingForCollection,
    required this.totalRequests,
    required this.escalationRate,
    required this.onTrackRate,
    required this.breachedRate,
  });

  Stats.empty()
      : total = 0,
        accepted = 0,
        pending = 0,
        pendingForCollection = 0,
        complaints = 0,
        completed = 0,
        active = 0,
        returned = 0,
        suggestions = 0,
        support = 0,
        inActive = 0,
        overAllReceivedDonations = 0,
        totalTransferredAmount = 0,
        availableAmount = 0,
        totalRequests = 0,
        totalRequestedFundAmount = 0,
        escalationRate = 0,
        totalBeneficiaries = 0,
        onTrackRate = 0,
        breachedRate = 0,
        rejected = 0;

  factory Stats.fromJson(Map<String, dynamic> json) => Stats(
        total: json["total"] ?? 0,
        accepted: json["accepted"] ?? 0,
        totalRequests: json["totalRequests"] ?? 0,
        escalationRate: json["escalationRate"] ?? 0,
        onTrackRate: json["onTrackRate"] ?? 0,
        breachedRate: json["breachedRate"] ?? 0,
        active: json["active"] ?? 0,
        support: json["support"] ?? 0,
        pending: json["pending"] ?? 0,
        completed: json["completed"] ?? 0,
        pendingForCollection: json["pendingForCollection"] ?? 0,
        inActive: json["inActive"] ?? 0,
        overAllReceivedDonations: json["overAllReceivedDonations"] ?? 0,
        totalTransferredAmount: json["totalTransferredAmount"] ?? 0,
        totalRequestedFundAmount: json["totalRequestedFundAmount"] ?? 0,
        availableAmount: json["availableAmount"] ?? 0,
        totalBeneficiaries: json["totalBeneficiaries"] ?? 0,
        returned: json["returned"] ?? 0,
        complaints: json["complaints"] ?? 0,
        suggestions: json["suggestions"] ?? 0,
        rejected: json["rejected"] ?? 0,
      );
}

class ProjectStats {
  int totalProjects;
  int activeProjects;
  int accepted;
  int pending;
  int rejected;
  int returned;
  double totalDonations;
  int totalDonors;
  int totalBeneficiaries;

  ProjectStats({
    required this.totalProjects,
    required this.activeProjects,
    required this.accepted,
    required this.pending,
    required this.rejected,
    required this.returned,
    required this.totalDonations,
    required this.totalDonors,
    required this.totalBeneficiaries,
  });

  ProjectStats.empty()
      : totalProjects = 0,
        activeProjects = 0,
        accepted = 0,
        pending = 0,
        rejected = 0,
        returned = 0,
        totalDonations = 0,
        totalDonors = 0,
        totalBeneficiaries = 0;

  factory ProjectStats.fromJson(Map<String, dynamic> json) => ProjectStats(
        totalProjects: json["totalProjects"] ?? 0,
        activeProjects: json["activeProjects"] ?? 0,
        accepted: json["accepted"] ?? 0,
        returned: json["returned"] ?? 0,
        pending: json["pending"] ?? 0,
        rejected: json["rejected"] ?? 0,
        totalDonations: json["totalDonations"] ?? 0,
        totalDonors: json["totalDonors"] ?? 0,
        totalBeneficiaries: json["totalBeneficiaries"] ?? 0,
      );
}
