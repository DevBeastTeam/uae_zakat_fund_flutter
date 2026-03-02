import '../utils/utils.dart';

class CampaignResponse {
  final int totalRecords;
  final int pageNumber;
  final int pageSize;
  final int activeCount;
  final int inactiveCount;
  final List<Campaign> data;
  final CampaignStats stats;

  CampaignResponse({
    required this.totalRecords,
    required this.pageNumber,
    required this.pageSize,
    required this.activeCount,
    required this.inactiveCount,
    required this.data,
    required this.stats,
  });

  factory CampaignResponse.fromJson(Map<String, dynamic> json) {
    return CampaignResponse(
      totalRecords: json['totalRecords'] ?? 0,
      pageNumber: json['pageNumber'] ?? 1,
      pageSize: json['pageSize'] ?? 10,
      activeCount: json['activeCount'] ?? 0,
      inactiveCount: json['inactiveCount'] ?? 0,
      data:
          (json['data'] as List?)?.map((x) => Campaign.fromJson(x)).toList() ??
              [],
      stats: CampaignStats.fromJson(json['stats'] ?? {}),
    );
  }
}

class Campaign {
  final int id;
  final String campaignName;
  final String? language;
  final String? category;
  final String? startDate;
  final String? createdDate;
  final String? lastModifiedDate;
  final String? createdByName;
  final String? lastModifiedByName;
  final String? status;
  final bool? isActive;

  Campaign({
    required this.id,
    required this.campaignName,
    this.language,
    this.category,
    this.startDate,
    this.createdDate,
    this.lastModifiedDate,
    this.createdByName,
    this.lastModifiedByName,
    this.status,
    this.isActive,
  });

  factory Campaign.fromJson(Map<String, dynamic> json) {
    String? formatDate(dynamic value) {
      if (value == null) return null;
      String stringValue = value.toString();
      try {
        DateTime? dateTime = DateTime.tryParse(stringValue);
        if (dateTime != null) {
          return Utils.dateFormat1.format(dateTime);
        }
      } catch (_) {}
      return stringValue;
    }

    return Campaign(
      id: json['id'] ?? 0,
      campaignName: (json['compaignName'] ??
                  json['campaignName'] ??
                  json['nameEN'] ??
                  json['name'])
              ?.toString() ??
          '',
      language: json['language']?.toString() ?? 'English',
      category:
          (json['category'] ?? json['categoryName'])?.toString() ?? 'Email',
      startDate: formatDate(json['startDate']),
      createdDate: formatDate(json['createdDate']),
      lastModifiedDate: formatDate(json['lastModifiedDate']),
      createdByName: json['createdByName']?.toString(),
      lastModifiedByName: json['lastModifiedByName']?.toString(),
      status: (json['status'] ?? json['statusName'])?.toString(),
      isActive: json['isActive'] ?? true,
    );
  }
}

class CampaignStats {
  final int total;
  final int accepted;
  final int pending;
  final int? completed;
  final int rejected;
  final int returned;
  final int drafted;

  CampaignStats({
    required this.total,
    required this.accepted,
    required this.pending,
    this.completed,
    required this.rejected,
    required this.returned,
    required this.drafted,
  });

  factory CampaignStats.fromJson(Map<String, dynamic> json) {
    return CampaignStats(
      total: json['total'] ?? 0,
      accepted: json['accepted'] ?? 0,
      pending: json['pending'] ?? 0,
      completed: json['completed'],
      rejected: json['rejected'] ?? 0,
      returned: json['returned'] ?? 0,
      drafted: json['drafted'] ?? 0,
    );
  }
}

class CampaignDetails {
  final int id;
  final String campaignName;
  final int languageCode;
  final DateTime startDate;
  final DateTime endDate;
  final int category;
  final String senderName;
  final String subject;
  final String? description;
  final String? campaignHtml;

  CampaignDetails({
    required this.id,
    required this.campaignName,
    required this.languageCode,
    required this.startDate,
    required this.endDate,
    required this.category,
    required this.senderName,
    required this.subject,
    this.description,
    this.campaignHtml,
  });

  factory CampaignDetails.fromJson(Map<String, dynamic> json) {
    return CampaignDetails(
      id: json['id'] ?? 0,
      campaignName:
          (json['campaignName'] ?? json['compaignName'] ?? '')?.toString() ??
              '',
      languageCode: json['languageCode'] ?? 1,
      startDate: DateTime.tryParse(json['startDate']?.toString() ?? '') ??
          DateTime.now(),
      endDate: DateTime.tryParse(json['endDate']?.toString() ?? '') ??
          DateTime.now(),
      category: json['category'] ?? 1,
      senderName: json['senderName']?.toString() ?? '',
      subject: json['subject']?.toString() ?? '',
      description: json['description']?.toString(),
      campaignHtml: json['campaignHtml']?.toString(),
    );
  }
}
