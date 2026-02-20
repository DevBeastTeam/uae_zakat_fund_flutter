import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/data/response/app_state.dart';
import 'package:zakat_fund/data/response/network_response.dart';
import 'package:zakat_fund/model/ads.dart';
import 'package:zakat_fund/model/base_api_model.dart';
import 'package:zakat_fund/model/request_body.dart';
import 'package:zakat_fund/model/stats_data.dart';
import 'package:zakat_fund/repository/ads_repo.dart';
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
import 'package:zakat_fund/widgets/pop_up.dart';

class AdsManagementViewModel extends ModulePermissionsViewModel {
  int pageSize = 10;
  int currentPage = 1;
  int totalRecords = 0;

  final searchController = TextEditingController();
  final creationDate = TextEditingController();
  final expiryDate = TextEditingController();
  final scrollController = ScrollController();

  DateTime currentDate = DateTime.now();
  DateTimeRange dateTimeRange = DateTimeRange(
    start: DateTime.now().subtract(Duration(days: 1)),
    end: DateTime.now(),
  );
  DateTime? selectedExpiryDate;
  DateTimeRange? selectedDateRange;

  RxnString selectedStatus = RxnString();
  RxnString selectedType = RxnString();
  RxnString selectedLanguage = RxnString();

  final RxList<StatsData> stats = [
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

  RxList<Ads> ads = <Ads>[].obs;

  final repo = AdsRepoImpl();

  @override
  Future<void> onInit() async {
    _initializeData();
    super.onInit();
  }

  _initializeData() {
    Utils.logEvent(name: EventConstant.adsManagementScreen);
    scrollController.addListener(_scrollListener);
    if (canView) fetchAds();
  }

  _scrollListener() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      if (ads.length == totalRecords) {
        return;
      }
      currentPage++;
      fetchAds();
    }
  }

  fetchAds({bool clear = false}) async {
    Utils.showLoadingDialog();
    if (clear) {
      currentPage = 1;
    }
    Map<String, dynamic>? queryParameters = {
      "pageNumber": currentPage,
      "pageSize": pageSize,
      if (searchController.text.isNotEmpty) "searchText": searchController.text,
      if (selectedType.value != null)
        "adType": selectedType.value == "banner" ? 1 : 2,
      if (selectedStatus.value != null)
        "status": Utils.statusIntoInt(selectedStatus.value!),
      if (selectedLanguage.value != null)
        "language": selectedLanguage.value == "english" ? 1 : 2,
      if (selectedExpiryDate != null)
        "expiryDate": Utils.newDateFormat.format(selectedExpiryDate!),
      if (selectedDateRange != null) ...{
        "startDate": Utils.newDateFormat.format(selectedDateRange!.start),
        "endDate": Utils.newDateFormat.format(selectedDateRange!.end)
      },
    };
    ApiResponse apiResponse = await repo.allAdsPaginated(
        request: RequestBody(queryParameters: queryParameters));

    Utils.hideLoadingDialog();
    if (apiResponse.appState == AppState.onSuccess) {
      BaseApiModel baseApiModel = apiResponse.data;
      totalRecords = baseApiModel.totalRecords;
      Stats adsStats = baseApiModel.stats;
      _updateStats(adsStats);
      List<Ads> adsData =
          List<Ads>.from(baseApiModel.data.map((x) => Ads.fromJson(x)));
      if (clear) {
        ads.value = adsData;
      } else {
        ads.addAll(adsData);
      }
    } else {
      Utils.handleAPIError(apiResponse);
    }
  }

  _updateStats(Stats adsStats) {
    stats[0].value = adsStats.total.toString();
    stats[1].value = adsStats.accepted.toString();
    stats[2].value = adsStats.pending.toString();
    stats[3].value = adsStats.returned.toString();
    stats[4].value = adsStats.rejected.toString();
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
                    items: AppConstant.adsTypes,
                    selectedValue: selectedType.value,
                    hint: "chooseAnOption",
                    onChanged: (value) {
                      selectedType.value = value;
                    },
                    label: 'adType',
                  )),
              16.verticalSpace,
              Obx(() => LabelDropDown(
                    items: AppConstant.languages,
                    selectedValue: selectedLanguage.value,
                    hint: "chooseAnOption",
                    onChanged: (value) {
                      selectedLanguage.value = value;
                    },
                    label: 'language',
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
                label: "expiryDate",
                onTap: () => datePickerDialog(),
                readOnly: true,
                isDate: true,
                controller: expiryDate,
              ),
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
                  onClear: () => clearAll(),
                  onApply: () {
                    Get.back();
                    pageSize = 10;
                    fetchAds(clear: true);
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
    selectedType.value = null;
    selectedLanguage.value = null;
    selectedStatus.value = null;
    selectedExpiryDate = null;
    selectedDateRange = null;
    expiryDate.clear();
    creationDate.clear();
    pageSize = 10;
    fetchAds(clear: true);
  }

  addNewAds({Ads? ad}) {
    Get.toNamed(AppRoutes.addAdsScreen, arguments: ad)?.then((val) {
      if (val != null && val) {
        if (canView) {
          fetchAds(clear: true);
        }
      }
    });
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

  datePickerDialog() async {
    DateTime dateTime = DateTime.now();
    DateTime? picked = await showDatePicker(
      context: Get.context!,
      initialDate: dateTime,
      firstDate: DateTime(1950),
      locale: Locale(Utils.isArabic ? "ar" : "en"),
      fieldHintText: "dd/mm/yyyy",
      lastDate: DateTime(dateTime.year + 10),
    );
    String date = Utils.dateFormat1.format(picked!);
    selectedExpiryDate = picked;
    expiryDate.text = date;
  }

  preview(Ads ad) {
    Navigator.of(
      Get.context!,
    ).push(
      PageRouteBuilder(
        opaque: false,
        fullscreenDialog: true,
        pageBuilder: (_, __, ___) => PopUpDialog(
          ads: ad,
        ),
      ),
    );
  }

  enableDisable(Ads ad) async {
    Utils.showLoadingDialog();
    ad.isActive = !ad.isActive;
    var body = {"id": ad.id, "isActive": ad.isActive};
    ApiResponse apiResponse =
        await repo.enableDisableAds(request: RequestBody(body: body));
    Utils.hideLoadingDialog();
    if (apiResponse.appState == AppState.onSuccess) {
      Utils.showGlobalSnackBar(
          message: ad.isActive
              ? "adActivatedSuccessfully".tr
              : "adDeactivatedSuccessfully".tr);
      ads.refresh();
    } else {
      Utils.handleAPIError(apiResponse);
    }
  }

  exportAds() {
    Utils.downloadFile(
        url: ApiConstant.exportAds, isExport: true, filename: "Ads.csv");
  }

  onMenuSelected(String value, Ads ad) {
    if (value == "edit") {
      addNewAds(ad: ad);
    } else {
      preview(ad);
    }
  }

  @override
  void onClose() {
    scrollController.removeListener(_scrollListener);
    scrollController.dispose();
    searchController.dispose();
    creationDate.dispose();
    expiryDate.dispose();

    selectedStatus.close();
    selectedType.close();
    selectedLanguage.close();
    stats.close();
    ads.close();

    super.onClose();
  }
}
