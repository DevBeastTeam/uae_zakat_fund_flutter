
class CampaignDetails {
  int id;
  String campaignName;
  int languageCode;
  DateTime startDate;
  DateTime endDate;
  int category;
  String senderName;
  String subject;
  String? description;
  String? campaignHtml;
  String? campaignJson;
  String? recipients;
  dynamic emailTemplateId;
  int status;
  int requestStatus;


  CampaignDetails({
    required this.id,
    required this.campaignName,
    required this.languageCode,
    required this.startDate,
    required this.endDate,
    required this.category,
    required this.senderName,
    required this.subject,
    required this.description,
    required this.campaignHtml,
    required this.campaignJson,
    required this.recipients,
    required this.emailTemplateId,
    required this.status,
    required this.requestStatus,

  });

  factory CampaignDetails.fromJson(Map<String, dynamic> json) => CampaignDetails(
    id: json["id"],
    requestStatus: json["requestStatus"]??0,
    campaignName: json["compaignName"]??"",
    languageCode: json["languageCode"]??1,
    startDate: DateTime.parse(json["startDate"]),
    endDate: DateTime.parse(json["endDate"]),
    category: json["category"],
    senderName: json["senderName"]??"",
    subject: json["subject"]??"",
    description: json["description"]??"",
    campaignHtml: json["campaignHtml"]??"",
    campaignJson: json["campaignJson"]??"",
    recipients: json["recipients"],
    emailTemplateId: json["emailTemplateId"]??"",
    status: json["status"],

  );

}
