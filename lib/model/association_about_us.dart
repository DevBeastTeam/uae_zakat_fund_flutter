class AssociationAboutUs {
  int id;
  String titleEn;
  String descriptionEn;
  String titleAr;
  String descriptionAr;
  String firstPicture;
  String secondPicture;
  int beneficiaries;
  int amountRaised;
  int projectsCompleted;
  int associationId;
  int? requestStatus;

  AssociationAboutUs.empty()
      : id = 0,
        titleEn = '',
        descriptionEn = '',
        titleAr = '',
        descriptionAr = '',
        firstPicture = '',
        secondPicture = '',
        beneficiaries = 0,
        amountRaised = 0,
        projectsCompleted = 0,
        associationId = 0;

  AssociationAboutUs({
    required this.id,
    required this.titleEn,
    required this.descriptionEn,
    required this.titleAr,
    required this.descriptionAr,
    required this.firstPicture,
    required this.secondPicture,
    required this.beneficiaries,
    required this.amountRaised,
    required this.projectsCompleted,
    required this.associationId,
    required this.requestStatus,
  });

  factory AssociationAboutUs.fromJson(Map<String, dynamic> json) => AssociationAboutUs(
    id: json["id"],
    requestStatus: json["requestStatus"],
    titleEn: json["titleEN"]??"",
    descriptionEn: json["descriptionEN"]??"",
    titleAr: json["titleAR"]??"",
    descriptionAr: json["descriptionAR"]??"",
    firstPicture: json["firstPicture"]??"",
    secondPicture: json["secondPicture"]??"",
    beneficiaries: json["beneficiaries"]??0,
    amountRaised: json["amountRaised"]??0,
    projectsCompleted: json["projectsCompleted"]??0,
    associationId: json["associationId"]??1,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "titleEN": titleEn,
    "descriptionEN": descriptionEn,
    "titleAR": titleAr,
    "descriptionAR": descriptionAr,
    "firstPicture": firstPicture,
    "secondPicture": secondPicture,
    "beneficiaries": beneficiaries,
    "amountRaised": amountRaised,
    "projectsCompleted": projectsCompleted,
    "associationId": associationId,
  };
}
