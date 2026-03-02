class CampaignTemplateResponse {
  final int totalRecords;
  final int pageNumber;
  final int pageSize;
  final int activeCount;
  final int inactiveCount;
  final List<CampaignTemplate> data;
  final CampaignTemplateStats stats;
  final String? message;
  final List<dynamic>? errors;
  final int statusCode;
  final bool success;

  CampaignTemplateResponse({
    required this.totalRecords,
    required this.pageNumber,
    required this.pageSize,
    required this.activeCount,
    required this.inactiveCount,
    required this.data,
    required this.stats,
    this.message,
    this.errors,
    required this.statusCode,
    required this.success,
  });

  factory CampaignTemplateResponse.fromJson(Map<String, dynamic> json) {
    return CampaignTemplateResponse(
      totalRecords: json['totalRecords'] ?? 0,
      pageNumber: json['pageNumber'] ?? 1,
      pageSize: json['pageSize'] ?? 10,
      activeCount: json['activeCount'] ?? 0,
      inactiveCount: json['inactiveCount'] ?? 0,
      data: (json['data'] as List<dynamic>?)
              ?.map((e) => CampaignTemplate.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      stats: CampaignTemplateStats.fromJson(
          json['stats'] as Map<String, dynamic>? ?? {}),
      message: json['message'],
      errors: json['errors'],
      statusCode: json['statusCode'] ?? 200,
      success: json['success'] ?? false,
    );
  }
}

class CampaignTemplate {
  final int id;
  final String templateName;
  final String? language;
  final bool isActive;
  final int? category;
  final String? emailerDescriptionHtml;

  CampaignTemplate({
    required this.id,
    required this.templateName,
    this.language,
    required this.isActive,
    this.category,
    this.emailerDescriptionHtml,
  });

  factory CampaignTemplate.fromJson(Map<String, dynamic> json) {
    return CampaignTemplate(
      id: json['id'] ?? 0,
      templateName: json['templateName'] ?? '',
      language: json['language']?.toString(),
      isActive: json['isActive'] ?? false,
      category: json['category'],
      emailerDescriptionHtml: json['emailerDescriptionHtml'],
    );
  }
}

class CampaignTemplateStats {
  final int total;
  final int accepted;
  final int pending;
  final int? completed;
  final int rejected;
  final int returned;
  final int drafted;
  final int active;
  final int inActive;

  CampaignTemplateStats({
    required this.total,
    required this.accepted,
    required this.pending,
    this.completed,
    required this.rejected,
    required this.returned,
    required this.drafted,
    required this.active,
    required this.inActive,
  });

  factory CampaignTemplateStats.fromJson(Map<String, dynamic> json) {
    return CampaignTemplateStats(
      total: json['total'] ?? 0,
      accepted: json['accepted'] ?? 0,
      pending: json['pending'] ?? 0,
      completed: json['completed'],
      rejected: json['rejected'] ?? 0,
      returned: json['returned'] ?? 0,
      drafted: json['drafted'] ?? 0,
      active: json['active'] ?? 0,
      inActive: json['inActive'] ?? 0,
    );
  }
}

