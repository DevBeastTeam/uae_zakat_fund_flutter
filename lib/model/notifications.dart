class Notifications {
  int id;
  int userId;
  bool isMark;
  String titleEn;
  String descriptionEn;
  String titleAr;
  String descriptionAr;
  String? imageName;
  String iconName;
  dynamic notificationDetail;
  DateTime createdDate;
  DateTime? publishDate;
  DateTime date;
  int requestStatus;
  String recipients;

  Notifications({
    required this.id,
    required this.userId,
    required this.isMark,
    required this.titleEn,
    required this.descriptionEn,
    required this.titleAr,
    required this.descriptionAr,
    required this.imageName,
    required this.iconName,
    required this.notificationDetail,
    required this.createdDate,
    this.publishDate,
    required this.date,
    required this.requestStatus,
    required this.recipients,
  });

  factory Notifications.fromJson(Map<String, dynamic> json) {
    DateTime dateOnl = DateTime.parse(json["createdDate"]);
    return Notifications(
        id: json["id"],
        userId: json["userId"]??0,
        isMark: json["isMark"]??false,
        titleEn: json["titleEN"]??"",
        descriptionEn: json["descriptionEN"]??"",
        titleAr: json["titleAR"]??"",
        descriptionAr: json["descriptionAR"]??"",
      recipients: json["recipients"]??"",
        imageName: json["imageName"],
        iconName: json["iconName"]??"0",
      requestStatus: json["requestStatus"]??0,
        notificationDetail: json["notificationDetail"],
        date: DateTime(dateOnl.year,dateOnl.month,dateOnl.day),
        createdDate: json["createdDate"] != null
            ? DateTime.parse(json["createdDate"])
            : DateTime.now(),
      publishDate: json["publishDate"] != null
            ? DateTime.parse(json["publishDate"]).toLocal()
            : null,
      );
  }



}
