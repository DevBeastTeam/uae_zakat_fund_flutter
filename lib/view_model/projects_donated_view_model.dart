import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/data/response/app_state.dart';
import 'package:zakat_fund/data/response/network_response.dart';
import 'package:zakat_fund/model/project.dart';
import 'package:zakat_fund/model/request_body.dart';
import 'package:zakat_fund/repository/home_repo.dart';
import 'package:zakat_fund/utils/utils.dart';

class ProjectsDonatedViewModel extends GetxController {
  final donatedSearchController = TextEditingController();
  final homeRepo = HomeRepoImpl();
  RxList<ProjectElements> projects = <ProjectElements>[].obs;
  List<ProjectElements> allLatestDonation = [];
  List<String> donationCategoriesList = [
    "mostDonatedProjects",
    "projectsExpiringSoon"
  ];
  RxInt selectedDonatedCategory = 0.obs;

  RxList<ProjectElements> expiryProjects = <ProjectElements>[].obs;
  List<ProjectElements> allExpiryProjects = [];

  @override
  Future<void> onInit() async {
    if (!Get.arguments) {
      selectedDonatedCategory.value = 1;
    }
    try {
      Utils.showLoadingDialog();
      await Future.wait([
        fetchLatestProjects(),
        fetchLaExpiryProjects(),
      ]);
    } finally {
      Utils.hideLoadingDialog();
    }
    super.onInit();
  }

  Future fetchLatestProjects() async {
    ApiResponse apiResponse =
        await homeRepo.latestDonation(request: RequestBody());
    if (apiResponse.appState == AppState.onSuccess) {
      projects.value = apiResponse.data;
      allLatestDonation = List.from(projects);
    } else if (apiResponse.appState == AppState.onUnauthorized) {
      Utils.logInAgain();
    }
  }

  Future fetchLaExpiryProjects() async {
    ApiResponse apiResponse =
        await homeRepo.expirySoonProjects(request: RequestBody());
    if (apiResponse.appState == AppState.onSuccess) {
      allExpiryProjects = apiResponse.data;
      if (selectedDonatedCategory.value == 1) {
        projects.value = List.from(allExpiryProjects);
      }
    } else if (apiResponse.appState == AppState.onUnauthorized) {
      Utils.logInAgain();
    }
  }

  fetchProjectsBasedOnCat(int index) {
    selectedDonatedCategory.value = index;
    if (index == 0) {
      projects.value = List.from(allLatestDonation);
    } else {
      projects.value = List.from(allExpiryProjects);
    }
  }

  searchProjects() {
    String query = donatedSearchController.text;
    if (query.isEmpty) {
      if (selectedDonatedCategory.value == 0) {
        projects.assignAll(allLatestDonation);
      } else {
        projects.assignAll(allExpiryProjects);
      }
    } else {
      if (selectedDonatedCategory.value == 0) {
        projects.assignAll(
          allLatestDonation.where((service) {
            final title = Utils.isArabic
                ? service.projectNameArabic
                : service.projectName;
            return title.toLowerCase().contains(query);
          }).toList(),
        );
      } else {
        projects.assignAll(
          allExpiryProjects.where((service) {
            final title = Utils.isArabic
                ? service.projectNameArabic
                : service.projectName;
            return title.toLowerCase().contains(query);
          }).toList(),
        );
      }
    }
  }
}
