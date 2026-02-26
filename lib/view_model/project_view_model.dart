import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:zakat_fund/data/response/app_state.dart';
import 'package:zakat_fund/data/response/network_response.dart';
import 'package:zakat_fund/model/additional_documents.dart';
import 'package:zakat_fund/model/image_type.dart';
import 'package:zakat_fund/model/lookup_data.dart';
import 'package:zakat_fund/model/project.dart';
import 'package:zakat_fund/model/request_body.dart';
import 'package:zakat_fund/model/user.dart';
import 'package:zakat_fund/model/user_preferences.dart';
import 'package:zakat_fund/my_app/my_app.dart';
import 'package:zakat_fund/repository/generic_repo.dart';
import 'package:zakat_fund/repository/project_repo.dart';
import 'package:zakat_fund/utils/constants/api_constant.dart';
import 'package:zakat_fund/utils/constants/event_constant.dart';
import 'package:zakat_fund/utils/mixins/generic_mixin.dart';
import 'package:zakat_fund/utils/routes/app_routes.dart';
import 'package:zakat_fund/utils/utils.dart';

class ProjectViewModel extends GetxController with GenericMixin {
  final projectNameInArabicController = TextEditingController();
  final projectNameInEnglishController = TextEditingController();
  final startDateController = TextEditingController();
  final endDateController = TextEditingController();
  final noOfBeneficiariesController = TextEditingController();
  final projectGoalController = TextEditingController();
  final briefDescriptionInArabicController = TextEditingController();
  final briefDescriptionInEnglishController = TextEditingController();
  final licenseStartDateController = TextEditingController();
  final licenseEndDateController = TextEditingController();
  final longDescriptionInArabicController = TextEditingController();
  final longDescriptionInEnglishController = TextEditingController();
  final instagramController = TextEditingController();
  final twitterController = TextEditingController();
  final facebookController = TextEditingController();
  final linkedInController = TextEditingController();
  final websiteController = TextEditingController();
  final quickAmountController = TextEditingController();
  final minimumAmountController = TextEditingController();
  final titleInEnglishController = TextEditingController();
  final titleInArabicController = TextEditingController();
  final static1EnglishController = TextEditingController();
  final static1ArabicController = TextEditingController();
  final static1DescEnglishController = TextEditingController();
  final static1DescArabicController = TextEditingController();
  final static2EnglishController = TextEditingController();
  final static2ArabicController = TextEditingController();
  final static2DescEnglishController = TextEditingController();
  final static2DescArabicController = TextEditingController();
  final projectLicenseController = TextEditingController();
  final projectCoverForAppController = TextEditingController();
  final projectCoverForWebController = TextEditingController();
  final scrollController = ScrollController();

  var formKey = GlobalKey<FormState>();

  final projectNameInArabicNode = FocusNode();
  final projectNameInEnglishNode = FocusNode();
  final noOfBeneficiariesNode = FocusNode();
  final projectGoalNode = FocusNode();
  final briefDescriptionInArabicNode = FocusNode();
  final briefDescriptionInEnglishNode = FocusNode();
  final longDescriptionInArabicNode = FocusNode();
  final longDescriptionInEnglishNode = FocusNode();
  final quickAmountNode = FocusNode();
  final minimumAmountNode = FocusNode();
  final static1DescEnglishNode = FocusNode();
  final static1DescArabicNode = FocusNode();
  final static2DescEnglishNode = FocusNode();
  final static2DescArabicNode = FocusNode();
  final startDateNode = FocusNode();
  final endDateNode = FocusNode();
  final licenseEndDateNode = FocusNode();
  final licenseStartDateNode = FocusNode();
  final projectLicenseNode = FocusNode();
  final titleInEnglishNode = FocusNode();
  final titleInArabicNode = FocusNode();
  final static1EnglishNode = FocusNode();
  final static2EnglishNode = FocusNode();
  final static1ArabicNode = FocusNode();
  final static2ArabicNode = FocusNode();
  final categoriesNode = FocusNode();
  final beneficiariesOfProjectNode = FocusNode();

  RxBool isClicked = false.obs;
  RxBool showAdditionalDocuments = true.obs;

  RxString selectedFeaturedForAssociation = "no".obs;
  RxString selectedFeaturedForWebAp = "no".obs;

  Rxn<LookupData> selectedBeneficiary = Rxn<LookupData>();

