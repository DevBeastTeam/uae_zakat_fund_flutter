import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zakat_fund/widgets/video_widget.dart';

class Project {
  int userId;
  int accountId;
  String accountName;
  String accountNameArabic;
  String? accountLogo;
  String? associationCoverPhoto;
  String? associationDescriptionEN;
  String? associationDescriptionAR;
  dynamic facebook;
  dynamic linkedIn;
  dynamic twitter;
  dynamic instagram;
  String email;
  String mobile;
  String address;
  String addressArabic;
  List<ProjectElements> projects;
  List<ProjectElements> featuredProject;
  int requestStatus;
  int accountTypeID;

  Project({
    required this.userId,
    required this.addressArabic,
    required this.requestStatus,
    required this.accountId,
    required this.accountName,
    required this.accountNameArabic,
    required this.accountLogo,
    required this.associationCoverPhoto,
    required this.projects,
    required this.associationDescriptionEN,
    required this.associationDescriptionAR,
    required this.featuredProject,
    required this.facebook,
    required this.linkedIn,
    required this.twitter,
    required this.instagram,
    required this.email,
    required this.mobile,
    required this.address,
    required this.accountTypeID,
  });

  factory Project.fromJson(Map<String, dynamic> json) =>
      Project(
        accountTypeID: json["accountTypeID"]??0,
        facebook: json["facebook"],
        addressArabic: json["addressArabic"]??"",
        requestStatus: json["requestStatus"] ?? 1,
        linkedIn: json["linkedIn"],
        twitter: json["twitter"],
        instagram: json["instagram"],
        userId: json["userId"] ?? 0,
        email: json["email"] ?? "",
        mobile: json["mobile"] ?? "",
        address: json["address"] ?? "",
        accountId: json["accountID"] ?? 0,
        accountName: json["accountName"] ?? "",
        accountNameArabic: json["accountNameArabic"] ?? "",
        associationDescriptionEN: json["associationDescriptionEN"] ?? "",
        associationDescriptionAR: json["associationDescriptionAR"] ?? "",
        accountLogo: json["accountLogo"],
        associationCoverPhoto: json["associationCoverPhoto"],
        projects: json["projects"]!=null?List<ProjectElements>.from(
            json["projects"].map((x) => ProjectElements.fromJson(x))):[],
        featuredProject: json["featuredProject"] != null
            ? List<ProjectElements>.from(
            json["featuredProject"].map((x) => ProjectElements.fromJson(x)))
            : [],
      );
}

class ProjectPagination {
  int totalRecords;
  int pageNumber;
  int pageSize;
  ProjectsStats stats;
  bool success;
  List<ProjectElements> projects;
  int statusCode;
  dynamic errors;
  dynamic message;

  ProjectPagination({
    required this.totalRecords,
    required this.pageNumber,
    required this.pageSize,
    required this.stats,
    required this.success,
    required this.projects,
    required this.statusCode,
    required this.errors,
    required this.message,
  });

  factory ProjectPagination.fromJson(Map<String, dynamic> json) => ProjectPagination(
    totalRecords: json["totalRecords"],
    pageNumber: json["pageNumber"],
    pageSize: json["pageSize"],
    stats: ProjectsStats.fromJson(json["stats"]),
    success: json["success"],
    projects: List<ProjectElements>.from(json["data"].map((x) => ProjectElements.fromJson(x))),
    statusCode: json["statusCode"],
    errors: json["errors"],
    message: json["message"],
  );


}

class ProjectsStats {
  int overAllReceivedDonations;
  int totalTransferredAmount;
  int totalRequestedFundAmount;

  ProjectsStats({
    required this.overAllReceivedDonations,
    required this.totalTransferredAmount,
    required this.totalRequestedFundAmount,
  });

  factory ProjectsStats.fromJson(Map<String, dynamic> json) => ProjectsStats(
    overAllReceivedDonations: json["overAllReceivedDonations"],
    totalTransferredAmount: json["totalTransferredAmount"],
    totalRequestedFundAmount: json["totalRequestedFundAmount"],
  );

