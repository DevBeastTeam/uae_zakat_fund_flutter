import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/data/response/app_state.dart';
import 'package:zakat_fund/data/response/network_response.dart';
import 'package:zakat_fund/model/approver_groups.dart';
import 'package:zakat_fund/model/request_body.dart';
import 'package:zakat_fund/model/stats_data.dart';
import 'package:zakat_fund/repository/approver_groups_repo.dart';
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
import 'package:zakat_fund/widgets/label_text_field.dart';

class ApproverGroupViewModel extends ModulePermissionsViewModel {
  final searchController = TextEditingController();
  final creationDateController = TextEditingController();

  Rxn selectedActiveStatus = Rxn<String>();

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


  RxList<ApproverGroups> groups = <ApproverGroups>[].obs;
  List<ApproverGroups> allGroups = [];

  final repo = ApproverGroupsRepoImpl();

  late final DateTime currentDate;
  late DateTimeRange dateTimeRange;
  DateTimeRange? selectedDateRange;

  @override
  void onInit() {
    _initializeData();
    super.onInit();
  }

  _initializeData() {
    Utils.logEvent(name: EventConstant.approverGroupScreen);
    currentDate = DateTime.now();
    dateTimeRange = DateTimeRange(
      start: currentDate.subtract(Duration(days: 1)),
      end: currentDate,
    );
    if (canView) fetchGroups();
  }

  fetchGroups() async {
    Utils.showLoadingDialog();
    ApiResponse apiResponse = await repo.approverGroups(request: RequestBody());
    Utils.hideLoadingDialog();
    if (apiResponse.appState == AppState.onSuccess) {
      allGroups = apiResponse.data;
      groups.assignAll(allGroups);
      _updateStats();
    } else {
      Utils.handleAPIError(apiResponse);
    }
  }

  _updateStats() {
    stats[0].value = "${groups.length}";
    stats[1].value = groups.where((group) => group.status).length.toString();
    stats[2].value = groups.where((group) => !group.status).length.toString();
    stats.refresh();
  }

  void searchGroups() {
    String searchData = searchController.text.toLowerCase().trim();
    if (searchData.isEmpty) {
      groups.assignAll(allGroups);
    } else {
      groups.assignAll(
        allGroups.where((data) {
          String title = Utils.isArabic ? data.groupNameArabic : data.groupName;
          return title.toLowerCase().contains(searchData);
        }).toList(),
      );
    }
  }

  enableDisable(ApproverGroups group) async {
    Utils.showLoadingDialog();
    group.status = !group.status;
    var body = {"id": group.id, "status": group.status};
    ApiResponse apiResponse =
        await repo.enableDisableGroup(request: RequestBody(body: body));
    Utils.hideLoadingDialog();
    if (apiResponse.appState == AppState.onSuccess) {
      allGroups.firstWhere((grp) => grp.id == group.id).status = group.status;
      groups.refresh();
      _updateStats();
      Utils.showGlobalSnackBar(
          message: group.status
              ? "groupActivatedSuccessfully".tr
              : "groupDeactivatedSuccessfully".tr);
    } else {
      Utils.handleAPIError(apiResponse);
    }
  }

  deleteGroup(ApproverGroups group) async {
    Utils.showLoadingDialog();
    ApiResponse apiResponse = await repo.deleteApproverGroup(
        request: RequestBody(
            endPoint: "${ApiConstant.deleteApproverGroup}${group.id}"));
    Utils.hideLoadingDialog();
    if (apiResponse.appState == AppState.onSuccess) {
      allGroups.remove(group);
      groups.remove(group);
      _updateStats();
      Utils.showGlobalSnackBar(message: "groupDeletedSuccessfully".tr);
    } else {
      Utils.handleAPIError(apiResponse);
    }
  }

  addNewGroup({ApproverGroups? group}) {
    Get.toNamed(AppRoutes.addApproverGroupScreen, arguments: group)
        ?.then((val) {
      if (val != null && val) {
        if (canView) {
          fetchGroups();
        }
      }
    });
  }

  onMenuSelected(String item, ApproverGroups group) {
    if (item == "delete") {
      deleteGroup(group);
    } else {
      addNewGroup(group: group);
    }
  }

  exportGroups(){
    Utils.downloadFile(url: ApiConstant.exportApproverGroups, isExport: true, filename: "Approver_Groups.csv");
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
              LabelTextField(
                label: "creationDate",
                onTap: () => dateRangePicker(),
                readOnly: true,
                controller: creationDateController,
                hint: "${"startDate".tr} - ${"endDate".tr}",
              ),
              16.verticalSpace,
              Obx(() => LabelDropDown(
                items: AppConstant.activeInActiveStatuses,
                selectedValue: selectedActiveStatus.value,
                hint: "chooseAnOption",
                onChanged: (value) {
                  selectedActiveStatus.value = value;
                },
                label: '${"active".tr}/${"inactive".tr}',
              )),
              20.verticalSpace,
              buildBottomSheetButtons(onClear: ()=>clearAllFilters(), onApply: ()=>filterGroups())
            ],
          ),
        ),
        isScrollControlled: true,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(30.r))));
  }

  clearAllFilters() {
    selectedDateRange = null;
    selectedActiveStatus.value = null;
    creationDateController.clear();
    filterGroups();
  }

  filterGroups(){
    Get.back();
    String? status = selectedActiveStatus.value;
    DateTimeRange? date = selectedDateRange;

    groups.value = allGroups.where((group) {
          String active = group.status?"active":"inactive";
      final matchesStatus = active == status;
      final matchesStartDate = date == null || group.createdDate.isAfter(date.start) || group.createdDate.isAtSameMomentAs(date.start);
      final matchesEndDate = date == null || group.createdDate.isBefore(date.end) || group.createdDate.isAtSameMomentAs(date.end);
      return matchesStatus && matchesStartDate && matchesEndDate;
    }).toList();

  }

  dateRangePicker() async {
    DateTimeRange? newDateRange = await Utils.dateRangePicker(
        selectedDateRange, dateTimeRange, currentDate);
    if (newDateRange != null) {
      selectedDateRange = newDateRange;
      creationDateController.text =
      "${Utils.dateFormat1.format(selectedDateRange!.start)} - ${Utils.dateFormat1.format(selectedDateRange!.end)}";
    } else {
      creationDateController.clear();
      selectedDateRange = null;
    }
  }

  @override
  void onClose() {
    searchController.dispose();
    creationDateController.dispose();

    selectedActiveStatus.close();
    stats.close();
    groups.close();

    super.onClose();
  }

}