  RxList<String> amounts = <String>[].obs;
  RxList<ImageType> imagesList = <ImageType>[].obs;
  RxList<LookupData> categoriesList = <LookupData>[].obs;
  RxList<LookupData> beneficiariesList = <LookupData>[].obs;
  RxList<LookupData> selectedCategories = <LookupData>[].obs;

  Rx<UserPreferences> addQuantities =
      UserPreferences(name: 'addQuantities', selectedChoice: 1).obs;
  Rx<UserPreferences> urgentProject =
      UserPreferences(name: 'urgentProject', selectedChoice: 1).obs;

  DateTime? pickedStartDate;
  DateTime? pickedExpiryDate;
  DateTime? pickedLicenseStart;
  DateTime? pickedLicenseExpirt;

  PlatformFile? licenseFile;
  File? coverAppFile, coverWebFile;

  String licensePhoto = "", appCover = "", webCover = "";

  List<ProjectImage> images = [];
  late User user;

  int? projectId;
  ProjectElements? project;

  final genericRepo = GenericRepoImpl();
  final projectRepo = ProjectRepoImpl();

  Map<String, dynamic>? body = {};
  RxList<AdditionalDocuments> additionalDocuments = <AdditionalDocuments>[].obs;
  int pId = 0;
  late List<KeyboardActionsItem> keyboardActionsItem;

  @override
  onInit() {
    _initializeData();
    super.onInit();
  }

  _initializeData() async {
    keyboardActionsItem = [
      KeyboardActionsItem(
          focusNode: projectNameInArabicNode, displayArrows: false),
      KeyboardActionsItem(
          focusNode: projectNameInEnglishNode, displayArrows: false),
      KeyboardActionsItem(
          focusNode: noOfBeneficiariesNode, displayArrows: false),
      KeyboardActionsItem(focusNode: projectGoalNode, displayArrows: false),
      KeyboardActionsItem(
          focusNode: briefDescriptionInArabicNode, displayArrows: false),
      KeyboardActionsItem(
          focusNode: briefDescriptionInEnglishNode, displayArrows: false),
      KeyboardActionsItem(
          focusNode: longDescriptionInArabicNode, displayArrows: false),
      KeyboardActionsItem(
          focusNode: longDescriptionInEnglishNode, displayArrows: false),
      KeyboardActionsItem(focusNode: quickAmountNode, displayArrows: false),
      KeyboardActionsItem(focusNode: minimumAmountNode, displayArrows: false),
      KeyboardActionsItem(
          focusNode: static1DescEnglishNode, displayArrows: false),
      KeyboardActionsItem(
          focusNode: static1DescArabicNode, displayArrows: false),
      KeyboardActionsItem(
          focusNode: static2DescEnglishNode, displayArrows: false),
      KeyboardActionsItem(
          focusNode: static2DescArabicNode, displayArrows: false),
    ];

    user = userBox.getAt(0);
    project = Get.arguments;
    if (project != null) {
      pId = project!.projectId!;
    }
    Utils.logEvent(
        name: project != null
            ? EventConstant.updateProjectScreen
            : EventConstant.addNewProjectScreen);
    try {
      Utils.showLoadingDialog();
      await Future.wait([
        fetchCategoriesTypes(),
        fetchAdditionalDocuments(),
        fetchBeneficiaryTypes()
      ]);
    } finally {
      Utils.hideLoadingDialog();
    }
    setData();
  }

  addQuickAmounts() {
    String quickAmount = quickAmountController.text.trim();
    if (quickAmount.isEmpty || quickAmount == "0") {
      return;
    }
    if (!amounts.contains(quickAmount)) {
      amounts.add(quickAmount);
      amounts.refresh();
    }
    quickAmountController.clear();
  }

  deleteQuickAmount(int index) {
    amounts.removeAt(index);
    amounts.refresh();
    if (amounts.isEmpty) {
      addQuantities.value.selectedChoice = 1;
      addQuantities.refresh();
    }
  }

  addCategory(int index) {
    selectedCategories.add(categoriesList[index]);
    categoriesList.removeAt(index);
    selectedCategories.refresh();
    categoriesList.refresh();
  }

  removeCategory(int index) {
    categoriesList.add(selectedCategories[index]);
    selectedCategories.removeAt(index);
    selectedCategories.refresh();
    categoriesList.refresh();
  }

  addImages() async {
    List<XFile> images = await Utils.pickMultipleImages();
    if (images.isNotEmpty) {
      for (XFile file in images) {
        if (imagesList.length < 10) {
          imagesList
              .add(ImageType(image: file.path, urlImage: false, mediaType: 0));
        }
      }
      imagesList.refresh();
    }
  }

