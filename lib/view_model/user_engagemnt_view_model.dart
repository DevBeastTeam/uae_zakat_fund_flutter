import 'package:fl_chart/fl_chart.dart' as fl;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/data/response/app_state.dart';
import 'package:zakat_fund/data/response/network_response.dart';
import 'package:zakat_fund/model/dashboard_data.dart';
import 'package:zakat_fund/model/donor_demographic.dart';
import 'package:zakat_fund/model/engagemnt_interaction.dart';
import 'package:zakat_fund/model/request_body.dart';
import 'package:zakat_fund/repository/user_engagement_dashbaord_repo.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/utils/constants/event_constant.dart';
import 'package:zakat_fund/utils/mixins/generic_mixin.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/widgets/bottom_sheet_header.dart';
import 'package:zakat_fund/widgets/elevated_button.dart';

class UserEngagementViewModel extends GetxController with GetTickerProviderStateMixin, GenericMixin {

  final scrollController = ScrollController();
  late final TabController tabController;

  final RxInt currentTabIndex = 0.obs;
  final TextEditingController dateRange = TextEditingController();

  final repo = UserEngagementDashboardRepoImpl();

  late DateTime currentDate;
  late DateTimeRange dateTimeRange;
  DateTimeRange? selectedDateRange;

  // Dashboard Sections
  final dashboardData = <DashboardData>[
    DashboardData(
      title: "userActivityOverview",
      value: "0",
      backColor: AppColors.lightBlueColor1,
      style: AppTextStyle.darkBlue16spTextStyle,
    ),
    DashboardData(
      title: "preferredLoginPeriod",
      value: "",
      backColor: AppColors.lightPurpleColor,
      style: AppTextStyle.darkPurple16spTextStyle,
    ),
    DashboardData(
      title: "preferredLoginDay",
      value: "",
      backColor: AppColors.lightGreenColor1,
      style: AppTextStyle.darkGreenColor16spTextStyle1,
    ),
  ].obs;

  final lowestActivityTime = <DashboardData>[
    DashboardData(
      title: "weekdays",
      value: "",
      icon: "0 ${"logins".tr}",
      backColor: AppColors.lightGreenColor3,
      style: AppTextStyle.darkGreenColor16spTextStyle2,
    ),
    DashboardData(
      title: "weekends",
      value: "",
      icon: "0 ${"logins".tr}",
      backColor: AppColors.lightRedColor3,
      style: AppTextStyle.darkRed16spTextStyle,
    ),
  ].obs;

  final preferredLoginPeriod = <PreferredLoginPeriod>[].obs;
  final preferredLoginDay = <PreferredLoginDay>[].obs;

  final activityChartData = <DashboardData>[
    DashboardData(title: 'weekdayLogin', value: '0', valueInDouble: 0.0, backColor: AppColors.lightBrownColor2),
    DashboardData(title: 'weekendLogin', value: '0', valueInDouble: 0.0, backColor: AppColors.lightYellowColor1),
  ].obs;

  final feedbacksChartData = <DashboardData>[
    DashboardData(title: 'suggestions', value: '0', valueInDouble: 0, backColor: AppColors.darkBlueColor),
    DashboardData(title: 'complaints', value: '0', valueInDouble: 0, backColor: AppColors.secondaryLightBlueColor),
  ].obs;

  final surveysChartData = <DashboardData>[
    DashboardData(title: 'total', value: '0', valueInDouble: 0, backColor: AppColors.creditColor),
    DashboardData(title: 'completed', value: '0', valueInDouble: 0, backColor: AppColors.fullRefundColor),
    DashboardData(title: 'active', value: '0', valueInDouble: 0, backColor: AppColors.darkBlueColor),
  ].obs;

  final responseRate = "0".obs;

  final categories = <String>[].obs;
  final categoryRatings = <DonorDemographic>[].obs;

  final userTypes = <String>[].obs;
  final userTypesRatings = <DonorDemographic>[].obs;

  final months = <String>[].obs;
  final spots = <fl.FlSpot>[].obs;

  List<CategoryRatingDetails> categoryRatingDetails = [];


  @override
  void onInit() {
    _initializeData();
    super.onInit();
  }

  _initializeData() {
    Utils.logEvent(
        name: EventConstant.userEngagementInteractionDashboardScreen);
    tabController = TabController(length: 3, vsync: this);
    tabController.addListener(_tabListener);
    currentDate = DateTime.now();
    dateTimeRange = DateTimeRange(
      start: currentDate.subtract(Duration(days: 1)),
      end: currentDate,
    );
    selectedDateRange = DateTimeRange(
        start:
            DateTime(currentDate.year, currentDate.month - 2, currentDate.day),
        end: currentDate);
    dateRange.text =
        "${Utils.dateFormat1.format(selectedDateRange!.start)} - ${Utils.dateFormat1.format(selectedDateRange!.end)}";
    _fetchData();
  }

