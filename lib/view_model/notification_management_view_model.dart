import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/data/response/app_state.dart';
import 'package:zakat_fund/data/response/network_response.dart';
import 'package:zakat_fund/model/base_api_model.dart';
import 'package:zakat_fund/model/notifications.dart';
import 'package:zakat_fund/model/request_body.dart';
import 'package:zakat_fund/model/stats_data.dart';
import 'package:zakat_fund/repository/notifications_repo.dart';
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
import 'package:zakat_fund/widgets/cache_image.dart';
import 'package:zakat_fund/widgets/label_drop_down.dart';
import 'package:zakat_fund/widgets/label_text_field.dart';

class NotificationManagementViewModel extends ModulePermissionsViewModel {
  final searchController = TextEditingController();
  final dateController = TextEditingController();
  final scrollController = ScrollController();

  final RxList<Notifications> notifications = <Notifications>[].obs;
  final RxnString selectedStatus = RxnString();
  final RxnString selectedType = RxnString();
  final RxBool isArabic = false.obs;

  DateTimeRange? selectedDateRange;
  late DateTimeRange dateTimeRange;
  late DateTime currentDate;

  int currentPage = 1;
  int pageSize = 10;
  int totalRecords = 0;

  final RxList<StatsData> stats = <StatsData>[
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


  final repo = NotificationsRepoImpl();

  @override
  Future<void> onInit() async {
    _initializeData();
    super.onInit();
  }

  _initializeData() {
    Utils.logEvent(name: EventConstant.notificationsManagementScreen);

    isArabic.value = Utils.isArabic;
    currentDate = DateTime.now();
    dateTimeRange = DateTimeRange(
      start: currentDate.subtract(Duration(days: 1)),
      end: currentDate,
    );
    scrollController.addListener(_scrollController);
    if (canView) fetchNotifications();
  }

  _scrollController(){
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        if (notifications.length == totalRecords) {
          return;
        }
        currentPage++;
        fetchNotifications();
      }
  }

  fetchNotifications({bool clear = false}) async {
    Utils.showLoadingDialog();
    if (clear) {
      currentPage = 1;
    }
    Map<String, dynamic>? queryParameters = {
      "pageNumber": currentPage,
      "pageSize": pageSize,
      "type": 1,
      if (searchController.text.isNotEmpty) "searchText": searchController.text,
      if (selectedStatus.value != null)
        "status": Utils.statusIntoInt(selectedStatus.value!),
      if (selectedType.value != null)
        "iconName": selectedType.value == "warning" ? 3 : 2,
      if (selectedDateRange != null) ...{
        "fromDateOfCreation": Utils.newDateFormat.format(selectedDateRange!.start),
        "toDateOfCreation": Utils.newDateFormat.format(selectedDateRange!.end)
      },
    };
    ApiResponse apiResponse = await repo.cmsNotifications(
        request: RequestBody(queryParameters: queryParameters));
    Utils.hideLoadingDialog();

    if (apiResponse.appState == AppState.onSuccess) {
      BaseApiModel baseApiModel = apiResponse.data;
      totalRecords = baseApiModel.totalRecords;
      Stats notificationStats = baseApiModel.stats;
      _updateStats(notificationStats);
      List<Notifications> newsData = List<Notifications>.from(
          baseApiModel.data.map((x) => Notifications.fromJson(x)));
      if (clear) {
        notifications.value = newsData;
      } else {
        notifications.addAll(newsData);
      }
    } else {
      Utils.handleAPIError(apiResponse);
    }
  }

  _updateStats(Stats notificationStats) {
    stats[0].value = notificationStats.total.toString();
    stats[1].value = notificationStats.accepted.toString();
    stats[2].value = notificationStats.pending.toString();
    stats[3].value = notificationStats.returned.toString();
    stats[4].value = notificationStats.rejected.toString();
    stats.refresh();
  }