  addCover({bool isApp = false}) async {
    XFile? image = await Utils.imgFromGallery();
    if (image != null) {
      Utils.showLoadingDialog();
      if (isApp) {
        coverAppFile = File(image.path);
        await uploadPicture(isAppCover: true, path: coverAppFile!.path);
      } else {
        coverWebFile = File(image.path);
        await uploadPicture(isWebCover: true, path: coverWebFile!.path);
      }
      Utils.hideLoadingDialog();
    }
  }

  addVideos() async {
    PlatformFile? file =
        await Utils.pickFile(allowedExtensions: ["mp4"], isVideo: true);
    if (file != null) {
      if (imagesList.length < 10) {
        imagesList
            .add(ImageType(urlImage: false, image: file.path!, mediaType: 1));
        imagesList.refresh();
      }
    }
  }

  Future fetchCategoriesTypes() async {
    final result = await getLookUpData(endPoint: ApiConstant.projectCategories);
    categoriesList.value = result;
  }

  Future fetchBeneficiaryTypes() async {
    final result =
        await getLookUpData(endPoint: ApiConstant.projectBeneficiaryTypes);
    beneficiariesList.value = result;
  }

  Future fetchAdditionalDocuments() async {
    final result = await getAdditionalDocuments(
        endPoint: "${ApiConstant.additionalDocuments}/3/$pId/3");
    additionalDocuments.value = result;
  }

  Future saveAdditionalDocuments(bool saveAsDraft) async {
    if (additionalDocuments.isNotEmpty) {
      List docList = [];
      docList = additionalDocuments
          .map((doc) => {
                "Id": doc.id,
                "path": doc.selectedFileName,
                "startDateValue":
                    doc.startDateController.text.replaceAll("/", "-"),
                "endDateValue": doc.endDateController.text.replaceAll("/", "-")
              })
          .toList();
      var body = {
        "docList": docList,
        "accountId": 0,
        "userId": 0,
        "documentAssociatedId": 3,
        "projectId": pId
      };
      final result = await addAdditionalDocuments(body: body);
      if (result) {
        if (saveAsDraft) {
          Utils.showGlobalSnackBar(message: "saveAsDraftSuccessfully".tr);
        } else {
          Utils.showGlobalSnackBar(message: "projectSubmittedSuccessfully".tr);
        }
        Get.back(result: true);
      }
    } else {
      Utils.hideLoadingDialog();
      if (saveAsDraft) {
        Utils.showGlobalSnackBar(message: "saveAsDraftSuccessfully".tr);
      } else {
        Utils.showGlobalSnackBar(message: "projectSubmittedSuccessfully".tr);
      }
      Get.back(result: true);
    }
  }

