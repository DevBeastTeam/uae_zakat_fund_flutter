import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/model/additional_documents.dart';
import 'package:zakat_fund/model/lookup_data.dart';
import 'package:zakat_fund/model/project.dart';
import 'package:zakat_fund/repository/project_repo.dart';
import 'package:zakat_fund/utils/constants/api_constant.dart';
import 'package:zakat_fund/utils/mixins/generic_mixin.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/view_model/module_permission_view_model.dart';

class ProjectPreviewViewModel extends ModulePermissionsViewModel with GenericMixin{
  final nameInEnglish = TextEditingController();
  final nameInArabic = TextEditingController();
  final startDate = TextEditingController();
  final endDate = TextEditingController();
  final beneficiariesOfProject = TextEditingController();
  final noOfBeneficiaries = TextEditingController();
  final projectGoal = TextEditingController();
  final shortDescriptionInEnglish = TextEditingController();
  final shortDescriptionInArabic = TextEditingController();
  final startDateOfPermit = TextEditingController();
  final endDateOfPermit = TextEditingController();
  final longDescriptionInEnglish = TextEditingController();
  final longDescriptionInArabic = TextEditingController();
  final instagram = TextEditingController();
  final twitter = TextEditingController();
  final facebook = TextEditingController();
  final linkedIn = TextEditingController();
  final webLink = TextEditingController();
  final addQuantities = TextEditingController();
  final urgentProject = TextEditingController();
  final minimumAmountController = TextEditingController();

  final featuredForAssociation = TextEditingController();
  final featuredForAppWeb = TextEditingController();
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

  RxList<AdditionalDocuments> additionalDocuments = <AdditionalDocuments>[].obs;

  ProjectElements? project;

  RxList<LookupData> categoriesList = <LookupData>[].obs;
  RxList<LookupData> selectedCategories = <LookupData>[].obs;
  List<LookupData> beneficiariesList = [];

  List<String> beneficiaries = [];
  RxList<String> amounts = <String>[].obs;

  RxBool showFeatured = false.obs;

  RxList<ProjectImage> projectImages = <ProjectImage>[].obs;

  final projectRepo = ProjectRepoImpl();

  @override
  onInit() {
    _initializeData();
    super.onInit();
  }

  _initializeData(){
    Future.microtask(() async {
      try{
        Utils.showLoadingDialog();
        await fetchBeneficiaryTypes();
        await Future.wait([fetchCategoriesTypes(),fetchAdditionalDocuments()]);
      }finally{
        Utils.hideLoadingDialog();
      }
    });
  }

  fetchProjectDetails() async {
    final result = await getProjectDetails(request!.entityId);
    if(result!=null){
      project = result;
      isAdmin.value = (request?.status == 1 && user.isAdmin);
      nameInEnglish.text = project!.projectName;
      nameInArabic.text = project!.projectNameArabic;
      startDate.text = Utils.dateFormat1.format(project!.startDate!);
      endDate.text = Utils.dateFormat1.format(project!.endDate!);
      if(project!.projectBeneficiary!=null){
        LookupData? type = beneficiariesList.firstWhereOrNull((type)=>type.value==project?.projectBeneficiary);
        if(type!=null){
          beneficiariesOfProject.text = Utils.isArabic?type.nameAr:type.name;
        }
      }
      noOfBeneficiaries.text = project!.beneficiaryCount.toString();
      projectGoal.text = project!.projectAmountObjective.toString();
      shortDescriptionInEnglish.text = project!.projectDescriptionShort;
      shortDescriptionInArabic.text = project!.projectDescriptionShortArabic;
      startDateOfPermit.text = Utils.dateFormat1.format(project!.permitStartDate!);
      endDateOfPermit.text = Utils.dateFormat1.format(project!.permitEndDate!);
      longDescriptionInEnglish.text = project!.projectDescriptionLong;
      longDescriptionInArabic.text = project!.projectDescriptionLongArabic;
      instagram.text = project!.socialMediaLinksInstagram;
      twitter.text = project!.socialMediaLinksTwitter;
      facebook.text = project!.socialMediaLinksFacebook;
      linkedIn.text = project!.socialMediaLinksLinkedIn;
      webLink.text = project!.projectExternalWeblinks;
      addQuantities.text = project!.isAddQuantity ? "yes".tr : "no".tr;
      urgentProject.text = project!.isUrgentProject! ? "yes".tr : "no".tr;
      minimumAmountController.text = project!.minimumAmount.toString();
      if(project?.quickAmount!=null){
        amounts.value = project!.quickAmount.split(',');
      }

      projectImages.value = project!.projectImages;
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
        if (project!.isFeaturedProjectForAssociation!) {
          featuredForAssociation.text = "yes".tr;
          showFeatured.value = true;
        } else {
          featuredForAssociation.text = "no".tr;
        }
      }
      if (project!.isFeaturedProjectForWebsiteAndApp != null) {
        if (project!.isFeaturedProjectForWebsiteAndApp!) {
          featuredForAppWeb.text = "yes".tr;
          showFeatured.value = true;
        } else {
          featuredForAppWeb.text = "no".tr;
        }
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
    }
  }

  Future fetchCategoriesTypes() async {
    final result = await getLookUpData(endPoint: ApiConstant.projectCategories);
    categoriesList.value = result;
    fetchProjectDetails();
  }

  Future fetchBeneficiaryTypes() async {
    final result = await getLookUpData(endPoint: ApiConstant.projectBeneficiaryTypes);
    beneficiariesList = result;
  }

  Future fetchAdditionalDocuments() async {
    final result = await getAdditionalDocuments(endPoint: "${ApiConstant.additionalDocuments}/3/${request?.entityId}/3");
    additionalDocuments.value = result;
  }

  @override
  void onClose() {
    nameInEnglish.dispose();
    nameInArabic.dispose();
    startDate.dispose();
    endDate.dispose();
    beneficiariesOfProject.dispose();
    noOfBeneficiaries.dispose();
    projectGoal.dispose();
    shortDescriptionInEnglish.dispose();
    shortDescriptionInArabic.dispose();
    startDateOfPermit.dispose();
    endDateOfPermit.dispose();
    longDescriptionInEnglish.dispose();
    longDescriptionInArabic.dispose();
    instagram.dispose();
    twitter.dispose();
    facebook.dispose();
    linkedIn.dispose();
    webLink.dispose();
    addQuantities.dispose();
    urgentProject.dispose();
    minimumAmountController.dispose();
    featuredForAssociation.dispose();
    featuredForAppWeb.dispose();
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

    additionalDocuments.close();
    categoriesList.close();
    selectedCategories.close();
    amounts.close();
    showFeatured.close();
    projectImages.close();
    super.onClose();
  }

}