  Map<String, dynamic> toJson() => {
    "overAllReceivedDonations": overAllReceivedDonations,
    "totalTransferredAmount": totalTransferredAmount,
    "totalRequestedFundAmount": totalRequestedFundAmount,
  };
}


class ProjectElements {
  List<int> priceList;
  int? projectId;
  int price;
  TextEditingController controller;
  FocusNode focusNode;
  int associationId;
  String? associationName;
  String? associationNameArabic;
  String? associationLogo;
  String projectNameArabic;
  String projectName;
  List<ProjectImage> projectImages;
  String projectDescriptionShortArabic;
  String projectDescriptionShort;
  dynamic projectDescriptionLongArabic;
  dynamic projectDescriptionLong;
  dynamic projectAmountObjective;
  double? totalDonations;
  dynamic totalDonors;
  dynamic remainingAmount;
  dynamic percentOfCompletion;
  bool projectOnHighlight;
  bool isAddQuantity;
  dynamic minimumAmount;
  dynamic category;
  dynamic beneficiaryCount;
  dynamic quickAmount;
  dynamic selectedAmount;
  DateTime? startDate;
  DateTime? endDate;
  dynamic statusId;
  dynamic projectBeneficiary;
  String permitRequired;
  DateTime? permitStartDate;
  DateTime? permitEndDate;
  dynamic socialMediaLinksFacebook;
  dynamic socialMediaLinksLinkedIn;
  dynamic socialMediaLinksTwitter;
  dynamic socialMediaLinksInstagram;
  dynamic projectExternalWeblinks;
  bool isPublished;
  bool? isFavorite;
  bool? isFeaturedProjectForAssociation;
  bool? isFeaturedProjectForWebsiteAndApp;
  String? titleAr;
  String? titleEn;
  String? static1En;
  String? static2En;
  String? static1Ar;
  String? static2Ar;
  String? static1DescriptionEn;
  String? static2DescriptionEn;
  String? static1DescriptionAr;
  String? static2DescriptionAr;
  String? projectCoverWeb;
  String? projectCoverApp;
  bool? isUrgentProject;
  int? remainingDays;
  bool isSelected;


  int requestStatus;
  String? rejectNote;
  String? rejectionDocument;
  bool isActive;

  ProjectElements({
    required this.priceList,
    required this.controller,
    required this.focusNode,
    required this.price,
    required this.projectId,
    required this.associationId,
    required this.associationName,
    required this.associationNameArabic,
    required this.associationLogo,
    required this.projectNameArabic,
    required this.projectName,
    required this.projectImages,
    required this.projectDescriptionShortArabic,
    required this.projectDescriptionShort,
    required this.projectDescriptionLongArabic,
    required this.projectDescriptionLong,
    required this.projectAmountObjective,
    required this.totalDonations,
    required this.totalDonors,
    required this.remainingAmount,
    required this.percentOfCompletion,
    required this.projectOnHighlight,
    required this.isAddQuantity,
    required this.minimumAmount,
    required this.category,
    required this.beneficiaryCount,
    required this.quickAmount,
    required this.selectedAmount,
    required this.startDate,
    required this.endDate,
    required this.statusId,
    required this.projectBeneficiary,
    required this.permitRequired,
    required this.permitStartDate,
    required this.permitEndDate,
    required this.socialMediaLinksFacebook,
    required this.socialMediaLinksLinkedIn,
    required this.socialMediaLinksTwitter,
    required this.socialMediaLinksInstagram,
    required this.projectExternalWeblinks,
    required this.isPublished,
    required this.isFavorite,
    required this.isFeaturedProjectForAssociation,
    required this.isFeaturedProjectForWebsiteAndApp,
    required this.titleAr,
    required this.titleEn,
    required this.static1En,
    required this.static2En,
    required this.static1Ar,
    required this.static2Ar,
    required this.static1DescriptionEn,
    required this.static2DescriptionEn,
    required this.static1DescriptionAr,
    required this.static2DescriptionAr,
    required this.projectCoverWeb,
    required this.projectCoverApp,
    required this.isUrgentProject,
    required this.remainingDays,
    required this.requestStatus,
    required this.rejectNote,
    required this.rejectionDocument,
    required this.isSelected,
    required this.isActive,
  });

