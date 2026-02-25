import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:zakat_fund/data/response/app_state.dart';
import 'package:zakat_fund/data/response/network_response.dart';
import 'package:zakat_fund/model/lookup_data.dart';
import 'package:zakat_fund/model/management_staff.dart';
import 'package:zakat_fund/model/request_body.dart';
import 'package:zakat_fund/model/user.dart';
import 'package:zakat_fund/my_app/my_app.dart';
import 'package:zakat_fund/repository/emp_repo.dart';
import 'package:zakat_fund/repository/generic_repo.dart';
import 'package:zakat_fund/utils/constants/api_constant.dart';
import 'package:zakat_fund/utils/constants/event_constant.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/view_model/account_view_model.dart';
import 'package:zakat_fund/view_model/management_staff_view_model.dart';

class AddEmpViewModel extends GetxController {
  final fNameArabicController = TextEditingController();
  final lNameArabicController = TextEditingController();
  final fNameController = TextEditingController();
  final lNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final emirateIdController = TextEditingController();

  final fNameArabicNode = FocusNode();
  final lNameArabicNode = FocusNode();
  final fNameNode = FocusNode();
  final lNameNode = FocusNode();
  final emailNode = FocusNode();
  final phoneNumberNode = FocusNode();
  final emirateIdNode = FocusNode();


  Rxn selectedNationality = Rxn<String>();
  Rxn<LookupData> selectedJob = Rxn<LookupData>();
  Rxn<LookupData> selectedRole = Rxn<LookupData>();
  var formKey = GlobalKey<FormState>();
  final genericRepo = GenericRepoImpl();
  RxList<String> nationalities = <String>[].obs;
  final staffViewModel = Get.find<ManagementStaffViewModel>();
  final accountViewModel = Get.find<AccountViewModel>();
  final repo = EmpRepoImpl();
  late User user;
  ManagementStaff? emp;
  List<String> roles = [
    "donor",
    "company",
    "association",
  ];

  late List<KeyboardActionsItem> keyboardActionsItem;


  AddEmpViewModel(this.emp);

  @override
  void onInit() {
    _initializeData();
    super.onInit();
  }

  _initializeData() {
    keyboardActionsItem = [
      KeyboardActionsItem(focusNode: phoneNumberNode, displayArrows: false),
      KeyboardActionsItem(focusNode: emirateIdNode, displayArrows: false),
    ];
    user = userBox.getAt(0);
    if (emp != null) setData();
    Utils.logEvent(
        name: emp != null
            ? EventConstant.updateEmployeeScreen
            : EventConstant.addNewEmployeeScreen);
  }

  setData() {
    fNameController.text = emp!.firstName;
    lNameController.text = emp!.lastName;
    fNameArabicController.text = emp!.firstNameArabic;
    lNameArabicController.text = emp!.lastNameArabic;
    emailController.text = emp!.email;
    phoneNumberController.text = emp!.phone;
    LookupData job = staffViewModel.jobList.firstWhere(
        (nationality) => nationality.value == int.parse(emp!.jobDescription));
    selectedJob.value = job;
    LookupData? nationality = accountViewModel.nationalitiesList
        .firstWhereOrNull((nationality) =>
            nationality.value == int.parse(emp!.nationalityId.toString()));
    if (nationality != null) {
      selectedNationality.value = Utils.isArabic
          ? nationality.nameAr ?? nationality.name
          : nationality.name;
    }
    selectedRole.value =
        staffViewModel.getRole(user.isAdmin ? emp!.roleId : emp!.customRoleId);
    emirateIdController.text = emp!.emirateId;
  }

  int getRole() => selectedRole.value!.value;

