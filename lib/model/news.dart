class News {
  int id;
  int? newsId;
  String titleEn;
  String descriptionEn;
  String titleAr;
  String descriptionAr;
  String firstPicture;
  String secondPicture;
  String thumbNail;
  DateTime createdDate;
  bool isFavorite;
  int newsCategoryId;
  int requestStatus;
  String? rejectNote;
  String? rejectionDocument;

  dynamic associationId;
  String authorNameEN;
  String authorNameAR;
  String descriptionShortEN;
  String descriptionShortAR;
  DateTime? publishDate;
  bool isActive;

  News({
    required this.id,
    required this.newsId,
    required this.titleEn,
    required this.descriptionEn,
    required this.titleAr,
    required this.isFavorite,
    required this.descriptionAr,
    required this.firstPicture,
    required this.secondPicture,
    required this.thumbNail,
    required this.createdDate,
    required this.newsCategoryId,
    required this.requestStatus,
    required this.isActive,
    required this.associationId,
    required this.rejectNote,
    required this.rejectionDocument,
    required this.authorNameEN,
    required this.authorNameAR,
    required this.descriptionShortEN,
    required this.descriptionShortAR,
    required this.publishDate,
  });

  News.empty()
      : id = 0,
        titleEn = '',
        descriptionEn = '',
        titleAr = '',
        descriptionAr = '',
        firstPicture = '',
        secondPicture = '',
        thumbNail = '',
        authorNameEN = '',
        authorNameAR = '',
        descriptionShortEN = '',
        descriptionShortAR = '',
        isActive = false,
        newsCategoryId = 0,
        requestStatus = 1,
        createdDate = DateTime.now(),
        publishDate = DateTime.now(),
        isFavorite = false;

  factory News.fromJson(Map<String, dynamic> json) => News(
        id: json["id"],
        newsId: json["newsId"] ?? 0,
    isActive: json["isActive"] ?? false,
        newsCategoryId: json["newsCategoryId"] ?? 0,
        titleEn: json["titleEN"] ?? "",
        descriptionEn: json["descriptionEN"] ?? "",
        titleAr: json["titleAR"] ?? "",
        descriptionAr: json["descriptionAR"] ?? "",
        firstPicture: json["firstPicture"] ?? "",
        secondPicture: json["secondPicture"] ?? "",
        thumbNail: json["thumbNail"] ?? "",
    authorNameEN: json["authorNameEN"] ?? "",
    authorNameAR: json["authorNameAR"] ?? "",
    descriptionShortEN: json["descriptionShortEN"] ?? "",
    descriptionShortAR: json["descriptionShortAR"] ?? "",
    publishDate: json["publishDate"]!=null?DateTime.parse(json["publishDate"]).toLocal():null,
        isFavorite: json["isFavorite"] ?? false,
        rejectionDocument: json["rejectionDocument"],
        rejectNote: json["rejectNote"],
        requestStatus: json["requestStatus"]??1,
        createdDate: DateTime.parse(json["createdDate"]).toLocal(),
        associationId: json["associationId"],
      );


}
