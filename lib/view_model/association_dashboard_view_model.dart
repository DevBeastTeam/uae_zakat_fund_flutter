import 'package:fl_chart/fl_chart.dart' as fl;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/data/response/app_state.dart';
import 'package:zakat_fund/data/response/network_response.dart';
import 'package:zakat_fund/model/association_dashboard_data.dart';
import 'package:zakat_fund/model/association_donations.dart';
import 'package:zakat_fund/model/dashboard_data.dart';
import 'package:zakat_fund/model/line_chart_data.dart';
import 'package:zakat_fund/model/piechart_data.dart';
import 'package:zakat_fund/model/project.dart';
import 'package:zakat_fund/model/request_body.dart';
import 'package:zakat_fund/model/user.dart';
import 'package:zakat_fund/my_app/my_app.dart';
import 'package:zakat_fund/repository/association_dashboard_repo.dart';
import 'package:zakat_fund/utils/constants/api_constant.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_resources.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/utils/constants/event_constant.dart';
import 'package:zakat_fund/utils/mixins/generic_mixin.dart';
import 'package:zakat_fund/utils/routes/app_routes.dart';
import 'package:zakat_fund/utils/utils.dart';

class AssociationDashboardViewModel extends GetxController with GenericMixin {
  final repo = AssociationDashboardRepoImpl();

  late int id;
  late Project association;
  int? projectId;
  late DateTime currentDate;
  late DateTimeRange dateTimeRange;
  DateTimeRange? selectedDateRange;

  final dateRangeController = TextEditingController();

  RxList<AssociationDonations> donations = <AssociationDonations>[].obs;
  RxList<AssociationDonations> topProjects = <AssociationDonations>[].obs;
  RxList<DashboardData> pieChartData = <DashboardData>[].obs;
  RxList<DashboardData> dashboardData = <DashboardData>[].obs;
  RxList<DashboardData> summaryData = <DashboardData>[].obs;
  RxList<fl.FlSpot> spots = <fl.FlSpot>[].obs;
  RxList<String> months = <String>[].obs;
  RxList<String> projectList = <String>["allProjects"].obs;
  RxString selectedProject = "allProjects".obs;
  List<ProjectElements> allProjects = [];

  @override
  onInit() {
    _initializeData();
    super.onInit();
  }

  _initializeData() {
    Utils.logEvent(name: EventConstant.associationDashboardScreen);
    _initStatsData();
    _initPieChartData();
    _initSummaryData();
    currentDate = DateTime.now();
    dateTimeRange = DateTimeRange(
      start: currentDate.subtract(Duration(days: 1)),
      end: currentDate,
    );
    selectedDateRange = DateTimeRange(
        start:
            DateTime(currentDate.year, currentDate.month - 2, currentDate.day),
        end: currentDate);
    dateRangeController.text =
        "${Utils.dateFormat1.format(selectedDateRange!.start)} - ${Utils.dateFormat1.format(selectedDateRange!.end)}";

    User user = userBox.getAt(0);
    id = user.accountId!;
    _fetchDashboardData(init: true);
  }

  _initSummaryData(){
    summaryData.value = <DashboardData>[
      DashboardData(
        title: "averageDonationAmount",
        value: "perDonors".tr,
        icon: "${"currency".tr} 0 ",
        backColor: AppColors.lightGreenColor2,
        style: AppTextStyle.darkGreenColor16spTextStyle1,
      ),
      DashboardData(
        title: "refundedDonations",
        value: "refundOrCancelled".tr,
        icon: "${"currency".tr} 0 ",
        backColor: AppColors.lightPinkColor,
        style: AppTextStyle.darkPink16spTextStyle,
      ),
    ];
  }

  _initPieChartData(){
    pieChartData.value = [
      DashboardData(
        title: "firstTimeDonors",
        value: "0",
        valueInDouble: 0,
        backColor: AppColors.lightBrownColor2,
      ),
      DashboardData(
        title: "returningDonors",
        value: "0",
        valueInDouble: 0,
        backColor: AppColors.lightYellowColor1,
      )
    ];
  }

