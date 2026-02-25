import 'package:zakat_fund/model/faq.dart';

class OurServices {
  int id;
  int? serviceId;
  String titleEn;
  String titleAr;
  String descriptionEn;
  String descriptionAr;
  String proceduresEn;
  String procedureAr;
  String termsOfUseEn;
  String termsOfUseAr;
  String serviceFee;
  String duration;
  String serviceChannelsEn;
  String serviceChannelsAr;
  String targetAudienceEn;
  String targetAudienceAr;
  String support;
  String tag;
  bool isFavorite;
  int serviceCategoryId;
  String startServiceEN;
  String startServiceAR;
  List<FaQs> faqs;
  String? rejectNote;
  String? rejectionDocument;
  bool isActive;
  DateTime? publishDate;
  String? icon;

  dynamic serviceUploadImage;
  dynamic serviceCustomTextTitleEn;
  dynamic serviceCustomTextTitleAr;
  dynamic serviceCustomTextEn;
  dynamic serviceCustomTextAr;
  dynamic serviceCustomDescriptionTitleEn;
  dynamic serviceCustomDescriptionTitleAr;
  dynamic serviceCustomDescriptionEn;
  dynamic serviceCustomDescriptionAr;
  dynamic serviceCustomUrl;
  dynamic serviceCustomLinkEn;
  dynamic serviceCustomLinkAr;
  dynamic serviceCustomAmount;
  dynamic serviceCustomButtonEn;
  dynamic serviceCustomButtonAr;
  dynamic serviceCustomAmountEn;
  dynamic serviceCustomAmountAr;
  dynamic supportTitleAr;
  dynamic supportTitleEn;
  int requestStatus;
  dynamic durationAr;
  DateTime createdDate;
  DateTime? modifiedDate;

  OurServices({
    required this.id,
    required this.serviceCategoryId,
    required this.serviceId,
    required this.isFavorite,
    required this.titleEn,
    required this.titleAr,
    required this.descriptionEn,
    required this.descriptionAr,
    required this.proceduresEn,
    required this.procedureAr,
    required this.termsOfUseEn,
    required this.termsOfUseAr,
    required this.serviceFee,
    required this.duration,
    required this.serviceChannelsEn,
    required this.serviceChannelsAr,
    required this.targetAudienceEn,
    required this.targetAudienceAr,
    required this.support,
    required this.tag,
    required this.startServiceEN,
    required this.startServiceAR,
    required this.faqs,
    required this.serviceUploadImage,
    required this.serviceCustomTextTitleEn,
    required this.serviceCustomTextTitleAr,
    required this.serviceCustomTextEn,
    required this.serviceCustomTextAr,
    required this.serviceCustomDescriptionTitleEn,
    required this.serviceCustomDescriptionTitleAr,
    required this.serviceCustomDescriptionEn,
    required this.serviceCustomDescriptionAr,
    required this.serviceCustomUrl,
    required this.serviceCustomLinkEn,
    required this.serviceCustomLinkAr,
    required this.serviceCustomAmount,
    required this.serviceCustomButtonEn,
    required this.serviceCustomButtonAr,
    required this.serviceCustomAmountEn,
    required this.serviceCustomAmountAr,
    required this.supportTitleAr,
    required this.supportTitleEn,
    required this.requestStatus,
    required this.durationAr,
    required this.createdDate,
    required this.modifiedDate,
    required this.rejectionDocument,
    required this.rejectNote,
    required this.isActive,
    required this.publishDate,
    this.icon,
  });

