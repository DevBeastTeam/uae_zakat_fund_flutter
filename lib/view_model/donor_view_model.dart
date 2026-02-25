import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/data/response/app_state.dart';
import 'package:zakat_fund/data/response/network_response.dart';
import 'package:zakat_fund/model/dashboard_data.dart';
import 'package:zakat_fund/model/donor_demographic.dart';
import 'package:zakat_fund/model/donor_header_data.dart';
import 'package:zakat_fund/model/request_body.dart';
import 'package:zakat_fund/model/top_donors.dart';
import 'package:zakat_fund/repository/donor_data_repo.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_resources.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/utils/constants/event_constant.dart';
import 'package:zakat_fund/utils/mixins/generic_mixin.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/widgets/bottom_sheet_header.dart';
import 'package:zakat_fund/widgets/elevated_button.dart';

class DonorViewModel extends GetxController with GetTickerProviderStateMixin, GenericMixin {
  late final TabController tabController;
  final dateRange = TextEditingController();
  final RxInt currentTabIndex = 0.obs;

  final repo = DonorDataRepoImpl();
  late final DateTime currentDate;
  late final DateTimeRange dateTimeRange;
  DateTimeRange? selectedDateRange;

  final RxList<DashboardData> dashboardData = <DashboardData>[
    DashboardData(
        title: "totalDonors",
        value: "0",
        icon: AppResources.totalDonorsIcon,
        backColor: AppColors.lightBlueColor1,
        style: AppTextStyle.darkBlue16spTextStyle),
    DashboardData(
        title: "activeDonors",
        value: "0",
        icon: AppResources.activeDonorsIcon,
        backColor: AppColors.lightPurpleColor,
        style: AppTextStyle.darkPurple16spTextStyle),
    DashboardData(
        title: "donorRetentionRate",
        value: "0",
        icon: AppResources.donorRateIcon,
        backColor: AppColors.lightGreenColor2,
        style: AppTextStyle.darkGreenColor16spTextStyle1),
  ].obs;

  final RxList<DonorDemographic> donorDemographics = <DonorDemographic>[].obs;
  final RxList<TopDonors> topDonors = <TopDonors>[].obs;
  final RxList<String> months = <String>[].obs;
  final RxList<int> quantity = <int>[].obs;

  List<DonorDemographic> donorDemographicsDetails = [];

  @override
  Future<void> onInit() async {
    _initializeData();
    super.onInit();
  }

  _initializeData() {
    Utils.logEvent(name: EventConstant.donorsDataDashboardScreen);
    tabController = TabController(length: 2, vsync: this);
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

  _tabListener() {
      currentTabIndex.value = tabController.index;
  }

  _fetchData() async {
    try {
      Utils.showLoadingDialog();
      await Future.wait([
        fetchDonorHeaderData(),
        fetchDonorDemographic(),
        fetchTopDonors(),
      ]);
    } finally {
      Utils.hideLoadingDialog();
    }
  }

  Future fetchDonorHeaderData() async {
    final result = await getDonorHeaderData(_queryParameters());
    if(result!=null){
      DonorHeaderData donorHeaderData = result;
      dashboardData[0].value = "${donorHeaderData.totalDonor}";
      dashboardData[1].value = "${donorHeaderData.activeDonor}";
      dashboardData[2].value = "${donorHeaderData.returningDonor}%";
      dashboardData.refresh();
    }
  }

  Future fetchDonorDemographic() async {
    ApiResponse apiResponse = await repo.fetchDonorDemographic(
        request: RequestBody(queryParameters: _queryParameters()));
    if (apiResponse.appState == AppState.onSuccess) {
      donorDemographics.value = apiResponse.data;
      months.value = donorDemographics
          .map((graphic) =>
              Utils.isArabic ? graphic.countryNameArabic : graphic.countryName)
          .toList();
      donorDemographics.refresh();
    } else {
      Utils.handleAPIError(apiResponse);
    }
  }

  donorBarchartDetails(int index) async {
    Utils.showLoadingDialog();
    Map<String, dynamic>? queryParameters = _queryParameters()
      ..addAll({"countryId": donorDemographics[index].countryResidenceId});
    ApiResponse apiResponse = await repo.donorBarchartDetails(
        request: RequestBody(queryParameters: queryParameters));
    Utils.hideLoadingDialog();
    if (apiResponse.appState == AppState.onSuccess) {
      donorDemographicsDetails = apiResponse.data;
      showDonorDialog();
    } else {
      Utils.handleAPIError(apiResponse);
    }
  }

  Future fetchTopDonors() async {
    ApiResponse apiResponse = await repo.fetchTopDonors(
        request: RequestBody(queryParameters: _queryParameters()));
    if (apiResponse.appState == AppState.onSuccess) {
      topDonors.value = apiResponse.data;
    } else {
      Utils.handleAPIError(apiResponse);
    }
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
                  0: FlexColumnWidth(2),
                  1: FlexColumnWidth(1),
                  2: FlexColumnWidth(1),
                },
                children: [
                  TableRow(
                    children: [
                      _tableCell('ageGroup', isHeader: true),
                      _tableCell('male', isHeader: true),
                      _tableCell('female', isHeader: true),
                    ],
                  ),
                  ...donorDemographicsDetails.map((data) => TableRow(
                        children: [
                          _tableCell('• ${data.ageGroup}'),
                          _tableCell(data.male.toString()),
                          _tableCell(data.female.toString()),
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
        style: isHeader
            ? AppTextStyle.black12spTextStyle1
            : AppTextStyle.secondaryPrimaryBlack12spTextStyle,
      ),
    );
  }

  Map<String, dynamic> _queryParameters() => {
        'startDate': Utils.newDateFormat.format(selectedDateRange!.start),
        'endDate': Utils.newDateFormat.format(selectedDateRange!.end),
      };

  @override
  void onClose() {
    dateRange.dispose();
    tabController.removeListener(_tabListener);
    tabController.dispose();

    currentTabIndex.close();
    dashboardData.close();
    donorDemographics.close();
    topDonors.close();
    months.close();
    quantity.close();
    super.onClose();
  }
}