  _tabListener(){
    currentTabIndex.value = tabController.index;
  }

  _fetchData() async {
    try{
      Utils.showLoadingDialog();
      await Future.wait([
        fetchHeaderData(),
        fetchPreferredLoginTimes(),
        fetchFeedbacks(),
        fetchSurveys(),
        fetchCategoryRating(),
        fetchUserTypeRating(),
      ]);
    }finally{
      Utils.hideLoadingDialog();
    }

  }

  Future fetchHeaderData() async {
    final result = await getAdminDashboardGetHeaderDataUEIDD(_queryParameters());
    if(result!=null){
      UserEngagementInteraction data = result;
      dashboardData[0].value = data.userActivityOverview.first.userActivityOverview.toString();
      preferredLoginPeriod.value = data.preferredLoginPeriods;
      preferredLoginDay.value = data.preferredLoginDays;

      final weekday = data.weekdayWeekendLogins.firstWhereOrNull((e) => e.loginType == "Weekdays Login");
      final weekend = data.weekdayWeekendLogins.firstWhereOrNull((e) => e.loginType == "Weekend Login");
      _updateChartData(activityChartData, [weekday?.logins ?? 0, weekend?.logins ?? 0], 2);

      lowestActivityTime[0]
        ..value = data.lowestActivityTimesWeekdays.firstOrNull?.timeRange ?? ""
        ..icon = "${data.lowestActivityTimesWeekdays.firstOrNull?.logins ?? 0} ${"logins".tr}";
      lowestActivityTime[1]
        ..value = data.lowestActivityTimesWeekends.firstOrNull?.timeRange ?? ""
        ..icon = "${data.lowestActivityTimesWeekends.firstOrNull?.logins ?? 0} ${"logins".tr}";
      lowestActivityTime.refresh();
    }
  }

  void _updateChartData(RxList<DashboardData> chartData, List<int> values, int divisor) {
    for (int i = 0; i < chartData.length && i < values.length; i++) {
      chartData[i].value = values[i].toString();
      chartData[i].valueInDouble = calculateRation(values[i], divisor);
    }
    chartData.refresh();
  }



  Future fetchFeedbacks() async {
    ApiResponse apiResponse = await repo.adminDashboardGetFeedbackItemUEIDD(
        request: RequestBody(queryParameters: _queryParameters()));
    if (apiResponse.appState == AppState.onSuccess) {
      FeedbacksSummary summary = apiResponse.data;
      _updateChartData(feedbacksChartData, [summary.suggestion, summary.complaint], 2);
    } else {
      Utils.handleAPIError(apiResponse);
    }
  }

  Future fetchSurveys() async {
    ApiResponse apiResponse = await repo.adminDashboardGetSurveyItemUEIDD(
        request: RequestBody(queryParameters: _queryParameters()));
    if (apiResponse.appState == AppState.onSuccess) {
      SurveysSummary summary = apiResponse.data;
      _updateChartData(surveysChartData, [summary.totalSurvey, summary.completed, summary.active], 3);
      responseRate.value = summary.totalSurvey == 0 ? "0" : ((summary.completed / summary.totalSurvey) * 100).round().toString();
    } else {
      Utils.handleAPIError(apiResponse);
    }
  }

  Future fetchCategoryRating() async {
    ApiResponse apiResponse = await repo.adminDashboardGetRatingPerContentUEIDD(
        request: RequestBody(queryParameters: _queryParameters()));
    if (apiResponse.appState == AppState.onSuccess) {
      List<CategoryRating> ratings = apiResponse.data;
      categories.clear();
      categoryRatings.clear();
      for (CategoryRating rating in ratings) {
        categories.add(rating.contentType.replaceAll(" ", "").toLowerCase().tr);
        categoryRatings.add(
          DonorDemographic(
              countryResidenceId: 0,
              countryName: rating.contentType.toLowerCase(),
              countryNameArabic: rating.contentType.toLowerCase(),
              male: rating.yesRatings,
              female: rating.noRatings,
              ageGroup: rating.contentType),
        );
      }
      categories.refresh();
      categoryRatings.refresh();
    } else {
      Utils.handleAPIError(apiResponse);
    }
  }

  Future fetchUserTypeRating() async {
    ApiResponse apiResponse =
        await repo.adminDashboardGetRatingPerUserTypeUEIDD(
            request: RequestBody(queryParameters: _queryParameters()));
    if (apiResponse.appState == AppState.onSuccess) {
      List<UserTypeRating> ratings = apiResponse.data;
      userTypes.clear();
      userTypesRatings.clear();
      for (UserTypeRating rating in ratings) {
        String name = Utils.isArabic ? rating.nameAr : rating.name;
        userTypes.add(name);
        userTypesRatings.add(
          DonorDemographic(
              countryResidenceId: 0,
              countryName: name,
              countryNameArabic: name,
              male: rating.yesRatings,
              female: rating.noRatings,
              ageGroup: ""),
        );
      }
      userTypes.refresh();
      userTypesRatings.refresh();
    } else {
      Utils.handleAPIError(apiResponse);
    }
  }

