import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/data/response/app_state.dart';
import 'package:zakat_fund/data/response/network_response.dart';
import 'package:zakat_fund/model/about_us_config.dart';
import 'package:zakat_fund/model/dashboard_data.dart';
import 'package:zakat_fund/model/request_body.dart';
import 'package:zakat_fund/repository/generic_repo.dart';
import 'package:zakat_fund/utils/constants/api_constant.dart';
import 'package:zakat_fund/utils/constants/event_constant.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/view_model/module_permission_view_model.dart';

class CMSAboutUsViewModel extends ModulePermissionsViewModel {
  final scrollController = ScrollController();
  final GenericRepo genericRepo = GenericRepoImpl();

  Rxn<AboutUsConfig> aboutUsConfig = Rxn<AboutUsConfig>();
  RxList<DashboardData> configData = <DashboardData>[].obs;
  RxBool isEditMode = false.obs;
  RxMap<String, TextEditingController> editControllers =
      <String, TextEditingController>{}.obs;

  @override
  onInit() {
    _initializeData();
    super.onInit();
  }

  _initializeData() async {
    Utils.logEvent(name: EventConstant.cmsAboutUsScreen);
    if (canView) {
      Utils.showLoadingDialog();
      await fetchAboutUsConfig();
      Utils.hideLoadingDialog();
    }
  }

  Future fetchAboutUsConfig() async {
    ApiResponse apiResponse = await genericRepo.getSystemConfiguration(
        request: RequestBody(endPoint: ApiConstant.aboutSahem));

    if (apiResponse.appState == AppState.onSuccess) {
      aboutUsConfig.value = AboutUsConfig.fromJson(apiResponse.data);
      _buildConfigDataList();
    } else {
      Utils.handleAPIError(apiResponse);
    }
  }

  void _buildConfigDataList() {
    configData.clear();
    editControllers.clear();

    if (aboutUsConfig.value == null) return;

    final config = aboutUsConfig.value!;

    // About Sahem
    _initializeController("aboutSahemEn", config.aboutSahemEn ?? "");
    _initializeController("aboutSahemAr", config.aboutSahemAr ?? "");

    // Mission
    _initializeController("missionSubjectEn", config.missionSubjectEn ?? "");
    _initializeController("missionSubjectAr", config.missionSubjectAr ?? "");
    _initializeController("missionDetailsEn", config.missionDetailsEn ?? "");
    _initializeController("missionDetailsAr", config.missionDetailsAr ?? "");

    // Vision
    _initializeController("visionDetailsEn", config.visionDetailsEn ?? "");
    _initializeController("visionDetailsAr", config.visionDetailsAr ?? "");

    // Sections
    for (int i = 0; i < config.sections.length; i++) {
      final section = config.sections[i];
      _initializeController(
          "section_${i}_headingEn", section.sectionHeadingEn ?? "");
      _initializeController(
          "section_${i}_headingAr", section.sectionHeadingAr ?? "");
      _initializeController(
          "section_${i}_detailsEn", section.sectionDetailsEn ?? "");
      _initializeController(
          "section_${i}_detailsAr", section.sectionDetailsAr ?? "");
      _initializeController("section_${i}_image", section.sectionImage ?? "");
    }

    // Corporate Values
    for (int i = 0; i < config.corporateValuesSections.length; i++) {
      final section = config.corporateValuesSections[i];
      _initializeController(
          "corporateValue_${i}_headingEn", section.headingEn ?? "");
      _initializeController(
          "corporateValue_${i}_headingAr", section.headingAr ?? "");
      _initializeController(
          "corporateValue_${i}_detailsEn", section.detailsEn ?? "");
      _initializeController(
          "corporateValue_${i}_detailsAr", section.detailsAr ?? "");
    }

    // Strategic Goals
    for (int i = 0; i < config.strategicGoalsSections.length; i++) {
      final section = config.strategicGoalsSections[i];
      _initializeController(
          "strategicGoal_${i}_detailsEn", section.detailsEn ?? "");
      _initializeController(
          "strategicGoal_${i}_detailsAr", section.detailsAr ?? "");
    }

    // Team Members
    for (int i = 0; i < config.teamMembers.length; i++) {
      final member = config.teamMembers[i];
      _initializeController("teamMember_${i}_nameEn", member.nameEn ?? "");
      _initializeController("teamMember_${i}_nameAr", member.nameAr ?? "");
      _initializeController("teamMember_${i}_jobEn", member.jobTitleEn ?? "");
      _initializeController("teamMember_${i}_jobAr", member.jobTitleAr ?? "");
      _initializeController("teamMember_${i}_image", member.image ?? "");
    }

    configData.refresh();
  }

  void pickImage(String key) async {
    // Implement image picking logic here
    // For now, it's a placeholder as requested to "just add the fields"
    Utils.showFrontEndSnackBar(message: "Image picking for $key");
  }

  void _initializeController(String key, String value) {
    editControllers[key] = TextEditingController(text: value);
  }

  exportAboutUs() {
    Utils.downloadFile(
        url: ApiConstant.exportAboutUs,
        isExport: true,
        filename: "AboutUs.csv");
  }

  void editAboutUs() {
    isEditMode.value = true;
  }

  void cancelEdit() {
    isEditMode.value = false;
    _buildConfigDataList();
  }

  Future<void> saveAboutUs() async {
    Utils.showLoadingDialog();
    try {
      // Prepare the request body with updated values
      Map<String, dynamic> updateData = {};

      editControllers.forEach((key, controller) {
        updateData[key] = controller.text;
      });

      ApiResponse apiResponse = await genericRepo.updateSystemConfiguration(
          request:
              RequestBody(endPoint: ApiConstant.aboutSahem, body: updateData));

      Utils.hideLoadingDialog();

      if (apiResponse.appState == AppState.onSuccess) {
        isEditMode.value = false;
        await fetchAboutUsConfig();
        Utils.showFrontEndSnackBar(message: "Updated successfully");
      } else {
        Utils.handleAPIError(apiResponse);
      }
    } catch (e) {
      Utils.hideLoadingDialog();
      Utils.showFrontEndSnackBar(message: e.toString());
    }
  }

  @override
  void onClose() {
    scrollController.dispose();
    editControllers.forEach((_, controller) {
      controller.dispose();
    });
    aboutUsConfig.close();
    configData.close();
    isEditMode.close();
    editControllers.close();
    super.onClose();
  }
}