  factory ProjectElements.fromJson(Map<String, dynamic> json) =>
      ProjectElements(
        priceList: [10, 50, 100, 200],
        price: 10,
        controller: TextEditingController(),
        focusNode: FocusNode(),
        isSelected: false,
        rejectNote: json["rejectNote"],
        requestStatus: json["requestStatus"]==0?1:json["requestStatus"] ?? 1,
        rejectionDocument: json["rejectionDocument"],
        projectId: json["projectId"],
        associationId: json["associationId"]??0,
        associationName: json["associationName"]??"",

        associationNameArabic: json["associationNameArabic"]??"",
        associationLogo: json["associationLogo"],
        projectNameArabic: json["projectNameArabic"],
        projectName: json["projectName"],
        projectImages: json["projectImages"]!=null?List<ProjectImage>.from(
            json["projectImages"].map((x) => ProjectImage.fromJson(x))):[],
        projectDescriptionShortArabic: json["projectDescriptionShortArabic"],
        projectDescriptionShort: json["projectDescriptionShort"],
        projectDescriptionLongArabic:
        json["projectDescriptionLongArabic"] ?? "",
        projectDescriptionLong: json["projectDescriptionLong"] ?? "",
        projectAmountObjective: json["projectAmountObjective"] ?? 0,
        totalDonations: json["totalDonations"],
        totalDonors: json["totalDonors"]??0,
        remainingAmount: json["remainingAmount"],
        percentOfCompletion: json["percentOfCompletion"],
        projectOnHighlight: json["projectOnHighlight"] ?? false,
        isAddQuantity: json["isAddQuantity"],
        minimumAmount: json["minimumAmount"],
        category: json["category"],
        beneficiaryCount: json["beneficiaryCount"]??0,
        quickAmount: json["quickAmount"]==""?null:json["quickAmount"],
        selectedAmount: json["selectedAmount"],
        startDate: json["startDate"] != null
            ? DateTime.parse(json["startDate"]).toLocal()
            : null,
        endDate:
        json["endDate"] != null
            ? DateTime.parse(json["endDate"]).toLocal()
            : null,
        statusId: json["statusId"],
        projectBeneficiary: json["projectBeneficiary"],
        permitRequired: json["permitRequired"],
        permitStartDate: json["permitStartDate"] != null
            ? DateTime.parse(json["permitStartDate"]).toLocal()
            : null,
        permitEndDate: json["permitEndDate"] != null
            ? DateTime.parse(json["permitEndDate"]).toLocal()
            : null,
        socialMediaLinksFacebook: json["socialMediaLinksFacebook"],
        socialMediaLinksLinkedIn: json["socialMediaLinksLinkedIn"],
        socialMediaLinksTwitter: json["socialMediaLinksTwitter"],
        socialMediaLinksInstagram: json["socialMediaLinksInstagram"],
        projectExternalWeblinks: json["projectExternalWeblinks"],
        isPublished: json["isPublished"]??false,
        isFavorite: json["isFavorite"] ?? false,
        isFeaturedProjectForAssociation:
        json["isFeaturedProjectForAssociation"],
        isFeaturedProjectForWebsiteAndApp:
        json["isFeaturedProjectForWebsiteAndApp"],
        titleAr: json["titleAR"] ?? "",
        titleEn: json["titleEN"] ?? "",
        static1En: json["static1EN"],
        static2En: json["static2EN"],
        static1Ar: json["static1AR"],
        static2Ar: json["static2AR"],
        static1DescriptionEn: json["static1DescriptionEN"],
        static2DescriptionEn: json["static2DescriptionEN"],
        static1DescriptionAr: json["static1DescriptionAR"],
        static2DescriptionAr: json["static2DescriptionAR"],
        projectCoverWeb: json["projectCoverWeb"],
        projectCoverApp: json["projectCoverApp"],
        isUrgentProject: json["isUrgentProject"],
        remainingDays: json["remainingDays"],
        isActive: json["isActive"]??false,
      );