  setData() async {
    if (project != null) {
      projectId = project!.projectId;
      for (ProjectImage image in project!.projectImages) {
        imagesList.add(ImageType(
            image: image.mediaUrl, urlImage: true, mediaType: image.mediaType));
      }
      projectNameInArabicController.text = project!.projectNameArabic;
      projectNameInEnglishController.text = project!.projectName;
      if (project!.startDate != null) {
        pickedStartDate = project!.startDate;
        startDateController.text = Utils.dateFormat1.format(pickedStartDate!);
      }
      if (project!.endDate != null) {
        pickedExpiryDate = project!.endDate;
        endDateController.text = Utils.dateFormat1.format(pickedExpiryDate!);
      }
      if (project!.projectBeneficiary != null) {
        LookupData? data = beneficiariesList.firstWhereOrNull(
            (beneficiary) => beneficiary.value == project?.projectBeneficiary!);
        if (data != null) {
          selectedBeneficiary.value = data;
        }
      }
      if (project!.beneficiaryCount != null && project!.beneficiaryCount > 0) {
        noOfBeneficiariesController.text = "${project!.beneficiaryCount}";
      }
      if (project!.projectAmountObjective != null &&
          project!.projectAmountObjective > 0.0) {
        projectGoalController.text = "${project!.projectAmountObjective}";
      }

      briefDescriptionInArabicController.text =
          project!.projectDescriptionShortArabic;
      briefDescriptionInEnglishController.text =
          project!.projectDescriptionShort;
      if (project!.permitRequired != "") {
        licensePhoto = project!.permitRequired;
        projectLicenseController.text = licensePhoto;
      }

      if (project!.permitStartDate != null) {
        pickedLicenseStart = project!.permitStartDate;
        licenseStartDateController.text =
            Utils.dateFormat1.format(pickedLicenseStart!);
      }
      if (project!.permitEndDate != null) {
        pickedLicenseExpirt = project!.permitEndDate;
        licenseEndDateController.text =
            Utils.dateFormat1.format(pickedLicenseExpirt!);
      }

      longDescriptionInArabicController.text =
          project!.projectDescriptionLongArabic ?? "";
      longDescriptionInEnglishController.text =
          project!.projectDescriptionLong ?? "";
      instagramController.text = project!.socialMediaLinksInstagram ?? "";
      twitterController.text = project!.socialMediaLinksTwitter ?? "";
      facebookController.text = project!.socialMediaLinksFacebook ?? "";
      linkedInController.text = project!.socialMediaLinksLinkedIn ?? "";
      websiteController.text = project!.projectExternalWeblinks ?? "";
      addQuantities.value.selectedChoice = project!.isAddQuantity ? 0 : 1;
      addQuantities.refresh();
      urgentProject.value.selectedChoice = project!.isUrgentProject! ? 0 : 1;
      urgentProject.refresh();
      minimumAmountController.text = "${project!.minimumAmount ?? ""}";
      if (project!.quickAmount != null) {
        amounts.value = project!.quickAmount.split(',');
      }
      if (project!.category != null && project!.category != "") {
        List<String> cats = project!.category.split(',');
        for (String id in cats) {
          LookupData? data = categoriesList
              .firstWhereOrNull((data) => data.value == int.parse(id));
          if (data != null) {
            categoriesList.removeWhere((category) => category == data);
            selectedCategories.add(data);
          }
        }
        selectedCategories.refresh();
        categoriesList.refresh();
      }
      if (project!.isFeaturedProjectForAssociation != null) {
        selectedFeaturedForAssociation.value =
            project!.isFeaturedProjectForAssociation! ? "yes" : "no";
      }
      if (project!.isFeaturedProjectForWebsiteAndApp != null) {
        selectedFeaturedForWebAp.value =
            project!.isFeaturedProjectForWebsiteAndApp! ? "yes" : "no";
      }
      titleInEnglishController.text = project!.titleEn ?? "";
      titleInArabicController.text = project!.titleAr ?? "";
      static1EnglishController.text = project!.static1En ?? "";
      static1ArabicController.text = project!.static1Ar ?? "";
      static1DescEnglishController.text = project!.static1DescriptionEn ?? "";
      static1DescArabicController.text = project!.static1DescriptionAr ?? "";
      static2EnglishController.text = project!.static2En ?? "";
      static2ArabicController.text = project!.static2Ar ?? "";
      static2DescEnglishController.text = project!.static2DescriptionEn ?? "";
      static2DescArabicController.text = project!.static2DescriptionAr ?? "";
      if (project!.projectCoverApp != null) {
        appCover = project!.projectCoverApp!;
        projectCoverForAppController.text = appCover;
      }
      if (project!.projectCoverWeb != null) {
        webCover = project!.projectCoverWeb!;
        projectCoverForWebController.text = webCover;
      }
    }
  }

