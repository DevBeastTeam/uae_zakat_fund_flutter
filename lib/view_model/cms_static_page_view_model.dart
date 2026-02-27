import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/data/response/app_state.dart';
import 'package:zakat_fund/data/response/network_response.dart';
import 'package:zakat_fund/model/request_body.dart';
import 'package:zakat_fund/model/static_page.dart';
import 'package:zakat_fund/model/static_page_paginated.dart';
import 'package:zakat_fund/model/stats_data.dart';
import 'package:zakat_fund/repository/static_page_repo.dart';
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

class CMSStaticPageViewModel extends ModulePermissionsViewModel {
  final searchController = TextEditingController();
  final scrollController = ScrollController();
  final creationDate = TextEditingController();

  final StaticPageRepo staticPageRepo = StaticPageRepoImpl();

  late StaticPagePaginated staticPagePaginated;
  RxList<StaticPage> staticPages = <StaticPage>[].obs;
  final selectedSection = Rxn<String>();
  final selectedStatus = Rxn<String>();
  DateTimeRange? selectedDateRange;
  late DateTime currentDate;
  late DateTimeRange dateTimeRange;

  int currentPage = 1;
  int pageSize = 10;

  RxList<StatsData> stats = [
    StatsData(
        title: "total",
        value: "0",
        titleStyle: AppTextStyle.btnBackground12spTextStyle1,
        valueStyle: AppTextStyle.btnBackground16spTextStyle,
        backgroundColor: AppColors.btnBackgroundColor),
    StatsData(
        title: "approved",
        value: "0",
        titleStyle: AppTextStyle.darkGreenColor12spTextStyle1,
        valueStyle: AppTextStyle.darkGreen16spTextStyle1,
        backgroundColor: AppColors.darkGreenColor),
    StatsData(
        title: "pending",
        value: "0",
        titleStyle: AppTextStyle.lightBrown12spTextStyle2,
        valueStyle: AppTextStyle.lightBrown16spTextStyle1,
        backgroundColor: AppColors.lightBrownColor1),
    StatsData(
        title: "returned",
        value: "0",
        titleStyle: AppTextStyle.highBack12spTextStyle,
        valueStyle: AppTextStyle.highBack16spTextStyle,
        backgroundColor: AppColors.highBackColor),
    StatsData(
        title: "rejected",
        value: "0",
        titleStyle: AppTextStyle.highBack12spTextStyle,
        valueStyle: AppTextStyle.highBack16spTextStyle,
        backgroundColor: AppColors.highBackColor)
  ].obs;

  @override
  onInit() {
    _initializeData();
    super.onInit();
  }

  _initializeData() async {
    Utils.logEvent(name: EventConstant.cmsStaticPagesScreen);
    currentDate = DateTime.now();
    dateTimeRange = DateTimeRange(
      start: currentDate.subtract(Duration(days: 1)),
      end: currentDate,
    );
    if (canView) {
      Utils.showLoadingDialog();
      await fetchStaticPages();
      Utils.hideLoadingDialog();
    }
    scrollController.addListener(_scrollListener);
  }

  _scrollListener() async {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      if (staticPages.length == staticPagePaginated.totalRecords) {
        return;
      }
      Utils.showLoadingDialog();
      currentPage++;
      await fetchStaticPages();
      Utils.hideLoadingDialog();
    }
  }

  Future fetchStaticPages({bool clear = false}) async {
    if (clear) {
      Utils.showLoadingDialog();
      currentPage = 1;
    }

    Map<String, dynamic>? queryParameters = {
      "pageNumber": currentPage,
      "pageSize": pageSize,
      if (searchController.text.isNotEmpty) "searchText": searchController.text,
      if (selectedSection.value != null)
        "pageSection": selectedSection.value == "header" ? 1 : 2,
      if (selectedStatus.value != null)
        "status": Utils.statusIntoInt(selectedStatus.value!),
      if (selectedDateRange != null) ...{
        "fromDateOfCreation":
            Utils.newDateFormat.format(selectedDateRange!.start),
        "toDateOfCreation": Utils.newDateFormat.format(selectedDateRange!.end)
      },
    };

    ApiResponse apiResponse = await staticPageRepo.fetchStaticPages(
        request: RequestBody(
            endPoint: ApiConstant.staticPagesPaginated,
            queryParameters: queryParameters));

    if (clear) {
      Utils.hideLoadingDialog();
    }

    if (apiResponse.appState == AppState.onSuccess) {
      staticPagePaginated = apiResponse.data;
      _updateStats(staticPagePaginated.stats);
      if (clear) {
        staticPages.value = staticPagePaginated.staticPages;
      } else {
        staticPages.addAll(staticPagePaginated.staticPages);
      }
    } else {
      Utils.handleAPIError(apiResponse);
    }
  }

  void _updateStats(StaticPageStats statsData) {
    stats[0].value = statsData.total.toString();
    stats[1].value = statsData.accepted.toString();
    stats[2].value = statsData.pending.toString();
    stats[3].value = statsData.returned.toString();
    stats[4].value = statsData.rejected.toString();
    stats.refresh();
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
                    items: ["header", "footer"],
                    selectedValue: selectedSection.value,
                    hint: "chooseAnOption",
                    onChanged: (value) {
                      selectedSection.value = value;
                    },
                    label: 'pageSection',
                  )),
              16.verticalSpace,
              Obx(() => LabelDropDown(
                    items: AppConstant.statusesWithDraft,
                    selectedValue: selectedStatus.value,
                    hint: "chooseAnOption",
                    onChanged: (value) {
                      selectedStatus.value = value;
                    },
                    label: 'status',
                  )),
              16.verticalSpace,
              LabelTextField(
                label: "creationDate",
                onTap: () => dateRangePicker(),
                readOnly: true,
                isDate: true,
                hint: "${"startDate".tr} - ${"endDate".tr}",
                controller: creationDate,
              ),
              20.verticalSpace,
              buildBottomSheetButtons(
                  onClear: () => clearAll(),
                  onApply: () {
                    Get.back();
                    pageSize = 10;
                    fetchStaticPages(clear: true);
                  })
            ],
          ),
        ),
        isScrollControlled: true,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(30.r))));
  }

  clearAll() {
    Get.back();
    searchController.clear();
    creationDate.clear();
    selectedDateRange = null;
    selectedSection.value = null;
    selectedStatus.value = null;
    pageSize = 10;
    fetchStaticPages(clear: true);
  }

  dateRangePicker() async {
    DateTimeRange? newDateRange = await Utils.dateRangePicker(
        selectedDateRange, dateTimeRange, currentDate);
    if (newDateRange != null) {
      selectedDateRange = newDateRange;
      creationDate.text =
          "${Utils.dateFormat1.format(selectedDateRange!.start)} - ${Utils.dateFormat1.format(selectedDateRange!.end)}";
    } else {
      creationDate.clear();
      selectedDateRange = null;
    }
  }

  exportStaticPages() {
    Utils.downloadFile(
        url: ApiConstant.exportStaticPages,
        isExport: true,
        filename: "StaticPages.csv");
  }

  onMenuSelected(String item, StaticPage page) {
    if (item == "view") {
      Get.toNamed(AppRoutes.staticPageScreen, arguments: {
        "entityId": page.id,
        "status": page.requestStatus ?? 2,
      });
    }
  }

  @override
  void onClose() {
    scrollController.removeListener(_scrollListener);
    searchController.dispose();
    scrollController.dispose();
    creationDate.dispose();
    selectedSection.close();
    selectedStatus.close();
    staticPages.close();
    stats.close();
    super.onClose();
  }
}
