class StaticPage {
  String? pageLink;
  String? pageTitleEN;
  String? pageNameEN;
  String? pageTitleAR;
  int? pageSection;
  int? pageOrder;
  int? parentPage;
  int? id;
  int? requestStatus;
  int? pageLanguage;
  bool isPageActive;

  StaticPage({
    this.pageLink,
    this.pageSection,
    this.pageOrder,
    this.pageTitleEN,
    this.parentPage,
    this.pageLanguage,
    this.pageTitleAR,
    this.pageNameEN,
    this.requestStatus,
    this.isPageActive = true,
    this.id,
  });

  factory StaticPage.fromJson(Map<String, dynamic> json) => StaticPage(
        pageTitleAR: json["pageTitleAR"],
        requestStatus: json["requestStatus"],
        isPageActive: json["isPageActive"],
        pageLink: json["pageLink"],
        pageSection: json["pageSection"],
        pageNameEN: json["pageNameEN"],
        parentPage: json["parentPage"],
        pageTitleEN: json["pageTitleEN"],
        pageLanguage: json["pageLanguage"],
        pageOrder: json["pageOrder"],
        id: json["id"],
      );
}
