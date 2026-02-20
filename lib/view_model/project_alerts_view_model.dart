import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/data/response/app_state.dart';
import 'package:zakat_fund/data/response/network_response.dart';
import 'package:zakat_fund/model/lookup_data.dart';
import 'package:zakat_fund/model/project_alerts.dart';
import 'package:zakat_fund/model/request_body.dart';
import 'package:zakat_fund/repository/reminders_repo.dart';
import 'package:zakat_fund/utils/constants/event_constant.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/view_model/home_view_model.dart';

class ProjectAlertsViewModel extends GetxController {
  final formKey = GlobalKey<FormState>();

  final notificationMethods = <String>[
    "email",
    "sms",
    "mobileAppNotifications",
  ].obs;

  final selectedMethods = <String>[].obs;
  final selectedCategories = <LookupData>[].obs;
  final allCategoriesList = <LookupData>[].obs;
  final notificationFrequencies = <String?>[].obs;

  final isMethodClicked = false.obs;
  final isCategoryClicked = false.obs;
  final isAgree = false.obs;

  final homeViewModel = Get.find<HomeViewModel>();
  final repo = RemindersRepoImpl();

  @override
  void onInit() {
    _initializeData();
    super.onInit();
  }

  _initializeData() {
    Utils.logEvent(name: EventConstant.addNewProjectAlertsScreen);
    allCategoriesList.value = List.from(homeViewModel.categoriesList
        .where((cat) => cat.name != "all".tr)
        .toList());
    fetchAlerts();
  }

  fetchAlerts() async {
    Utils.showLoadingDialog();
    ApiResponse apiResponse = await repo.projectAlerts(request: RequestBody());
    Utils.hideLoadingDialog();
    if (apiResponse.appState == AppState.onSuccess) {
      ProjectAlerts alerts = apiResponse.data;
      if (alerts.notificationMethods != null) {
        List<int> indices =
            List<int>.from(jsonDecode(alerts.notificationMethods!));
        for (int val in indices) {
          String method = Utils.notificationMethodString(val);
          selectedMethods.add(method);
          notificationMethods.remove(method);
        }
        for (int i = 0; i < alerts.projectAlertsDetails.length; i++) {
          LookupData category = allCategoriesList.firstWhere((cat) =>
              cat.value == alerts.projectAlertsDetails[i].projectCategoryId);
          String frequency = Utils.notificationFrequencyString(
              alerts.projectAlertsDetails[i].projectAlertFrequency);
          notificationFrequencies.add(frequency);
          selectedCategories.add(category);
          allCategoriesList.remove(category);
        }
      }
    } else {
      Utils.handleAPIError(apiResponse);
    }
  }

  removeNotificationMethod(int index) {
    String method = selectedMethods.removeAt(index);
    notificationMethods.add(method);
  }

  addNotificationMethod(int index) {
    String method = notificationMethods.removeAt(index);
    selectedMethods.add(method);
  }

  removeCategory(int index) {
    LookupData category = selectedCategories.removeAt(index);
    allCategoriesList.add(category);
    notificationFrequencies.removeAt(index);
  }

  addCategory(int index) {
    selectedCategories.add(allCategoriesList.removeAt(index));
    notificationFrequencies.add(null);
  }

  saveReminder() async {
    isCategoryClicked.value = true;
    isMethodClicked.value = true;
    if (!formKey.currentState!.validate() ||
        selectedMethods.isEmpty ||
        selectedCategories.isEmpty) {
      return;
    }
    if (!isAgree.value) {
      Utils.showGlobalSnackBar(message: "agreeReceiveNotification".tr);
      return;
    }
    Utils.showLoadingDialog();

    final methodIndexes = selectedMethods
        .map((method) => Utils.notificationMethodIntoInt(method))
        .toList();

    final details = List.generate(selectedCategories.length, (i) {
      return {
        "projectCategoryId": selectedCategories[i].value,
        "projectAlertFrequency":
        Utils.notificationFrequencyIntoInt(notificationFrequencies[i]!),
      };
    });
    final body = {
      "notificationMethods": jsonEncode(methodIndexes),
      "projectAlertsDetails": details,
    };

    ApiResponse apiResponse =
        await repo.addUpdateProjectAlerts(request: RequestBody(body: body));
    Utils.hideLoadingDialog();
    if (apiResponse.appState == AppState.onSuccess) {
      Utils.showGlobalSnackBar(message: "alertAddedSuccessfully".tr);
      Get.back();
    } else {
      Utils.handleAPIError(apiResponse);
    }
  }

  @override
  void onClose() {
    selectedMethods.close();
    selectedCategories.close();
    allCategoriesList.close();
    notificationMethods.close();
    notificationFrequencies.close();
    isMethodClicked.close();
    isCategoryClicked.close();
    isAgree.close();
    super.onClose();
  }

}