  submitProject({bool saveAsDraft = false, bool showPreview = false}) async {
    if (!saveAsDraft && !showPreview) {
      isClicked.value = true;
      final isValid = formKey.currentState!.validate();
      if (!isValid) {
        if (imagesList.isEmpty) {
          scrollController.animateTo(0.0,
              duration: const Duration(milliseconds: 500), curve: Curves.ease);
          return;
        }
        if (Utils.isEmpty(projectNameInEnglishController.text)) {
          Utils.scrollToTextField(projectNameInEnglishNode);
          return;
        }
        if (Utils.isEmpty(projectNameInArabicController.text)) {
          Utils.scrollToTextField(projectNameInArabicNode);
          return;
        }

        if (Utils.isEmpty(startDateController.text)) {
          Utils.scrollToTextField(startDateNode);
          return;
        }
        if (Utils.isEmpty(endDateController.text)) {
          Utils.scrollToTextField(endDateNode);
          return;
        }

        if (selectedBeneficiary.value == null) {
          Utils.scrollToTextField(beneficiariesOfProjectNode);
          return;
        }
        if (Utils.isEmpty(noOfBeneficiariesController.text)) {
          Utils.scrollToTextField(noOfBeneficiariesNode);
          return;
        }
        if (Utils.isEmpty(projectGoalController.text)) {
          Utils.scrollToTextField(projectGoalNode);
          return;
        }
        if (Utils.isEmpty(briefDescriptionInArabicController.text)) {
          Utils.scrollToTextField(briefDescriptionInArabicNode);
          return;
        }
        if (Utils.isEmpty(briefDescriptionInEnglishController.text)) {
          Utils.scrollToTextField(briefDescriptionInEnglishNode);
          return;
        }
        if (Utils.isEmpty(projectLicenseController.text)) {
          Utils.scrollToTextField(projectLicenseNode);
          return;
        }
        if (Utils.isEmpty(licenseStartDateController.text)) {
          Utils.scrollToTextField(licenseStartDateNode);
          return;
        }
        if (Utils.isEmpty(licenseEndDateController.text)) {
          Utils.scrollToTextField(licenseEndDateNode);
          return;
        }
        if (selectedCategories.isEmpty) {
          Utils.scrollToTextField(categoriesNode);
        }
        if (Utils.isEmpty(minimumAmountController.text)) {
          Utils.scrollToTextField(minimumAmountNode);
          return;
        }
        if (Utils.isEmpty(titleInEnglishController.text)) {
          Utils.scrollToTextField(titleInEnglishNode);
          return;
        }
        if (Utils.isEmpty(titleInArabicController.text)) {
          Utils.scrollToTextField(titleInArabicNode);
          return;
        }
        if (Utils.isEmpty(static1EnglishController.text)) {
          Utils.scrollToTextField(static1EnglishNode);
          return;
        }
        if (Utils.isEmpty(static1ArabicController.text)) {
          Utils.scrollToTextField(static1ArabicNode);
          return;
        }
        if (Utils.isEmpty(static1DescEnglishController.text)) {
          Utils.scrollToTextField(static1DescEnglishNode);
          return;
        }
        if (Utils.isEmpty(static1DescArabicController.text)) {
          Utils.scrollToTextField(static1DescArabicNode);
          return;
        }
        if (Utils.isEmpty(static2EnglishController.text)) {
          Utils.scrollToTextField(static2EnglishNode);
          return;
        }
        if (Utils.isEmpty(static2ArabicController.text)) {
          Utils.scrollToTextField(static2ArabicNode);
          return;
        }
        if (Utils.isEmpty(static2DescEnglishController.text)) {
          Utils.scrollToTextField(static2DescEnglishNode);
          return;
        }
        if (Utils.isEmpty(static2DescArabicController.text)) {
          Utils.scrollToTextField(static2DescArabicNode);
          return;
        }
        return;
      }
      if (imagesList.isEmpty) {
        Utils.showGlobalSnackBar(message: "add1Image".tr);
        return;
      }
      DateTime dateOfExpiry = pickedExpiryDate!;
      if (dateOfExpiry.isBefore(DateTime.now())) {
        Utils.showGlobalSnackBar(message: "projectEndDateMustFuture".tr);
        Utils.scrollToTextField(endDateNode);
        return;
      }
      if (selectedBeneficiary.value == null) {
        Utils.showGlobalSnackBar(
            message: "${"beneficiariesOfTheProject".tr} ${"isRequired".tr}");
        return;
      }
      DateTime licenseDateOfExpiry = pickedLicenseExpirt!;
      if (licenseDateOfExpiry.isBefore(DateTime.now())) {
        Utils.showGlobalSnackBar(message: "permitEndDateMustFuture".tr);
        Utils.scrollToTextField(licenseEndDateNode);
        return;
      }
      if (selectedCategories.isEmpty) {
        Utils.showGlobalSnackBar(
            message: "${"category".tr} ${"isRequired".tr}");
        return;
      }
    } else {
      if (projectNameInEnglishController.text.trim().isEmpty) {
        Utils.showGlobalSnackBar(
            message: "${"projectNameInEnglish".tr} ${"isRequired".tr}");
        Utils.scrollToTextField(projectNameInEnglishNode);
        return;
      }

      if (projectNameInArabicController.text.trim().isEmpty) {
        Utils.showGlobalSnackBar(
            message: "${"projectNameInArabic".tr} ${"isRequired".tr}");
        Utils.scrollToTextField(projectNameInArabicNode);
        return;
      }
    }
    if (!showPreview) Utils.showLoadingDialog();
    DateTime? endDate, licenseEndDate;
    DateTime? startDate, licenseStartDate;
    endDate = pickedExpiryDate;
    licenseEndDate = pickedLicenseExpirt;
    var projectImages = [];
    if (!showPreview) {
      images = [];
      for (ImageType type in imagesList) {
        if (!type.urlImage) {
          await uploadPicture(path: type.image, type: type.mediaType);
        } else {
          projectImages
              .add({"mediaURL": type.image, "mediaType": type.mediaType});
        }
      }
      for (ProjectImage image in images) {
        projectImages
            .add({"mediaURL": image.mediaUrl, "mediaType": image.mediaType});
      }

      if (projectImages.isEmpty) {
        Utils.showGlobalSnackBar(message: "add1Image".tr);
        if (!showPreview) Utils.hideLoadingDialog();
        return;
      }
    } else {
      for (ImageType type in imagesList) {
        projectImages.add({
          "mediaURL": type.image,
          "mediaType": type.mediaType,
          "projectId": type.urlImage ? 1 : null,
        });
      }
    }

    if (pickedStartDate != null) {
      startDate = pickedStartDate;
    }
    if (pickedLicenseStart != null) {
      licenseStartDate = pickedLicenseStart;
    }
    List<String> cats = [];
    if (selectedCategories.isNotEmpty) {
      for (LookupData cat in selectedCategories) {
        cats.add(cat.value.toString());
      }
    }
    int? beneficiaryId;
    if (selectedBeneficiary.value != null) {
      beneficiaryId = selectedBeneficiary.value!.value;
    }
    body = {
      "associationId": user.accountId!,
      "projectNameArabic": projectNameInArabicController.text,
      "projectName": projectNameInEnglishController.text,
      "startDate":
          startDate != null ? Utils.formatToIsoWithZeroTime(startDate) : null,
      "endDate":
          endDate != null ? Utils.formatToIsoWithZeroTime(endDate) : null,
      "projectImages": projectImages,
      "projectExternalWeblinks": websiteController.text,
      "projectDescriptionShortArabic": briefDescriptionInArabicController.text,
      "projectDescriptionShort": briefDescriptionInEnglishController.text,
      "projectDescriptionLongArabic": longDescriptionInArabicController.text,
      "projectDescriptionLong": longDescriptionInEnglishController.text,
      "projectAmountObjective": projectGoalController.text.trim().isEmpty
          ? null
          : projectGoalController.text,
      "projectBeneficiary":
          selectedBeneficiary.value != null ? beneficiaryId : null,
      "permitRequired": licensePhoto,
      "permitStartDate": licenseStartDate != null
          ? Utils.formatToIsoWithZeroTime(licenseStartDate)
          : null,
      "permitEndDate": licenseEndDate != null
          ? Utils.formatToIsoWithZeroTime(licenseEndDate)
          : null,
      "socialMediaLinksFacebook": facebookController.text,
      "socialMediaLinksLinkedIn": linkedInController.text,
      "socialMediaLinksTwitter": twitterController.text,
      "socialMediaLinksInstagram": instagramController.text,
      "statusId": 0,
      "isAddQuantity": addQuantities.value.selectedChoice == 0,
      "minimumAmount": minimumAmountController.text.isNotEmpty
          ? minimumAmountController.text
          : null,
      "category": selectedCategories.isNotEmpty ? cats.join(",") : "",
      "isPublished": true,
      if (amounts.isNotEmpty) "quickAmount": amounts.join(","),
      if (noOfBeneficiariesController.text.isNotEmpty)
        "beneficiaryCount": noOfBeneficiariesController.text,
      "qtyQuickAmount": 1,
      "totalDonations": project != null ? project?.totalDonations : 0.0,
      "isFeaturedProjectForAssociation":
          selectedFeaturedForAssociation.value == "yes",
      "isFeaturedProjectForWebsiteAndApp":
          selectedFeaturedForWebAp.value == "yes",
      "isUrgentProject": urgentProject.value.selectedChoice == 0,
      "remainingAmount":
          project?.remainingAmount ?? project?.projectAmountObjective
    };

    if (selectedFeaturedForAssociation.value == "yes" ||
        selectedFeaturedForWebAp.value == "yes") {
      body!.addAll({
        "titleAR": titleInArabicController.text,
        "titleEN": titleInEnglishController.text,
        "static1EN": static1EnglishController.text,
        "static2EN": static2EnglishController.text,
        "static1AR": static1ArabicController.text,
        "static2AR": static2ArabicController.text,
        "static1DescriptionEN": static1DescEnglishController.text,
        "static2DescriptionEN": static2DescEnglishController.text,
        "static1DescriptionAR": static1DescArabicController.text,
        "static2DescriptionAR": static2DescArabicController.text,
        "projectCoverWeb": webCover,
        "projectCoverApp": appCover,
      });
    }
    Map<String, dynamic>? queryParameters;
    if (showPreview) {
      ProjectElements project = ProjectElements.fromJson(body!);
      project.associationLogo = user.photo;
      project.associationName = user.firstName;
      project.associationNameArabic = user.firstNameArabic;
      Get.toNamed(AppRoutes.projectDetailsScreen,
          arguments: {"project": project, "isPreview": true});
    } else {
      if (saveAsDraft) {
        if (project != null) {
          queryParameters = {
            "draftId": project?.projectId,
          };
        }
        var draftBody = {
          "userId": user.id,
          "accountId": user.accountId,
          "draftType": 2,
          "draftJson": jsonEncode(body),
          if (project != null) "draftId": project?.projectId
        };
        ApiResponse apiResponse = await genericRepo.saveAsDraft(
            request:
                RequestBody(body: draftBody, queryParameters: queryParameters));
        if (apiResponse.appState == AppState.onSuccess) {
          projectId ??= apiResponse.data;
          pId = projectId!;
          saveAdditionalDocuments(saveAsDraft);
        } else if (apiResponse.appState == AppState.onFailure) {
          Utils.hideLoadingDialog();
          Utils.showGlobalSnackBar(message: apiResponse.message!);
        } else if (apiResponse.appState == AppState.onUnauthorized) {
          Utils.logInAgain();
        }
      } else {
        if (project != null && project?.requestStatus == 8) {
          queryParameters = {
            "draftId": project?.projectId,
          };

          ApiResponse apiResponse1 = await genericRepo.updateDraft(
              request: RequestBody(queryParameters: queryParameters));
          if (apiResponse1.appState != AppState.onSuccess) {
            Utils.hideLoadingDialog();
            Utils.handleAPIError(apiResponse1);
            return;
          }
        }
        if (project != null) {
          queryParameters = {
            "resubmitForApproval": project?.requestStatus == 7,
          };
        }

        ApiResponse apiResponse = projectId == null ||
                project?.requestStatus == 8
            ? await projectRepo.createProject(request: RequestBody(body: body))
            : await projectRepo.createProjectPutRequest(
                request: RequestBody(
                    endPoint: "${ApiConstant.project}/$projectId",
                    body: body,
                    queryParameters: queryParameters));

        if (apiResponse.appState == AppState.onSuccess) {
          if (project?.requestStatus == 8) {
            projectId = apiResponse.data;
          } else {
            projectId ??= apiResponse.data;
          }
          pId = projectId!;
          saveAdditionalDocuments(saveAsDraft);
        } else if (apiResponse.appState == AppState.onFailure) {
          Utils.hideLoadingDialog();
          Utils.showGlobalSnackBar(message: apiResponse.message!);
        } else if (apiResponse.appState == AppState.onUnauthorized) {
          Utils.logInAgain();
        }
      }
    }
  }

