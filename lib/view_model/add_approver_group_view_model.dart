import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:zakat_fund/data/response/app_state.dart';
import 'package:zakat_fund/data/response/network_response.dart';
import 'package:zakat_fund/model/approver_group_employee.dart';
import 'package:zakat_fund/model/approver_groups.dart';
import 'package:zakat_fund/model/request_body.dart';
import 'package:zakat_fund/repository/approver_groups_repo.dart';
import 'package:zakat_fund/utils/constants/api_constant.dart';
import 'package:zakat_fund/utils/constants/event_constant.dart';
import 'package:zakat_fund/utils/utils.dart';

class AddApproverGroupViewModel extends GetxController {

  final ScrollController scrollController = ScrollController();
  final nameInEnglishController = TextEditingController();
  final nameInArabicController = TextEditingController();
  final descriptionController = TextEditingController();

  var formKey = GlobalKey<FormState>();

  final descNode = FocusNode();

  final repo = ApproverGroupsRepoImpl();

  RxList<ApproverGroupEmployee> employees = <ApproverGroupEmployee>[].obs;

  ApproverGroups? group;

  late List<KeyboardActionsItem> keyboardActionsItem;

  @override
  onInit()  {
    _initializeData();
    super.onInit();
  }

  _initializeData() async {
    keyboardActionsItem = [
      KeyboardActionsItem(focusNode: descNode, displayArrows: false)
    ];
    group = Get.arguments;
    Utils.showLoadingDialog();
    await Future.wait([fetchEmployees(), if (group != null) fetchGroupDetails()]);
    Utils.hideLoadingDialog();
    if (group != null) {
      setData();
    }
    Utils.logEvent(name: group!=null?EventConstant.updateApproverGroupScreen:EventConstant.addNewApproverGroupScreen);
  }

  setData() {
    nameInEnglishController.text = group!.groupName;
    nameInArabicController.text = group!.groupNameArabic;
    descriptionController.text = group!.groupDescription;
    if (group!.userId.isNotEmpty) {
      for (var employee in employees) {
        bool isSelected = group!.userId.any((id) => id == employee.id);
        employee.selected = isSelected;
      }
      employees.sort(
          (a, b) => b.selected.toString().compareTo(a.selected.toString()));
      employees.refresh();
    }
  }

  Future fetchEmployees() async {
    ApiResponse apiResponse =
        await repo.approverGroupEmployees(request: RequestBody());
    if (apiResponse.appState == AppState.onSuccess) {
      employees.value = apiResponse.data;
    } else {
      Utils.handleAPIError(apiResponse);
    }
  }

  Future fetchGroupDetails() async {
    ApiResponse apiResponse = await repo.approverGroupDetails(
        request: RequestBody(
            endPoint: "${ApiConstant.approverGroupDetails}${group?.id}"));
    if (apiResponse.appState == AppState.onSuccess) {
      group = apiResponse.data;
    } else {
      Utils.handleAPIError(apiResponse);
    }
  }

  void toggleSelection(ApproverGroupEmployee employee) {
    employee.selected = !employee.selected;
    employees.refresh();
  }

  addGroup() async {
    if (!formKey.currentState!.validate()) {
      return;
    }
    Utils.showLoadingDialog();
    List<int> userId = employees
        .where((employee) => employee.selected)
        .map((e) => e.id)
        .toList();
    var body = {
      if (group != null) "id": group?.id,
      "groupName": nameInEnglishController.text,
      "groupNameArabic": nameInArabicController.text,
      "groupDescription": descriptionController.text,
      "userId": userId,
    };
    ApiResponse apiResponse = group != null
        ? await repo.updateApproverGroup(
            request: RequestBody(
                body: body,
                endPoint: "${ApiConstant.updateApproverGroup}${group?.id}"))
        : await repo.addApproverGroup(request: RequestBody(body: body));
    Utils.hideLoadingDialog();
    if (apiResponse.appState == AppState.onSuccess) {
      Utils.showGlobalSnackBar(message: group != null?"groupUpdatedSuccessfully".tr:"addedSuccessfully".tr);
      Get.back(result: true);
    } else {
      Utils.handleAPIError(apiResponse);
    }
  }

  String getTitle()=>group != null ? "editGroup" : "addNewGroup";

  @override
  void onClose() {
    scrollController.dispose();
    nameInEnglishController.dispose();
    nameInArabicController.dispose();
    descriptionController.dispose();
    descNode.dispose();

    employees.close();

    super.onClose();
  }

}
