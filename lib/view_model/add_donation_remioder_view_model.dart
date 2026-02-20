import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:zakat_fund/data/response/app_state.dart';
import 'package:zakat_fund/data/response/network_response.dart';
import 'package:zakat_fund/model/donation_reminders.dart';
import 'package:zakat_fund/model/project.dart';
import 'package:zakat_fund/model/request_body.dart';
import 'package:zakat_fund/repository/home_repo.dart';
import 'package:zakat_fund/repository/reminders_repo.dart';
import 'package:zakat_fund/utils/constants/api_constant.dart';
import 'package:zakat_fund/utils/constants/event_constant.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/view_model/home_view_model.dart';

class AddDonationReminderViewModel extends GetxController {
  final DateTime dateTime = DateTime.now();
  final formKey = GlobalKey<FormState>();
  final reminderNameController = TextEditingController();
  final donationAmountController = TextEditingController();
  final reminderDateController = TextEditingController();

  final RxnString selectedEnableReminder = RxnString();
  final RxnString selectedProject = RxnString();
  final RxString selectedFrequency = "monthly".obs;
  final RxString amount = "".obs;
  final RxString date = "".obs;
  final RxnString selectedMonth = RxnString();
  final RxList<String> selectedMethods = <String>[].obs;
  final RxList<String> notificationMethods =
      ["email", "sms", "mobileAppNotifications"].obs;

  final RxBool isClicked = false.obs;
  final RxBool isAgree = false.obs;

  List<ProjectElements> allProjects = [];
  final RxList<String> projects = <String>[].obs;
  List<String> months = [];

  final FocusNode amountNode = FocusNode();
  late final List<KeyboardActionsItem> keyboardActionsItem;
  final repo = RemindersRepoImpl();
  final homeRepo = HomeRepoImpl();
  final homeViewModel = Get.find<HomeViewModel>();

  DonationReminder? donationReminder;
  int? projectId;

  @override
  Future<void> onInit() async {
    Utils.logEvent(name: EventConstant.addNewDonationReminderScreen);
    var data = Get.arguments;
    if (data != null) {
      projectId = data["projectId"];
      donationReminder = data["donationReminder"];
    }

    keyboardActionsItem = [
      KeyboardActionsItem(focusNode: amountNode, displayArrows: false)
    ];

    await fetchProjects();
    if (donationReminder != null) setData();
    super.onInit();
  }

  Future fetchProjects() async {
    Utils.showLoadingDialog();
    ApiResponse apiResponse =
        await homeRepo.fetchProjects(request: RequestBody());
    Utils.hideLoadingDialog();
    if (apiResponse.appState == AppState.onSuccess) {
      allProjects = apiResponse.data;
      projects.value = allProjects
          .map((project) =>
              Utils.isArabic ? project.projectNameArabic : project.projectName)
          .toSet()
          .toList();
      months = List.generate(
          12, (index) => "${"every".tr} ${index + 1} ${"months".tr}");
      if (projectId != null) {
        ProjectElements project =
            allProjects.firstWhere((project) => project.projectId == projectId);
        selectedProject.value =
            Utils.isArabic ? project.projectNameArabic : project.projectName;
      }
    }
  }

  setData() {
    selectedEnableReminder.value =
        donationReminder!.enableDonationReminder ? "yes" : "no";
    reminderNameController.text = donationReminder!.reminderName;
    selectedProject.value = Utils.isArabic
        ? donationReminder!.projectNameAr
        : donationReminder!.projectNameEn;
    donationAmountController.text =
        donationReminder!.donationAmount.toInt().toString();
    amount.value = donationAmountController.text;
    selectedFrequency.value =
        donationReminder!.reminderFrequency == 1 ? "monthly" : "customDate";
    if (donationReminder!.reminderDate != null) {
      reminderDateController.text =
          Utils.dateFormat1.format(donationReminder!.reminderDate!);
      date.value = reminderDateController.text;
    }
    if (donationReminder!.reminderDateMonthly != 0) {
      selectedMonth.value = months[donationReminder!.reminderDateMonthly - 1];
    }
    isAgree.value = donationReminder!.isAnnualReminder;
    List<int> indices =
        List<int>.from(jsonDecode(donationReminder!.notificationMethods));
    for (int val in indices) {
      String method = Utils.notificationMethodString(val);
      selectedMethods.add(method);
      notificationMethods.remove(method);
    }
  }

