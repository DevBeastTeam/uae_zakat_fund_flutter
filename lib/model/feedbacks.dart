class Feedbacks {
  int id;
  int feedbackUserType;
  String nameEn;
  String nameAr;
  String email;
  int feedbackType;
  String mobile;
  String titleEn;
  String titleAr;
  String detailEn;
  String detailAr;
  int requestStatus;
  String? rejectNote;
  String? rejectionDocument;
  bool selected;
  String rootCause;
  String solutionProvided;
  String response;
  int categorization;
  int userId;
  String attachment;
  bool isClosed;

  Feedbacks({
    required this.id,
    required this.userId,
    required this.feedbackUserType,
    required this.nameEn,
    required this.nameAr,
    required this.email,
    required this.feedbackType,
    required this.mobile,
    required this.titleEn,
    required this.titleAr,
    required this.detailEn,
    required this.detailAr,
    required this.requestStatus,
    required this.rejectNote,
    required this.rejectionDocument,
    required this.selected,
    required this.response,
    required this.solutionProvided,
    required this.rootCause,
    required this.categorization,
    required this.attachment,
    required this.isClosed,
  });

  factory Feedbacks.fromJson(Map<String, dynamic> json) => Feedbacks(
        id: json["id"],
        feedbackUserType: json["feedbackUserType"],
        nameEn: json["nameEN"] ?? "",
        nameAr: json["nameAR"] ?? "",
        email: json["email"] ?? "",
        feedbackType: json["feedbackType"],
        mobile: json["mobile"] ?? "",
    attachment: json["attachment"] ?? "",
        titleEn: json["titleEN"] ?? "",
        titleAr: json["titleAR"] ?? "",
        detailEn: json["detailEN"] ?? "",
        detailAr: json["detailAR"] ?? "",
        requestStatus: json["requestStatus"],
        rejectNote: json["rejectNote"],
        rejectionDocument: json["rejectionDocument"],
        solutionProvided: json["solutionProvided"] ?? "",
        rootCause: json["rootCause"] ?? "",
        response: json["response"] ?? "",
        categorization: json["categorization"] ?? 0,
        userId: json["createdBy"] ?? 0,
        selected: false,
    isClosed: json["isClosed"] ??false,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "feedbackUserType": feedbackUserType,
        "nameEN": nameEn,
        "nameAR": nameAr,
        "email": email,
        "feedbackType": feedbackType,
        "mobile": mobile,
        "titleEN": titleEn,
        "titleAR": titleAr,
        "detailEN": detailEn,
        "detailAR": detailAr,
        "requestStatus": requestStatus,
        "rejectNote": rejectNote,
        "rejectionDocument": rejectionDocument,
        "attachment": attachment,
      };
}