  Future uploadPicture(
      {bool isLogo = false,
      String path = "",
      int type = 0,
      bool isAppCover = false,
      isWebCover = false}) async {
    String filePath = "";
    filePath = isLogo ? licenseFile!.path! : path;
    final result = await uploadImage(filePath: filePath);
    if (result != null) {
      if (isLogo) {
        licensePhoto = result;
        projectLicenseController.text = licensePhoto;
      } else if (isAppCover) {
        appCover = result;
        projectCoverForAppController.text = appCover;
      } else if (isWebCover) {
        webCover = result;
        projectCoverForWebController.text = webCover;
      } else {
        images.add(ProjectImage(
            mediaType: type, mediaUrl: result.toString().toLowerCase()));
      }
    }
  }

  datePickerDialog(
      {bool startDate = false,
      bool endDate = false,
      bool licenseStart = false,
      bool licenseEnd = false}) async {
    DateTime dateTime = DateTime.now();
    DateTime? picked = await showDatePicker(
      fieldHintText: "dd/mm/yyyy",
      locale: Locale(Utils.isArabic ? "ar" : "en"),
      context: Get.context!,
      initialDate: endDate | licenseEnd
          ? DateTime(dateTime.year, dateTime.month, dateTime.day + 1)
          : dateTime,
      firstDate: startDate
          ? dateTime
          : endDate | licenseEnd
              ? DateTime(dateTime.year, dateTime.month, dateTime.day + 1)
              : DateTime(1950),
      lastDate: startDate | endDate | licenseEnd
          ? DateTime(dateTime.year + 50)
          : dateTime,
    );
    if (picked != null) {
      String date = Utils.dateFormat1.format(picked);
      if (startDate) {
        pickedStartDate = picked;
        startDateController.text = date;
      } else if (endDate) {
        pickedExpiryDate = picked;
        endDateController.text = date;
      } else if (licenseStart) {
        pickedLicenseStart = picked;
        licenseStartDateController.text = date;
      } else if (licenseEnd) {
        pickedLicenseExpirt = picked;
        licenseEndDateController.text = date;
      }
    }
  }