  removeCategory(int index) {
    notificationMethods.add(selectedMethods[index]);
    selectedMethods.removeAt(index);
    selectedMethods.refresh();
    notificationMethods.refresh();
  }

  addCategory(int index) {
    selectedMethods.add(notificationMethods[index]);
    notificationMethods.removeAt(index);
    selectedMethods.refresh();
    notificationMethods.refresh();
  }

  saveReminder() async {
    isClicked.value = true;
    if (!formKey.currentState!.validate() || selectedMethods.isEmpty) {
      return;
    }
    Utils.showLoadingDialog();
    int? projectId = allProjects.firstWhere((project) {
      String name =
          Utils.isArabic ? project.projectNameArabic : project.projectName;
      return name == selectedProject.value;
    }).projectId;
    String? reminderDate;
    if (reminderDateController.text.isNotEmpty) {
      DateTime parsedDate =
          Utils.dateFormat1.parseUtc(reminderDateController.text);
      reminderDate = parsedDate.toIso8601String();
    }
    List<int> notificationMethods = [];
    for (String data in selectedMethods) {
      int val = Utils.notificationMethodIntoInt(data);
      notificationMethods.add(val);
    }

    var body = {
      if (donationReminder != null) "id": donationReminder?.id,
      "enableDonationReminder": selectedEnableReminder.value == "yes",
      "reminderName": reminderNameController.text,
      "projectId": projectId ?? 0,
      "donationAmount": int.parse(donationAmountController.text),
      "reminderFrequency": selectedFrequency.value == "monthly" ? 1 : 2,
      "reminderDateMonthly": selectedMonth.value != null
          ? months.indexOf(selectedMonth.value!) + 1
          : null,
      "reminderDate": reminderDate,
      "isAnnualReminder": isAgree.value,
      "notificationMethods": jsonEncode(notificationMethods)
    };
    ApiResponse apiResponse = donationReminder != null
        ? await repo.updateDonationReminder(
            request: RequestBody(
                body: body,
                endPoint:
                    "${ApiConstant.updateDonationReminder}${donationReminder?.id}"))
        : await repo.addDonationReminder(request: RequestBody(body: body));
    Utils.hideLoadingDialog();
    if (apiResponse.appState == AppState.onSuccess) {
      Utils.showGlobalSnackBar(message: apiResponse.data);
      Get.back(result: true);
    } else {
      Utils.handleAPIError(apiResponse);
    }
  }

  datePickerDialog() async {
    DateTime? picked = await Utils.datePickerDialog(
      initialDate: DateTime(dateTime.year, dateTime.month, dateTime.day + 1),
      lastDate: DateTime(dateTime.year + 50),
      firstDate: DateTime(dateTime.year, dateTime.month, dateTime.day + 1),
    );
    reminderDateController.text = Utils.dateFormat1.format(picked!);
    date.value = reminderDateController.text;
  }

  onChangeEnableReminder(String value) => selectedEnableReminder.value = value;

  onChangeProject(String value) => selectedProject.value = value;

  onChangeDonationAmount(String value) => amount.value = value;

  onChangeReminderFrequency(String value) {
    selectedFrequency.value = value;
    if (value == "monthly") {
      reminderDateController.clear();
      date.value = "";
      isAgree.value = false;
    } else {
      selectedMonth.value = null;
    }
  }

  onChangeMonth(String value) => selectedMonth.value = value;

  onChangeAgree(bool value) => isAgree.value = value;

  @override
  void onClose() {
    reminderNameController.dispose();
    donationAmountController.dispose();
    reminderDateController.dispose();
    amountNode.dispose();

    selectedEnableReminder.close();
    selectedProject.close();
    selectedFrequency.close();
    amount.close();
    date.close();
    selectedMonth.close();
    selectedMethods.close();
    notificationMethods.close();
    isClicked.close();
    isAgree.close();
    projects.close();

    super.onClose();
  }
}