  addNewNotification({Notifications? notification}) {
    Get.toNamed(AppRoutes.addNotificationScreen, arguments: notification)
        ?.then((val) {
      if (val != null && val) {
        if (canView) fetchNotifications(clear: true);
      }
    });
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
                    items: AppConstant.notificationTypes,
                    selectedValue: selectedType.value,
                    hint: "chooseAnOption",
                    onChanged: (value) => selectedType.value = value,
                    label: 'type',
                  )),
              16.verticalSpace,
              Obx(() => LabelDropDown(
                    items: AppConstant.statusesWithDraft,
                    selectedValue: selectedStatus.value,
                    hint: "chooseAnOption",
                    onChanged: (value) => selectedStatus.value = value,
                    label: 'status',
                  )),
              16.verticalSpace,
              LabelTextField(
                controller: dateController,
                label: "creationDate",
                isDate: true,
                readOnly: true,
                hint: "${"startDate".tr} - ${"endDate".tr}",
                onTap: () => dateRangePicker(),
              ),
              20.verticalSpace,
              buildBottomSheetButtons(
                  onClear: () => clearAll(),
                  onApply: () {
                    Get.back();
                    pageSize = 10;
                    fetchNotifications(clear: true);
                  }),
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
    pageSize = 10;
    selectedStatus.value = null;
    selectedType.value = null;
    dateController.clear();
    selectedDateRange = null;
    fetchNotifications(clear: true);
  }

  dateRangePicker() async {
    DateTimeRange? newDateRange = await Utils.dateRangePicker(
        selectedDateRange, dateTimeRange, currentDate);
    if (newDateRange != null) {
      selectedDateRange = newDateRange;
      dateController.text =
          "${Utils.dateFormat1.format(selectedDateRange!.start)} - ${Utils.dateFormat1.format(selectedDateRange!.end)}";
    } else {
      dateController.clear();
      selectedDateRange = null;
    }
  }

  notificationDetailsDialog(Notifications notification) async {
    await Get.dialog(AlertDialog(
      backgroundColor: Colors.white,
      contentPadding: EdgeInsets.zero,
      insetPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      content: SizedBox(
        width: Get.width,
        child: Obx(() => Directionality(
              textDirection:
                  isArabic.value ? TextDirection.rtl : TextDirection.ltr,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                        onPressed: () => Get.back(),
                        padding: EdgeInsets.zero,
                        icon: const Icon(
                          Icons.highlight_remove_outlined,
                          color: AppColors.secondaryPrimaryBlackColor,
                        )),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 13.w),
                    child: Text(
                      isArabic.value
                          ? notification.titleAr
                          : notification.titleEn,
                      style: AppTextStyle.secondaryPrimaryBlack16spTextStyle,
                    ),
                  ),
                  if (notification.imageName != null &&
                      notification.imageName != "")
                    16.verticalSpace,
                  if (notification.imageName != null &&
                      notification.imageName != "")
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 13.w),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.r),
                        child: CachedImage(
                          image: notification.imageName!,
                          width: Get.width,
                          height: 250.h,
                        ),
                      ),
                    ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 13.w, vertical: 16.h),
                    child: Text(
                      isArabic.value
                          ? notification.descriptionAr
                          : notification.descriptionEn,
                      style: AppTextStyle.secondaryPrimaryBlack14spTextStyle,
                    ),
                  ),
                  0.verticalSpace,
                  Directionality(
                    textDirection: TextDirection.ltr,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 13.w),
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                              width: 2.w, color: AppColors.darkBrownColor),
                          minimumSize: Size(Get.width, 45.h),
                        ),
                        onPressed: () {
                          isArabic.value = !isArabic.value;
                        },
                        label: Text(
                          isArabic.value
                              ? "previewInEnglish".tr
                              : "previewInArabic".tr,
                          maxLines: 1,
                          style: AppTextStyle.primaryDarkBrown16spTextStyle1,
                        ),
                        icon: const Icon(
                          Icons.visibility_rounded,
                          color: AppColors.primaryDarkBrownColor,
                        ),
                      ),
                    ),
                  ),
                  16.verticalSpace,
                ],
              ),
            )),
      ),
    ));
    Future.delayed(Duration(seconds: 1)).then((_) {
      isArabic.value = Utils.isArabic;
    });
  }

  exportNotifications() {
    Utils.downloadFile(
        url: ApiConstant.exportNotifications,
        isExport: true,
        filename: "Notifications.csv");
  }

  onMenuSelected(String value, Notifications notification) {
    if (value == "edit") {
      addNewNotification(notification: notification);
    } else {
      notificationDetailsDialog(notification);
    }
  }

  @override
  void onClose() {
    searchController.dispose();
    dateController.dispose();
    scrollController.removeListener(_scrollController);
    scrollController.dispose();

    notifications.close();
    selectedStatus.close();
    selectedType.close();
    isArabic.close();
    stats.close();
    super.onClose();
  }

}
