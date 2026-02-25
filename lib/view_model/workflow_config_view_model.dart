import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/data/response/app_state.dart';
import 'package:zakat_fund/data/response/network_response.dart';
import 'package:zakat_fund/model/base_api_model.dart';
import 'package:zakat_fund/model/request_body.dart';
import 'package:zakat_fund/model/stats_data.dart';
import 'package:zakat_fund/model/workflows.dart';
import 'package:zakat_fund/repository/workflow_repo.dart';
import 'package:zakat_fund/translation/translation.dart';
import 'package:zakat_fund/utils/constants/api_constant.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_constant.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/utils/constants/event_constant.dart';
import 'package:zakat_fund/utils/routes/app_routes.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/view_model/module_permission_view_model.dart';
import 'package:zakat_fund/widgets/bottom_sheet_buttons.dart';
import 'package:zakat_fund/widgets/bottom_sheet_header.dart';
import 'package:zakat_fund/widgets/label_drop_down.dart';

class WorkflowConfigViewModel extends ModulePermissionsViewModel {

  final repo = WorkflowRepoImpl();

  ScrollController scrollController = ScrollController();
  final searchController = TextEditingController();

  RxList<StatsData> stats = [
    StatsData(
        title: "total",
        value: "0",
        titleStyle: AppTextStyle.btnBackground12spTextStyle1,
        valueStyle: AppTextStyle.btnBackground16spTextStyle,
        backgroundColor: AppColors.btnBackgroundColor),
    StatsData(
        title: "active",
        value: "0",
        titleStyle: AppTextStyle.darkGreenColor12spTextStyle1,
        valueStyle: AppTextStyle.darkGreen16spTextStyle1,
        backgroundColor: AppColors.darkGreenColor),
    StatsData(
        title: "inactive",
        value: "0",
        titleStyle: AppTextStyle.highBack12spTextStyle,
        valueStyle: AppTextStyle.highBack16spTextStyle,
        backgroundColor: AppColors.highBackColor)
  ].obs;


  RxList<Workflows> workflows = <Workflows>[].obs;

  int pageSize = 10;
  int currentPage = 1;
  int totalRecords = 0;

  Rxn selectedType = Rxn<String>();
  Rxn selectedStatus = Rxn<String>();

  @override
  void onInit() {
    _initializeData();
    super.onInit();
  }

  _initializeData(){
    Utils.logEvent(name: EventConstant.workflowConfigurationScreen);
    scrollController.addListener(_scrollListener);
    if (canView) fetchWorkflows();
  }