  factory OurServices.fromJson(Map<String, dynamic> json) => OurServices(
        rejectionDocument: json["rejectionDocument"],
        rejectNote: json["rejectNote"],
        id: json["id"]??0,
    publishDate: json["publishDate"]!=null?DateTime.parse(json["publishDate"]).toLocal():null,
        isActive: json["isActive"]??false,
        serviceCategoryId: json["serviceCategoryId"] ?? 0,
        serviceId: json["serviceId"],
        titleEn: json["titleEN"] ?? "",
        titleAr: json["titleAR"] ?? "",
    icon: json["icon"] ?? "",
        descriptionEn: json["descriptionEN"] ?? "",
        descriptionAr: json["descriptionAR"] ?? "",
        proceduresEn: json["proceduresEN"] ?? "",
        procedureAr: json["procedureAR"] ?? "",
        termsOfUseEn: json["termsOfUseEN"] ?? "",
        termsOfUseAr: json["termsOfUseAR"] ?? "",
        serviceFee: json["serviceFee"] ?? "",
        duration: json["duration"] ?? "",
        isFavorite: json["isFavorite"] ?? false,
        serviceChannelsEn: json["serviceChannelsEN"] ?? "",
        serviceChannelsAr: json["serviceChannelsAR"] ?? "",
        targetAudienceEn: json["targetAudienceEN"] ?? "",
        targetAudienceAr: json["targetAudienceAR"] ?? "",
        support: json["support"] ?? "",
        tag: json["tag"] ?? "",
        startServiceEN: json["startServiceEN"] ?? "",
        startServiceAR: json["startServiceAR"] ?? "",
        faqs: json["faqs"] != null
            ? List<FaQs>.from(json["faqs"].map((x) => FaQs.fromJson(x)))
            : [],
        serviceUploadImage: json["serviceUploadImage"] ?? "",
        serviceCustomTextTitleEn: json["serviceCustomTextTitleEN"] ?? "",
        serviceCustomTextTitleAr: json["serviceCustomTextTitleAR"] ?? "",
        serviceCustomTextEn: json["serviceCustomTextEN"] ?? "",
        serviceCustomTextAr: json["serviceCustomTextAR"] ?? "",
        serviceCustomDescriptionTitleEn:
            json["serviceCustomDescriptionTitleEN"] ?? "",
        serviceCustomDescriptionTitleAr:
            json["serviceCustomDescriptionTitleAR"] ?? "",
        serviceCustomDescriptionEn: json["serviceCustomDescriptionEN"] ?? "",
        serviceCustomDescriptionAr: json["serviceCustomDescriptionAR"] ?? "",
        serviceCustomUrl: json["serviceCustomUrl"] ?? "",
        serviceCustomLinkEn: json["serviceCustomLinkEN"] ??json["serviceCustomLinkEn"] ?? "",
        serviceCustomLinkAr: json["serviceCustomLinkAR"] ??json["serviceCustomLinkAr"] ?? "",
        serviceCustomAmount: json["serviceCustomAmount"] ?? "",
        serviceCustomButtonEn: json["serviceCustomButtonEn"] ?? "",
        serviceCustomButtonAr: json["serviceCustomButtonAr"] ?? "",
        serviceCustomAmountEn: json["serviceCustomAmountEn"] ?? "",
        serviceCustomAmountAr: json["serviceCustomAmountAr"] ?? "",
        supportTitleAr: json["supportTitleAr"] ?? "",
        supportTitleEn: json["supportTitleEn"] ?? "",
        requestStatus: json["requestStatus"] ?? 0,
        durationAr: json["durationAR"] ?? "",
        createdDate: json["createdDate"] != null
            ? DateTime.parse(json["createdDate"]).toLocal()
            : DateTime.now(),
        modifiedDate: json["modifiedDate"] != null
            ? DateTime.parse(json["modifiedDate"]).toLocal()
            : null,
      );

  Map<String, dynamic> toJson() => {
        "rejectionDocument": rejectionDocument,
        "rejectNote": rejectNote,
        "id": id,
        "titleEN": titleEn,
        "titleAR": titleAr,
        "descriptionEN": descriptionEn,
        "descriptionAR": descriptionAr,
        "proceduresEN": proceduresEn,
        "serviceCategoryId": serviceCategoryId,
        "procedureAR": procedureAr,
        "termsOfUseEN": termsOfUseEn,
        "termsOfUseAR": termsOfUseAr,
        "serviceFee": serviceFee,
        "duration": duration,
        "serviceChannelsEN": serviceChannelsEn,
        "serviceChannelsAR": serviceChannelsAr,
        "targetAudienceEN": targetAudienceEn,
        "targetAudienceAR": targetAudienceAr,
        "support": support,
        "tag": tag,
        "createdDate": createdDate.toIso8601String(),
        "modifiedDate": modifiedDate?.toIso8601String(),
        "isFavorite": isFavorite,
        "startServiceEN": startServiceEN,
        "startServiceAR": startServiceAR,
        "durationAR": durationAr,
        "faqs": List<dynamic>.from(faqs.map((x) => x.toJson())),
        "serviceUploadImage": serviceUploadImage,
        "serviceCustomTextTitleEN": serviceCustomTextTitleEn,
        "serviceCustomTextTitleAR": serviceCustomTextTitleAr,
        "serviceCustomTextEN": serviceCustomTextEn,
        "serviceCustomTextAR": serviceCustomTextAr,
        "serviceCustomDescriptionTitleEN": serviceCustomDescriptionTitleEn,
        "serviceCustomDescriptionTitleAR": serviceCustomDescriptionTitleAr,
        "serviceCustomDescriptionEN": serviceCustomDescriptionEn,
        "serviceCustomDescriptionAR": serviceCustomDescriptionAr,
        "serviceCustomUrl": serviceCustomUrl,
        "serviceCustomLinkEN": serviceCustomLinkEn,
        "serviceCustomLinkAR": serviceCustomLinkAr,
        "serviceCustomAmount": serviceCustomAmount,
        "serviceCustomButtonEn": serviceCustomButtonEn,
        "serviceCustomButtonAr": serviceCustomButtonAr,
        "serviceCustomAmountEn": serviceCustomAmountEn,
        "serviceCustomAmountAr": serviceCustomAmountAr,
        "supportTitleAr": supportTitleAr,
        "supportTitleEn": supportTitleEn,
        "requestStatus": requestStatus,
      };
}
