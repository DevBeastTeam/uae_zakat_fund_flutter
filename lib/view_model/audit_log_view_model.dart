import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/data/response/app_state.dart';
import 'package:zakat_fund/data/response/network_response.dart';
import 'package:zakat_fund/model/audit_logs.dart';
import 'package:zakat_fund/model/base_api_model.dart';
import 'package:zakat_fund/model/dashboard_data.dart';
import 'package:zakat_fund/model/request_body.dart';
import 'package:zakat_fund/repository/audit_log_repo.dart';
import 'package:zakat_fund/translation/translation.dart';
import 'package:zakat_fund/utils/constants/api_constant.dart';
import 'package:zakat_fund/utils/constants/app_constant.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/utils/constants/event_constant.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/view_model/module_permission_view_model.dart';
import 'package:zakat_fund/widgets/bottom_sheet_buttons.dart';
import 'package:zakat_fund/widgets/bottom_sheet_header.dart';
import 'package:zakat_fund/widgets/label_drop_down.dart';
import 'package:zakat_fund/widgets/label_text_field.dart';
import 'package:zakat_fund/widgets/status_chip.dart';
import 'package:zakat_fund/widgets/table_widget.dart';

class AuditLogViewModel extends ModulePermissionsViewModel {

  int currentPage = 1;

  RxList<AuditLogs> auditLogs = <AuditLogs>[].obs;

  ScrollController scrollController = ScrollController();
  final searchController = TextEditingController();
  final dateController = TextEditingController();

  final repo = AuditLogRepoImpl();

  Rxn selectedStatus = Rxn<String>();
  Rxn selectedAction = Rxn<String>();
  Rxn selectedEntityType = Rxn<String>();

  late BaseApiModel baseApiModel;
  late DateTimeRange dateTimeRange;
  late DateTime currentDate;

  @override
  void onInit() {
    _initializeData();
    super.onInit();
  }

  _initializeData() {
    Utils.logEvent(name: EventConstant.auditLogScreen);
    scrollController.addListener(_scrollListener);
    if (canView) fetchAuditLogs();
    currentDate = DateTime.now();
    dateTimeRange = DateTimeRange(
      start: currentDate.subtract(Duration(days: 1)),
      end: currentDate,
    );
  }