  addFile() async {
    PlatformFile? file = await Utils.pickFile();
    if (file != null) {
      Utils.showLoadingDialog();
      licenseFile = file;
      await uploadPicture(isLogo: true);
      Utils.hideLoadingDialog();
    }
  }

  String getTitle() => project != null ? "editProject" : "createProject";

  String? validateEndDate(txt) {
    if (txt!.trim().isEmpty) {
      return Utils.isArabic
          ? "${"isRequired".tr} ${"endDate".tr}"
          : "${"endDate".tr} ${"isRequired".tr}";
    }
    if (pickedStartDate != null ||
        pickedStartDate != null && pickedExpiryDate != null) {
      if (pickedExpiryDate!.isBefore(pickedStartDate!)) {
        return "endDateMustBeFutureDate".tr;
      }
    }
    return null;
  }

  @override
  void onClose() {
    projectNameInArabicController.dispose();
    projectNameInEnglishController.dispose();
    startDateController.dispose();
    endDateController.dispose();
    noOfBeneficiariesController.dispose();
    projectGoalController.dispose();
    briefDescriptionInArabicController.dispose();
    briefDescriptionInEnglishController.dispose();
    licenseStartDateController.dispose();
    licenseEndDateController.dispose();
    longDescriptionInArabicController.dispose();
    longDescriptionInEnglishController.dispose();
    instagramController.dispose();
    twitterController.dispose();
    facebookController.dispose();
    linkedInController.dispose();
    websiteController.dispose();
    quickAmountController.dispose();
    minimumAmountController.dispose();
    titleInEnglishController.dispose();
    titleInArabicController.dispose();
    static1EnglishController.dispose();
    static1ArabicController.dispose();
    static1DescEnglishController.dispose();
    static1DescArabicController.dispose();
    static2EnglishController.dispose();
    static2ArabicController.dispose();
    static2DescEnglishController.dispose();
    static2DescArabicController.dispose();
    projectLicenseController.dispose();
    projectCoverForAppController.dispose();
    projectCoverForWebController.dispose();

    projectNameInArabicNode.dispose();
    projectNameInEnglishNode.dispose();
    noOfBeneficiariesNode.dispose();
    projectGoalNode.dispose();
    briefDescriptionInArabicNode.dispose();
    briefDescriptionInEnglishNode.dispose();
    longDescriptionInArabicNode.dispose();
    longDescriptionInEnglishNode.dispose();
    quickAmountNode.dispose();
    minimumAmountNode.dispose();
    static1DescEnglishNode.dispose();
    static1DescArabicNode.dispose();
    static2DescEnglishNode.dispose();
    static2DescArabicNode.dispose();
    startDateNode.dispose();
    endDateNode.dispose();
    licenseEndDateNode.dispose();
    licenseStartDateNode.dispose();
    projectLicenseNode.dispose();
    titleInEnglishNode.dispose();
    titleInArabicNode.dispose();
    static1EnglishNode.dispose();
    static2EnglishNode.dispose();
    static1ArabicNode.dispose();
    static2ArabicNode.dispose();
    categoriesNode.dispose();
    beneficiariesOfProjectNode.dispose();

    scrollController.dispose();

    isClicked.close();
    showAdditionalDocuments.close();
    selectedFeaturedForAssociation.close();
    selectedFeaturedForWebAp.close();
    selectedBeneficiary.close();
    amounts.close();
    imagesList.close();
    categoriesList.close();
    beneficiariesList.close();
    selectedCategories.close();
    addQuantities.close();
    urgentProject.close();
    additionalDocuments.close();
    super.onClose();
  }
}