  _scrollListener(){
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      if (workflows.length == totalRecords) {
        return;
      }
      currentPage++;
      fetchWorkflows();
    }
  }

  fetchWorkflows({bool clear = false}) async {
    Utils.showLoadingDialog();
    if (clear) {
      currentPage = 1;
    }
    Map<String, dynamic>? queryParameters = {
      "pageNumber": currentPage,
      "pageSize": pageSize,
      if (searchController.text.isNotEmpty) "searchText": searchController.text,
      if (selectedType.value != null)
        "workflowType": TranslationService().keys['en']![selectedType.value]!,
      if (selectedStatus.value != null)
        "status": selectedStatus.value == "active",
    };
    ApiResponse apiResponse = await repo.allWorkflows(
        request: RequestBody(queryParameters: queryParameters));

    Utils.hideLoadingDialog();
    if (apiResponse.appState == AppState.onSuccess) {
      BaseApiModel baseApiModel = apiResponse.data;
      totalRecords = baseApiModel.totalRecords;
      stats[0].value = baseApiModel.totalRecords.toString();
      stats[1].value = baseApiModel.activeCount.toString();
      stats[2].value = baseApiModel.inactiveCount.toString();
      stats.refresh();
      List<Workflows> adsData = List<Workflows>.from(
          baseApiModel.data.map((x) => Workflows.fromJson(x)));
      if (clear) {
        workflows.value = adsData;
      } else {
        workflows.addAll(adsData);
      }
    } else {
      Utils.handleAPIError(apiResponse);
    }
  }

  filterBottomSheet() {
    Utils.hideKeyboard();
    Get.bottomSheet(
        Padding(
          padding:
              EdgeInsets.only(left: 16.w, right: 16.w, bottom: 20.h, top: 10.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              buildBottomSheetHeader(),
              Obx(() => LabelDropDown(
                    items: AppConstant.workflowTypes,
                    selectedValue: selectedType.value,
                    hint: "chooseAnOption",
                    onChanged: (value) {
                      selectedType.value = value;
                    },
                    label: 'workflowType',
                  )),
              16.verticalSpace,
              Obx(() => LabelDropDown(
                    items: AppConstant.activeInActiveStatuses,
                    selectedValue: selectedStatus.value,
                    hint: "chooseAnOption",
                    onChanged: (value) {
                      selectedStatus.value = value;
                    },
                    label: 'status',
                  )),
              20.verticalSpace,
              buildBottomSheetButtons(
                  onClear: () => clearFilter(),
                  onApply: () {
                    Get.back();
                    pageSize = 10;
                    fetchWorkflows(clear: true);
                  }),
            ],
          ),
        ),
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(30.r))));
  }

  clearFilter() {
    Get.back();
    selectedStatus.value = null;
    selectedType.value = null;
    pageSize = 10;
    fetchWorkflows(clear: true);
  }

  enableDisable(Workflows workflow) async {
    Utils.showLoadingDialog();
    workflow.isActive = !workflow.isActive;
    var body = {"id": workflow.id, "isActive": workflow.isActive};

    ApiResponse apiResponse =
        await repo.enableDisableWorkflow(request: RequestBody(body: body));
    Utils.hideLoadingDialog();
    if (apiResponse.appState == AppState.onSuccess) {
      Utils.showGlobalSnackBar(message: apiResponse.data);
      if (workflow.isActive) {
        stats[1].value = "${int.parse(stats[1].value) + 1}";
        stats[2].value = "${int.parse(stats[2].value) - 1}";
      } else {
        stats[2].value = "${int.parse(stats[2].value) + 1}";
        stats[1].value = "${int.parse(stats[1].value) - 1}";
      }
      if (selectedStatus.value != null) {
        workflows.remove(workflow);
      }
      stats.refresh();
      workflows.refresh();
    } else {
      Utils.handleAPIError(apiResponse);
    }
  }

  deleteWorkflow(Workflows workflow) async {
    Utils.showLoadingDialog();
    ApiResponse apiResponse = await repo.deleteWorkflow(
        request: RequestBody(
            endPoint: "${ApiConstant.deleteWorkflow}${workflow.id}"));
    Utils.hideLoadingDialog();
    if (apiResponse.appState == AppState.onSuccess) {
      Utils.showGlobalSnackBar(message: "workflowDeletedSuccessfully".tr);
      workflows.remove(workflow);
      stats[0].value = "${int.parse(stats[0].value) - 1}";
      if (workflow.isActive) {
        stats[1].value = "${int.parse(stats[1].value) + 1}";
        stats[2].value = "${int.parse(stats[2].value) + -1}";
      } else {
        stats[2].value = "${int.parse(stats[2].value) + 1}";
        stats[1].value = "${int.parse(stats[1].value) - 1}";
      }
      stats.refresh();
    } else {
      Utils.handleAPIError(apiResponse);
    }
  }

  addNewWorkflow({Workflows? workflow, bool isView = false}) {
    Get.toNamed(AppRoutes.addWorkflowScreen,
        arguments: {"workflow": workflow, "isView": isView})?.then((val) {
      if (val != null && val) {
        if (canView) {
          fetchWorkflows(clear: true);
        }
      }
    });
  }

  exportWorkflowConfig() {
    Utils.downloadFile(
        url: ApiConstant.exportWorkflows,
        isExport: true,
        filename: "WorkFlow_Config.csv");
  }

  onMenuSelected(String item, Workflows workflow) {
    if (item == "delete") {
      deleteWorkflow(workflow);
    } else {
      addNewWorkflow(workflow: workflow, isView: item == "view");
    }
  }

  @override
  void onClose() {
    scrollController.removeListener(_scrollListener);
    scrollController.dispose();
    searchController.dispose();

    selectedType.close();
    selectedStatus.close();
    stats.close();
    workflows.close();
    super.onClose();
  }

}
