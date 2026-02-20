import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:zakat_fund/data/response/app_state.dart';
import 'package:zakat_fund/data/response/network_response.dart';
import 'package:zakat_fund/model/approver_groups.dart';
import 'package:zakat_fund/model/request_body.dart';
import 'package:zakat_fund/model/workflows.dart';
import 'package:zakat_fund/repository/approver_groups_repo.dart';
import 'package:zakat_fund/repository/workflow_repo.dart';
import 'package:zakat_fund/translation/translation.dart';
import 'package:zakat_fund/utils/constants/api_constant.dart';
import 'package:zakat_fund/utils/constants/event_constant.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/view_model/workflow_config_view_model.dart';

class AddWorkflowViewModel extends GetxController {

  final nameInEnglishController = TextEditingController();
  final nameInArabicController = TextEditingController();
  final descriptionController = TextEditingController();
  final descriptionNode = FocusNode();
  final formKey = GlobalKey<FormState>();

  final selectedType = Rxn<String>();
  final levels = <NewWorkflowLevel>[].obs;
  final allGroups = <String>[].obs;

  final repo = WorkflowRepoImpl();
  final groupRepo = ApproverGroupsRepoImpl();
  final workflowViewModel = Get.find<WorkflowConfigViewModel>();

  List<KeyboardActionsItem> keyboardActionsItem = [];

  Workflows? workflow;
  List<ApproverGroups> groups = [];

  bool isView = false;

  @override
  onInit() {
    _initializeData();
    super.onInit();
  }

  _initializeData() async {
    var data = Get.arguments;
    workflow = data["workflow"];
    isView = data["isView"]??false;
    if(!isView){
      keyboardActionsItem = [
        KeyboardActionsItem(focusNode: descriptionNode, displayArrows: false)
      ];
    }

    await fetchGroups();
    if (workflow != null) {
      setData();
    } else {
      addNewLevel();
    }
    Utils.logEvent(name: workflow!=null?EventConstant.updateWorkflowConfigurationScreen:EventConstant.addNewWorkflowConfigurationScreen);
  }

  setData() {
    nameInEnglishController.text = workflow!.workflowName;
    nameInArabicController.text = workflow!.workflowNameArabic;
    final Map<String, String>? translations = TranslationService().keys["en"];
    String value = translations!.entries
        .firstWhere((entry) => entry.value == workflow!.requestType,
            orElse: () => MapEntry('Key not found', ''))
        .key;
    selectedType.value = value;
    descriptionController.text = workflow!.workflowDescription;
    levels.value = workflow!.workflowLevels.map((level) {
      ApproverGroups? group =
          groups.firstWhereOrNull((group) => group.id == level.approverGroupId);
      String? name;
      if (group != null) {
        name = Utils.isArabic ? group.groupNameArabic : group.groupName;
      }
      final slaHoursNode = FocusNode();
      final levelDescriptionNode = FocusNode();
      return NewWorkflowLevel(
          levelNameInEnglishController:
              TextEditingController(text: level.levelName),
          levelNameInArabicController:
              TextEditingController(text: level.levelNameArabic),
          levelDescriptionController:
              TextEditingController(text: level.levelDescription),
          slaHoursController:
              TextEditingController(text: level.levelSla.toString()),
          selectedGroup: Rxn<String>(name),
          approverGroupId: group == null ? 0 : group.id,
          slaHoursNode: slaHoursNode,
          subKeyboardActionsItem: [
            KeyboardActionsItem(focusNode: levelDescriptionNode, displayArrows: false),
            KeyboardActionsItem(focusNode: slaHoursNode, displayArrows: false)
          ],
          levelDescriptionNode: levelDescriptionNode);
    }).toList();
  }

  Future fetchGroups() async {
    Utils.showLoadingDialog();
    ApiResponse apiResponse = await groupRepo.approverGroups(request: RequestBody());
    Utils.hideLoadingDialog();
    if (apiResponse.appState == AppState.onSuccess) {
      groups = apiResponse.data;
      allGroups.value = groups.map((group) => Utils.isArabic ? group.groupNameArabic : group.groupName).toSet().toList();
    } else {
      Utils.handleAPIError(apiResponse);
    }
  }

  addNewLevel() {
    final slaHoursNode = FocusNode();
    final levelDescriptionNode = FocusNode();
    levels.add(NewWorkflowLevel(
        levelNameInEnglishController: TextEditingController(),
        levelNameInArabicController: TextEditingController(),
        levelDescriptionController: TextEditingController(),
        slaHoursController: TextEditingController(),
        selectedGroup: Rxn<String>(),
        slaHoursNode: slaHoursNode,
        levelDescriptionNode: levelDescriptionNode,
        subKeyboardActionsItem: [
          KeyboardActionsItem(focusNode: levelDescriptionNode, displayArrows: false),
          KeyboardActionsItem(focusNode: slaHoursNode, displayArrows: false)
        ]));
  }

  addWorkflow() async {
    if (!formKey.currentState!.validate()) return;
    Utils.showLoadingDialog();
    List<WorkflowLevel> workflowLevels = levels
        .map((level) => WorkflowLevel(
              id: level.id,
              workflowId: level.workflowId,
              approverGroupId: level.approverGroupId,
              levelName: level.levelNameInEnglishController.text,
              levelNameArabic: level.levelNameInArabicController.text,
              levelDescription: level.levelDescriptionController.text,
              levelSla: int.parse(level.slaHoursController.text),
            ))
        .toList();

    var body = {
      "workflowName": nameInEnglishController.text,
      "workflowNameArabic": nameInArabicController.text,
      "workflowDescription": descriptionController.text,
      "requestType": TranslationService().keys['en']![selectedType.value]!,
      "workflowLevels": workflowLevels,
      if (workflow != null) "id": workflow?.id
    };
    ApiResponse apiResponse = workflow == null
        ? await repo.addWorkflow(request: RequestBody(body: body))
        : await repo.updateWorkflow(
            request: RequestBody(
                body: body,
                endPoint: "${ApiConstant.updateWorkflow}/${workflow!.id}"));
    Utils.hideLoadingDialog();
    if (apiResponse.appState == AppState.onSuccess) {
      if (workflow != null) {
        workflowViewModel.pageSize = workflowViewModel.workflows.length;
      }
      Get.back(result: true);
    } else {
      Utils.handleAPIError(apiResponse);
    }
  }

  onChangeApproverGroup(String value,NewWorkflowLevel level){
    level.selectedGroup.value = value;
    level.approverGroupId = groups.firstWhere((group) {
      String name = Utils.isArabic?group.groupNameArabic:group.groupName;
      return name==value;
    }).id;
  }

  @override
  void onClose() {
    nameInEnglishController.dispose();
    nameInArabicController.dispose();
    descriptionController.dispose();

    descriptionNode.dispose();

    for (final level in levels) {
      level.levelNameInEnglishController.dispose();
      level.levelNameInArabicController.dispose();
      level.levelDescriptionController.dispose();
      level.slaHoursController.dispose();
      level.slaHoursNode.dispose();
      level.levelDescriptionNode.dispose();
    }

    selectedType.close();
    levels.close();
    allGroups.close();

    super.onClose();
  }

}