  _scrollListener() async {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        if (auditLogs.length == baseApiModel.totalRecords) {
          return;
        }
        currentPage++;
        await fetchAuditLogs();
      }
  }

  Future fetchAuditLogs({bool clear = false}) async {
    Utils.showLoadingDialog();
    if (clear) {
      currentPage = 1;
    }
    Map<String, dynamic>? queryParameters = {
      "pageNumber": currentPage,
      "pageSize": 10,
      if (searchController.text.isNotEmpty) "searchText": searchController.text,
      if (selectedStatus.value != null)
        "status": TranslationService().keys['en']![selectedStatus.value]!,
      if (selectedAction.value != null)
        "actionEn": TranslationService().keys['en']![selectedAction.value]!,
      if (selectedEntityType.value != null)
        "entityTypeEn": selectedEntityType.value,
      if (selectedRange != null) ...{
        "endDate": Utils.newDateFormat.format(selectedRange!.end),
        "startDate": Utils.newDateFormat.format(selectedRange!.start)
      },
    };
    ApiResponse apiResponse = await repo.fetchAuditLog(
        request: RequestBody(queryParameters: queryParameters));
    Utils.hideLoadingDialog();
    if (clear) {
      auditLogs.clear();
    }
    if (apiResponse.appState == AppState.onSuccess) {
      baseApiModel = apiResponse.data;
      List<AuditLogs> logs = List<AuditLogs>.from(
          baseApiModel.data.map((x) => AuditLogs.fromJson(x)));

      auditLogs.addAll(logs);
    }else{
      Utils.handleAPIError(apiResponse);
    }
  }

  detailsBottomSheet(AuditLogs log) {
    List<DashboardData> details = [
      DashboardData(
          title: "name", value: Utils.isArabic ? log.nameAr : log.nameEn),
      DashboardData(
          title: "timestamp",
          value: Utils.dateTimeFormat.format(log.createdDate)),
      DashboardData(title: "ipAddress", value: log.ipAddress),
      DashboardData(title: "status", value: log.status),
    ];
    Get.bottomSheet(
        SafeArea(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: Get.size.height * 0.85,
            ),
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 10.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildBottomSheetHeader(text: "details"),
                  Column(
                    children: details
                        .map((data) => Padding(
                              padding: EdgeInsets.symmetric( vertical: 6.h),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(data.title.tr,
                                      style: AppTextStyle
                                          .secondaryBlack16spTextStyle3),
                                  16.horizontalSpace,
                                  data.title == "status"
                                      ? statusChip(log.status.toLowerCase())
                                      : Flexible(
                                          child: Text(data.value,
                                              maxLines: 1,
                                              textDirection: TextDirection.ltr,
                                              overflow: TextOverflow.ellipsis,
                                              style: AppTextStyle
                                                  .secondaryDarkGrey16spTextStyle),
                                        ),
                                ],
                              ),
                            ))
                        .toList(),
                  ),
                  Text("comments".tr,
                      style: AppTextStyle.secondaryBlack16spTextStyle3),
                  6.verticalSpace,
                  Text(log.comments,
                      textDirection: TextDirection.ltr,
                      style: AppTextStyle.secondaryDarkGrey16spTextStyle),
                  if (log.auditLogDetails.isNotEmpty) 16.verticalSpace,
                  if (log.auditLogDetails.isNotEmpty)
                    TableWidget(auditDetails: log.auditLogDetails),
                ],
              ),
            ),
          ),
        ),
        isScrollControlled: true,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(30.r))));
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
                controller: dateController,
                label: "date",
                isDate: true,
                readOnly: true,
                hint: "${"startDate".tr} - ${"endDate".tr}",
                onTap: () => dateRangePicker(),
              ),
              16.verticalSpace,
              Obx(() => LabelDropDown(
                    items: AppConstant.auditLogsActions,
                    selectedValue: selectedAction.value,
                    hint: "chooseAnOption",
                    onChanged: (value) {
                      selectedAction.value = value;
                    },
                    label: 'action',
                  )),
              16.verticalSpace,
              Obx(() => LabelDropDown(
                    items: AppConstant.auditLogsEntityTypes,
                    selectedValue: selectedEntityType.value,
                    hint: "chooseAnOption",
                    onChanged: (value) {
                      selectedEntityType.value = value;
                    },
                    label: 'entityType',
                  )),
              16.verticalSpace,
              Obx(() => LabelDropDown(
                    items: AppConstant.auditLogsStatuses,
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
                    fetchAuditLogs(clear: true);
                  })
            ],
          ),
        ),
        backgroundColor: Colors.white,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(30.r))));
  }

  clearFilter() {
    Get.back();
    dateController.clear();
    selectedStatus.value = null;
    selectedAction.value = null;
    selectedEntityType.value = null;
    selectedRange = null;
    fetchAuditLogs(clear: true);
  }

  DateTimeRange? selectedRange;

  dateRangePicker() async {
    DateTimeRange? newDateRange = await Utils.dateRangePicker(
        selectedRange, dateTimeRange, DateTime(currentDate.year + 50));
    if (newDateRange != null) {
      selectedRange = newDateRange;
      dateController.text =
          "${Utils.dateFormat1.format(selectedRange!.start)} - ${Utils.dateFormat1.format(selectedRange!.end)}";
    } else {
      dateController.clear();
      selectedRange = null;
    }
  }

  exportAuditLogs() {
    Utils.downloadFile(
        url: "${ApiConstant.exportAuditLogs}$currentPage&pageSize=10",
        isExport: true,
        filename: "Audit_Logs.csv");
  }

  onMenuSelected(AuditLogs log) {
    detailsBottomSheet(log);
  }

  @override
  void onClose() {
    scrollController.removeListener(_scrollListener);
    scrollController.dispose();
    searchController.dispose();
    dateController.dispose();

    auditLogs.close();
    selectedStatus.close();
    selectedAction.close();
    selectedEntityType.close();

    super.onClose();
  }

}