  addUpdateEmployee(ManagementStaff? emp) async {
    if (!validateEmployeeForm()) return;
    Utils.showLoadingDialog();
    int nationalityId = 0;
    LookupData? data =
        accountViewModel.nationalitiesList.firstWhereOrNull((emirate) {
      String state =
          Utils.isArabic ? emirate.nameAr ?? emirate.name : emirate.name;
      return state == selectedNationality.value;
    });
    if (data != null) {
      nationalityId = data.value;
    }
    int jobDescription = selectedJob.value!.value;
    var body = {
      if (emp != null) ...{
        "id": emp.id,
         "emailConfirmed": emp.emailConfirmed,
        "phoneNumberConfirmed": emp.phoneNumberConfirmed,
      },
      "accountID": staffViewModel.user.accountId,
      "firstName": fNameController.text,
      "lastName": lNameController.text,
      "firstNameArabic": fNameArabicController.text,
      "lastNameArabic": lNameArabicController.text,
      "phone": phoneNumberController.text,
      "email": emailController.text,
      "jobDescription": jobDescription,
      "nationalityId": nationalityId,
      "emirateID": emirateIdController.text,
      "roleId": getRole(),
      "customRoleId": getRole(),
    };

    String endPoint = "";
    if (user.isAdmin) {
      if (emp != null) {
        endPoint = "${ApiConstant.updateSahemUser}/${emp.id}";
      } else {
        endPoint = ApiConstant.addSahemUser;
      }
    } else {
      if (emp != null) {
        endPoint = "${ApiConstant.updateEmployee}/${emp.id}";
      } else {
        endPoint = ApiConstant.addEmployee;
      }
    }

    ApiResponse apiResponse = emp != null
        ? await repo.updateEmployee(
            request: RequestBody(body: body, endPoint: endPoint))
        : await repo.addEmployee(
            request: RequestBody(body: body, endPoint: endPoint));
    Utils.hideLoadingDialog();
    if (apiResponse.appState == AppState.onSuccess) {
      Utils.showGlobalSnackBar(
          message:
              emp != null ? "updatedSuccessfully".tr : "addedSuccessfully".tr);
      Get.back(result: true);
    } else {
      Utils.handleAPIError(apiResponse);
    }
  }

  bool validateEmployeeForm() {
    if (!formKey.currentState!.validate()) {
      if (Utils.isEmpty(fNameController.text)) {
        Utils.scrollToTextField(fNameNode);
        return false;
      }
      if (Utils.isEmpty(lNameController.text)) {
        Utils.scrollToTextField(lNameNode);
        return false;
      }
      if (Utils.isEmpty(fNameArabicController.text)) {
        Utils.scrollToTextField(fNameArabicNode);
        return false;
      }
      if (Utils.isEmpty(lNameArabicController.text)) {
        Utils.scrollToTextField(lNameArabicNode);
        return false;
      }

      if (Utils.isEmpty(emailController.text)) {
        Utils.scrollToTextField(emailNode);
        return false;
      }
      if (Utils.isEmpty(phoneNumberController.text)) {
        Utils.scrollToTextField(phoneNumberNode);
        return false;
      }
    }
    if (selectedJob.value == null) {
      Utils.showGlobalSnackBar(message: "${"jobTitle".tr} ${"isRequired".tr}");
      return false;
    }
    if (selectedRole.value == null || selectedRole.value == "") {
      Utils.showGlobalSnackBar(message: "${"role".tr} ${"isRequired".tr}");
      return false;
    }
    if (selectedNationality.value == null) {
      Utils.showGlobalSnackBar(message: "${"nationality".tr} ${"isRequired".tr}");
      return false;
    }
    return true;
  }

  @override
  void onClose() {
    fNameArabicController.dispose();
    lNameArabicController.dispose();
    fNameController.dispose();
    lNameController.dispose();
    emailController.dispose();
    phoneNumberController.dispose();
    emirateIdController.dispose();

    fNameArabicNode.dispose();
    lNameArabicNode.dispose();
    fNameNode.dispose();
    lNameNode.dispose();
    emailNode.dispose();
    phoneNumberNode.dispose();
    emirateIdNode.dispose();

    selectedNationality.close();
    selectedJob.close();
    selectedRole.close();

    super.onClose();
  }

}