  Future fetchFeedbackDetails(int index) async {
    Utils.showLoadingDialog();
    Map<String, dynamic>? queryParameters = _queryParameters()
      ..addAll(
          {"type": Utils.categoryTypeIntoInt(categoryRatings[index].ageGroup)});
    ApiResponse apiResponse =
        await repo.adminDashboardGGetListDataByContentTypeUEIDD(
            request: RequestBody(queryParameters: queryParameters));
    Utils.hideLoadingDialog();
    if (apiResponse.appState == AppState.onSuccess) {
      categoryRatingDetails = apiResponse.data;
      if (categoryRatingDetails.isEmpty) {
        return;
      }
      showDonorDialog();
    } else {
      Utils.handleAPIError(apiResponse);
    }
  }

  Future fetchPreferredLoginTimes() async {
    ApiResponse apiResponse =
        await repo.adminDashboardGetPreferredLoginTimeListUEIDD(
            request: RequestBody(queryParameters: _queryParameters()));
    if (apiResponse.appState == AppState.onSuccess) {
      List<LowestActivityTimesWeek> loginTimes = apiResponse.data;
      spots.clear();
      months.value = loginTimes.map((item) => item.timeRange.replaceAll(" to ", "\nto\n")).toList();
      for (int i = 0; i < loginTimes.length; i++) {
        if (loginTimes[i].logins > 0) {
          spots.add(fl.FlSpot(i.toDouble(), loginTimes[i].logins.toDouble()));
        }
      }

      spots.refresh();
      months.refresh();
    } else {
      Utils.handleAPIError(apiResponse);
    }
  }

  double calculateRation(int value, int total) {
    return total > 0 ? value / total : 0;
  }

  void showDonorDialog() {
    Get.dialog(
      Dialog(
        insetPadding: EdgeInsets.symmetric(horizontal: 16.w),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.r),
        ),
        backgroundColor: Colors.white,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildBottomSheetHeader(text: "details"),
              Table(
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                columnWidths: const {
                  0: FlexColumnWidth(2.5),
                  1: FlexColumnWidth(1),
                  2: FlexColumnWidth(1),
                },
                children: [
                  TableRow(
                    children: [
                      _tableCell('list', isHeader: true),
                      _tableCell('likes', isHeader: true),
                      _tableCell('dislikes', isHeader: true),
                    ],
                  ),
                  ...categoryRatingDetails.map((data) => TableRow(
                        children: [
                          _tableCell(
                              '• ${Utils.isArabic ? data.titleAr : data.titleEn}'),
                          _tableCell(data.yesRatings.toString()),
                          _tableCell(data.noRatings.toString()),
                        ],
                      )),
                ],
              ),
              16.verticalSpace,
              elevatedButton(text: "close", onPressed: () => Get.back())
            ],
          ),
        ),
      ),
    );
  }

  Widget _tableCell(String text, {bool isHeader = false}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text.tr,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: isHeader
            ? AppTextStyle.black12spTextStyle1
            : AppTextStyle.secondaryPrimaryBlack12spTextStyle,
      ),
    );
  }

  datePicker() async {
    DateTimeRange? newDateRange = await Utils.dateRangePicker(
        selectedDateRange, dateTimeRange, DateTime(currentDate.year + 50));
    if (newDateRange != null) {
      selectedDateRange = newDateRange;
      dateRange.text =
          "${Utils.dateFormat1.format(selectedDateRange!.start)} - ${Utils.dateFormat1.format(selectedDateRange!.end)}";
      _fetchData();
    }
  }

  Map<String, dynamic> _queryParameters() => {
        'startDate': Utils.newDateFormat.format(selectedDateRange!.start),
        'endDate': Utils.newDateFormat.format(selectedDateRange!.end),
      };

  @override
  void onClose() {
    scrollController.dispose();
    tabController.removeListener(_tabListener);
    tabController.dispose();
    dateRange.dispose();

    currentTabIndex.close();
    dashboardData.close();
    lowestActivityTime.close();
    preferredLoginPeriod.close();
    preferredLoginDay.close();
    activityChartData.close();
    feedbacksChartData.close();
    surveysChartData.close();
    responseRate.close();
    categories.close();
    categoryRatings.close();
    userTypes.close();
    userTypesRatings.close();
    months.close();
    spots.close();
    super.onClose();
  }

}
