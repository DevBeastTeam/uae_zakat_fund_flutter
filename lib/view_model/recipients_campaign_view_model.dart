import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/data/response/app_state.dart';
import 'package:zakat_fund/data/response/network_response.dart';
import 'package:zakat_fund/model/base_api_model.dart';
import 'package:zakat_fund/model/recipients_campaign.dart';
import 'package:zakat_fund/model/request_body.dart';
import 'package:zakat_fund/model/stats_data.dart';
import 'package:zakat_fund/repository/campaign_repo.dart';
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

class RecipientsCampaignViewModel extends ModulePermissionsViewModel {
  final searchController = TextEditingController();
  final creationDate = TextEditingController();
  final scrollController = ScrollController();

  int currentPage = 1;
  int pageSize = 10;
  int totalRecords = 0;

  late final DateTime currentDate;
  late final DateTimeRange dateTimeRange;
  DateTimeRange? selectedDateRange;

  final RxList<RecipientsCampaign> recipients = <RecipientsCampaign>[].obs;

  final RxnString selectedUserType = RxnString();


  final RxList<StatsData> stats = [
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

  final repo = CampaignRepoImpl();

  @override
  onInit() {
    _initializeData();
    super.onInit();
  }

  _initializeData() {
    Utils.logEvent(name: EventConstant.recipientsScreen);
    currentDate = DateTime.now();
    dateTimeRange = DateTimeRange(
      start: currentDate.subtract(Duration(days: 1)),
      end: currentDate,
    );
    scrollController.addListener(_scrollListener);
    if (canView) fetchRecipients();
  }

  _scrollListener(){
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      if (recipients.length == totalRecords) {
        return;
      }
      currentPage++;
      fetchRecipients();
    }
  }

  Future fetchRecipients({bool clear = false, bool fromDelete = false}) async {
    if (!fromDelete) Utils.showLoadingDialog();
    if (clear) {
      currentPage = 1;
    }
    Map<String, dynamic>? queryParameters = {
      "pageNumber": currentPage,
      "pageSize": pageSize,
      if (searchController.text.isNotEmpty) "searchText": searchController.text,
      if (selectedUserType.value != null)
        "userType": Utils.groupsTypesIntoInt(selectedUserType.value!),
      if (selectedDateRange != null) ...{
        "startDate": Utils.newDateFormat.format(selectedDateRange!.start),
        "endDate": Utils.newDateFormat.format(selectedDateRange!.end)
      },
    };
    ApiResponse apiResponse = await repo.allRecipientsListPaginated(
        request: RequestBody(queryParameters: queryParameters));
    Utils.hideLoadingDialog();
    if (apiResponse.appState == AppState.onSuccess) {
      BaseApiModel baseApiModel = apiResponse.data;
      totalRecords = baseApiModel.totalRecords;
      Stats groupStats = baseApiModel.stats;
      _updateStats(groupStats);
      List<RecipientsCampaign> newsData = List<RecipientsCampaign>.from(
          baseApiModel.data.map((x) => RecipientsCampaign.fromJson(x)));
      if (clear) {
        recipients.value = newsData;
      } else {
        recipients.addAll(newsData);
      }
    } else {
      Utils.handleAPIError(apiResponse);
    }
  }

  _updateStats(Stats groupStats) {
    stats[0].value = groupStats.total.toString();
    stats[1].value = groupStats.active.toString();
    stats[2].value = groupStats.inActive.toString();
    stats.refresh();
  }

  addNewGroup({RecipientsCampaign? recipient}) {
    Get.toNamed(AppRoutes.addGroupScreen, arguments: recipient)?.then((val) {
      if (val != null && val) {
        if (canView) {
          fetchRecipients(clear: true);
        }
      }
    });
  }

  Future deleteRecipientGroup(int id) async {
    Utils.showLoadingDialog();
    ApiResponse apiResponse = await repo.deleteGroup(
        request: RequestBody(endPoint: "${ApiConstant.deleteGroup}/$id"));
    if (apiResponse.appState == AppState.onSuccess) {
      Utils.showGlobalSnackBar(message: "groupDeletedSuccessfully".tr);
      pageSize = recipients.length;
      fetchRecipients(clear: true, fromDelete: true);
    } else {
      Utils.hideLoadingDialog();
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
                    items: AppConstant.recipientsUserTypes,
                    selectedValue: selectedUserType.value,
                    hint: "chooseAnOption",
                    onChanged: (value) {
                      selectedUserType.value = value;
                    },
                    label: 'userType',
                  )),
              16.verticalSpace,
              LabelTextField(
                label: "creationDate",
                onTap: () => dateRangePicker(),
                readOnly: true,
                hint: "${"startDate".tr} - ${"endDate".tr}",
                isDate: true,
                controller: creationDate,
              ),
              20.verticalSpace,
              buildBottomSheetButtons(
                  onClear: clearFilter,
                  onApply: () {
                    Get.back();
                    fetchRecipients(clear: true);
                  })
            ],
          ),
        ),
        isScrollControlled: true,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(30.r))));
  }

  clearFilter() {
    Get.back();
    searchController.clear();
    selectedUserType.value = null;
    selectedDateRange = null;
    creationDate.clear();
    pageSize = 10;
    fetchRecipients(clear: true);
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

  exportGroups() {
    Utils.downloadFile(
        url: ApiConstant.exportRecipients,
        isExport: true,
        filename: "Recipients.csv");
  }

  onMenuSelected(String item, RecipientsCampaign recipients) {
    if (item == "edit") {
      addNewGroup(recipient: recipients);
    } else if (item == "details") {
      Get.toNamed(AppRoutes.recipientDetailsScreen, arguments: recipients);
    } else {
      deleteRecipientGroup(recipients.id);
    }
  }

  @override
  void onClose() {
    searchController.dispose();
    creationDate.dispose();
    scrollController.removeListener(_scrollListener);
    scrollController.dispose();

    recipients.close();
    selectedUserType.close();
    stats.close();
    super.onClose();
  }

}
