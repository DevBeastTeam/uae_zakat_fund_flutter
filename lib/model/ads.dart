class Ads {
  int id;
  int adType;
  dynamic adTitleEn;
  String adTitleAr;
  int adLanguage;
  dynamic adDetailEn;
  String adDetailAr;
  bool? popupCloseButton;
  int? popupPosition;
  dynamic icon;
  DateTime? expiryDate;
  dynamic displayDuration;
  int status;
  DateTime? publicScheduleTime;
  dynamic bannerBackgroundColor;
  String bannerTextColor;
  int requestStatus;
  String? adsImage;
  bool isActive;

  Ads({
    required this.id,
    required this.adType,
    required this.adTitleEn,
    required this.adTitleAr,
    required this.adLanguage,
    required this.adDetailEn,
    required this.adDetailAr,
    required this.popupCloseButton,
    required this.popupPosition,
    required this.icon,
    this.expiryDate,
    required this.displayDuration,
    required this.status,
     this.publicScheduleTime,
    required this.bannerBackgroundColor,
    required this.bannerTextColor,
    required this.requestStatus,
    required this.adsImage,
    required this.isActive,
  });

  factory Ads.fromJson(Map<String, dynamic> json) => Ads(
        id: json["id"],
        adType: json["adType"],
    isActive: json["isActive"]??false,
        adTitleEn: json["adTitleEN"]??"",
        adTitleAr: json["adTitleAR"]??"",
        adLanguage: json["adLanguage"],
        adDetailEn: json["adDetailEN"]??"",
        adDetailAr: json["adDetailAR"]??"",
        popupCloseButton: json["popupCloseButton"],
        popupPosition: json["popupPosition"],
        icon: json["icon"]??"",
        expiryDate: json["expiryDate"]==null?null:DateTime.parse(json["expiryDate"]).toLocal(),
        displayDuration: json["displayDuration"]??"",
        status: json["status"],
        publicScheduleTime: json["publicScheduleTime"]==null?null:DateTime.parse(json["publicScheduleTime"]).toLocal(),
        bannerBackgroundColor: json["bannerBackgroundColor"],
        bannerTextColor: json["bannerTextColor"]??"",
        requestStatus: json["requestStatus"],
    adsImage: json["adsImage"]??"",
      );
}