  Map<String, dynamic> toJson() =>
      {
        "projectId": projectId,
        "associationId": associationId,
        "associationName": associationName,
        "associationNameArabic": associationNameArabic,
        "associationLogo": associationLogo,
        "projectNameArabic": projectNameArabic,
        "projectName": projectName,
        "projectImages": List<dynamic>.from(
            projectImages.map((x) => x.toJson())),
        "projectDescriptionShortArabic": projectDescriptionShortArabic,
        "projectDescriptionShort": projectDescriptionShort,
        "projectDescriptionLongArabic": projectDescriptionLongArabic,
        "projectDescriptionLong": projectDescriptionLong,
        "projectAmountObjective": projectAmountObjective,
        "totalDonations": totalDonations,
        "totalDonors": totalDonors,
        "remainingAmount": remainingAmount,
        "percentOfCompletion": percentOfCompletion,
        "projectOnHighlight": projectOnHighlight,
        "isAddQuantity": isAddQuantity,
        "minimumAmount": minimumAmount,
        "category": category,
        "beneficiaryCount": beneficiaryCount,
        "quickAmount": quickAmount,
        "selectedAmount": selectedAmount,
        "startDate": startDate?.toIso8601String(),
        "endDate": endDate?.toIso8601String(),
        "statusId": statusId,
        "projectBeneficiary": projectBeneficiary,
        "permitRequired": permitRequired,
        "permitStartDate": permitStartDate?.toIso8601String(),
        "permitEndDate": permitEndDate?.toIso8601String(),
        "socialMediaLinksFacebook": socialMediaLinksFacebook,
        "socialMediaLinksLinkedIn": socialMediaLinksLinkedIn,
        "socialMediaLinksTwitter": socialMediaLinksTwitter,
        "socialMediaLinksInstagram": socialMediaLinksInstagram,
        "projectExternalWeblinks": projectExternalWeblinks,
        "isPublished": isPublished,
        "isFavorite": isFavorite,
        "isFeaturedProjectForAssociation": isFeaturedProjectForAssociation,
        "isFeaturedProjectForWebsiteAndApp": isFeaturedProjectForWebsiteAndApp,
        "titleAR": titleAr,
        "titleEN": titleEn,
        "static1EN": static1En,
        "static2EN": static2En,
        "static1AR": static1Ar,
        "static2AR": static2Ar,
        "static1DescriptionEN": static1DescriptionEn,
        "static2DescriptionEN": static2DescriptionEn,
        "static1DescriptionAR": static1DescriptionAr,
        "static2DescriptionAR": static2DescriptionAr,
        "projectCoverWeb": projectCoverWeb,
        "projectCoverApp": projectCoverApp,
        "isUrgentProject": isUrgentProject,
        "remainingDays": remainingDays,
        "requestStatus": requestStatus,
        "rejectNote": rejectNote,
        "rejectionDocument": rejectionDocument,
      };

}

class ProjectImage {
  int? id;
  int? projectId;
  String mediaUrl;
  int mediaType;
  GlobalKey<VideoPlayerWidgetState>? playerKey;

  ProjectImage({
    this.id,
    this.projectId,
    required this.mediaType,
    required this.mediaUrl,
    this.playerKey,
  });

  factory ProjectImage.fromJson(Map<String, dynamic> json) {
    return ProjectImage(
      id: json["id"],
      projectId: json["projectId"],
      mediaUrl: json["mediaURL"],
      mediaType: json["mediaType"] ?? 0,
      playerKey: json["mediaType"] != null && json["mediaType"] == 1
          ? GlobalKey<VideoPlayerWidgetState>()
          : null,
    );
  }

  Map<String, dynamic> toJson() =>
      {
        "id": id,
        "projectId": projectId,
        "mediaURL": mediaUrl,
      };
}