  _initStatsData() {
    dashboardData.value = <DashboardData>[
      DashboardData(
        title: "totalProjects",
        value: "0",
        icon: AppResources.totalProjectsIcon,
        backColor: AppColors.lightBlueColor1,
        style: AppTextStyle.darkBlue16spTextStyle,
      ),
      DashboardData(
        title: "amountReceived",
        value: "${"currency".tr} 0",
        icon: AppResources.amountReceivedIcon,
        backColor: AppColors.lightPinkColor,
        style: AppTextStyle.darkPink16spTextStyle,
      ),
      DashboardData(
        title: "amountTransferred",
        value: "${"currency".tr} 0",
        icon: AppResources.amountTransferredIcon,
        backColor: AppColors.lightOrangeColor,
        style: AppTextStyle.darkOrange16spTextStyle,
      ),
      DashboardData(
        title: "activeProjects",
        value: "0",
        icon: AppResources.activeProjectsIcon,
        backColor: AppColors.lightPurpleColor,
        style: AppTextStyle.darkPurple16spTextStyle,
      ),
      DashboardData(
        title: "targetedAmount",
        value: "${"currency".tr} 0",
        icon: AppResources.targetedAmountIcon,
        backColor: AppColors.lightGreenColor2,
        style: AppTextStyle.darkGreenColor16spTextStyle1,
      ),
      DashboardData(
        title: "availableBalance",
        value: "${"currency".tr} 0",
        icon: AppResources.availableBalanceIcon,
        backColor: AppColors.lightGreenColor1,
        style: AppTextStyle.darkGreenColor16spTextStyle,
      ),
    ];
  }

  _fetchDashboardData({bool init = false}) async {
    try{
      Utils.showLoadingDialog();
      await Future.wait([
        if (init) fetchProjects(),
        fetchDonorPercentage(),
        fetchDashboardData(),
        fetchAverageSummary(),
        fetchDonations(),
        fetchLineChartData()
      ]);
    }finally{
      Utils.hideLoadingDialog();
    }
  }

  Future fetchDashboardData() async {
    Map<String, dynamic>? queryParameters = {
      "accountId": id,
      "startDate": Utils.newDateFormat.format(selectedDateRange!.start),
      "endDate": Utils.newDateFormat.format(selectedDateRange!.end),
      if (projectId != null) "projectId": projectId
    };
    ApiResponse apiResponse = await repo.fetchDashboardData(
        request: RequestBody(
            endPoint: ApiConstant.associationDashboardData,
            queryParameters: queryParameters));
    if (apiResponse.appState == AppState.onSuccess) {
      AssociationDashboardData? data = apiResponse.data;
      if (data != null) {
        dashboardData[0].value = "${data.totalProjects}";
        dashboardData[1].value =
            "${"currency".tr} ${Utils.getCurrency(data.amountReceived.toInt())}";
        dashboardData[2].value =
            "${"currency".tr} ${Utils.getCurrency(data.amountTransferred.toInt())}";
        dashboardData[3].value = "${data.activeProjects}";
        dashboardData[4].value =
            "${"currency".tr} ${Utils.getCurrency(data.targetedAmount.toInt())}";
        dashboardData[5].value = "${"currency".tr} ${Utils.getCurrency(0)}";
        dashboardData.refresh();
      } else {
        _initStatsData();
      }
    } else {
      Utils.handleAPIError(apiResponse);
    }
  }

  Future fetchAverageSummary() async {
    Map<String, dynamic>? queryParameters = {
      "accountId": id,
      "startDate": Utils.newDateFormat.format(selectedDateRange!.start),
      "endDate": Utils.newDateFormat.format(selectedDateRange!.end),
      if (projectId != null) "projectId": projectId
    };
    ApiResponse apiResponse = await repo.fetchAverageSummary(
        request: RequestBody(
            endPoint: ApiConstant.associationAverageSummary,
            queryParameters: queryParameters));
    if (apiResponse.appState == AppState.onSuccess) {
      AssociationAverageSummary summary = apiResponse.data;
      summaryData[0].icon =
          "${"currency".tr} ${Utils.getCurrency(summary.averageDonationPerDonor.toInt())} ";
      summaryData[1].icon =
          "${"currency".tr} ${Utils.getCurrency(summary.refundedDonations.toInt())} ";
      summaryData.refresh();
    } else {
      Utils.handleAPIError(apiResponse);
    }
  }

  Future fetchDonations({bool topProject = false}) async {
    Map<String, dynamic>? queryParameters = {
      "accountId": id,
      "startDate": Utils.newDateFormat.format(selectedDateRange!.start),
      "endDate": Utils.newDateFormat.format(selectedDateRange!.end),
      if (projectId != null) "projectId": projectId
    };
    ApiResponse apiResponse = await repo.fetchProjects(
        request: RequestBody(
            endPoint: ApiConstant.associationDonations,
            queryParameters: queryParameters));
    if (apiResponse.appState == AppState.onSuccess) {
      if (topProject) {
        topProjects.value = apiResponse.data;
      } else {
        donations.value = apiResponse.data;
      }
    } else {
      Utils.handleAPIError(apiResponse);
    }
  }

  Future fetchDonorPercentage() async {
    Map<String, dynamic>? queryParameters = {
      "accountId": id,
      "startDate": Utils.newDateFormat.format(selectedDateRange!.start),
      "endDate": Utils.newDateFormat.format(selectedDateRange!.end),
      if (projectId != null) "projectId": projectId
    };
    ApiResponse apiResponse = await repo.fetchDonorPercentage(
        request: RequestBody(
            endPoint: ApiConstant.donorPercentage,
            queryParameters: queryParameters));
    if (apiResponse.appState == AppState.onSuccess) {
      List<PieChartData> data = apiResponse.data;
      _updatePieChartData(data);
    } else {
      Utils.handleAPIError(apiResponse);
    }
  }

  void _updatePieChartData(List<PieChartData> data) {
    final first = data.firstWhereOrNull((e) => e.donorType == "First Time Donor");
    final returning = data.firstWhereOrNull((e) => e.donorType == "Returning Donor");

    pieChartData[0].value = first?.donorCount.toString() ?? "0";
    pieChartData[0].valueInDouble = first?.percentage.toDouble() ?? 0;
    pieChartData[1].value = returning?.donorCount.toString() ?? "0";
    pieChartData[1].valueInDouble = returning?.percentage.toDouble() ?? 0;

    pieChartData.refresh();
  }

  Future fetchLineChartData() async {
    Map<String, dynamic>? queryParameters = {
      "accountId": id,
      "startDate": Utils.newDateFormat.format(selectedDateRange!.start),
      "endDate": Utils.newDateFormat.format(selectedDateRange!.end),
      if (projectId != null) "projectId": projectId
    };
    ApiResponse apiResponse = await repo.areaChartDonationDataAssociationDashboard(request: RequestBody(queryParameters: queryParameters));
    if (apiResponse.appState == AppState.onSuccess) {
      List<LineChartModel> data = apiResponse.data;
      List<fl.FlSpot> flSpot = [];
      for (int i = 0; i < data.length; i++) {
        flSpot.add(fl.FlSpot(i.toDouble(), data[i].donationAmount));
      }
      months.value = data.map((item) => item.monthName).toList();
      spots.value = flSpot;
    } else {
      Utils.handleAPIError(apiResponse);
    }
  }

  Future fetchProjects() async {
    final result = await getAssociationProjects(id);
    if(result!=null){
      association = result;
      allProjects = association.projects;
      List<String> stringProjectList = allProjects.map((project) => Utils.isArabic ? project.projectNameArabic : project.projectName).toSet().toList();
      projectList.addAll(stringProjectList);
      projectList.refresh();
    }
  }

  datePicker() async {
    DateTimeRange? newDateRange = await Utils.dateRangePicker(
        selectedDateRange, dateTimeRange, DateTime(currentDate.year + 50));
    if (newDateRange != null) {
      selectedDateRange = newDateRange;
      dateRangeController.text =
          "${Utils.dateFormat1.format(selectedDateRange!.start)} - ${Utils.dateFormat1.format(selectedDateRange!.end)}";
      _fetchDashboardData();
    }
  }

  onProjectSelected(String value) {
    selectedProject.value = value;
    if (selectedProject.value != "allProjects") {
      projectId = allProjects.firstWhere((project) {
        String name =
            Utils.isArabic ? project.projectNameArabic : project.projectName;
        return selectedProject.value == name;
      }).projectId;
    } else {
      projectId = null;
    }
    _fetchDashboardData();
  }

  openProjectDetails(int projectId) {
    Get.toNamed(
      AppRoutes.projectDetailsScreen,
      arguments: {"projectId": projectId, "isPreview": false},
    );
  }

  @override
  void onClose() {
    dateRangeController.dispose();

    donations.close();
    topProjects.close();
    pieChartData.close();
    dashboardData.close();
    summaryData.close();
    spots.close();
    months.close();
    projectList.close();
    selectedProject.close();

    super.onClose();
  }

}
