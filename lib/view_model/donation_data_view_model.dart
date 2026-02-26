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
import 'package:zakat_fund/model/top_associations.dart';
import 'package:zakat_fund/repository/donations_repo.dart';
import 'package:zakat_fund/repository/generic_repo.dart';
import 'package:zakat_fund/repository/home_repo.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/utils/constants/event_constant.dart';
import 'package:zakat_fund/utils/mixins/generic_mixin.dart';
import 'package:zakat_fund/utils/utils.dart';

class DonationDataViewModel extends GetxController with GenericMixin {
  final DonationsRepoImpl repo = DonationsRepoImpl();
  final GenericRepoImpl genericRepo = GenericRepoImpl();
  final HomeRepoImpl homeRepo = HomeRepoImpl();

  final RxInt totalDonations = 0.obs;
  final RxString totalDonors = "0".obs;
  final RxString selectedProject = "allProjects".obs;
  final RxString selectedAssociation = "allAssociations".obs;

  final RxList<DashboardData> pieChartData = <DashboardData>[].obs;
  final RxList<DashboardData> donorsBreakdownChart = <DashboardData>[].obs;

  final RxList<String> projectList = <String>["allProjects"].obs;
  final RxList<String> associationList = <String>["allAssociations"].obs;

  final RxList donationProjects = [].obs;
  final RxList topProjects = [].obs;
  final RxList topAssociations = [].obs;

  final RxList<fl.FlSpot> spots = <fl.FlSpot>[].obs;
  final RxList<String> months = <String>[].obs;

  final TextEditingController dateRange = TextEditingController();

  late final DateTime currentDate;
  late final DateTimeRange dateTimeRange;
  DateTimeRange? selectedDateRange;

  List<ProjectElements> allProjects = [];
  List<Project> allAssociations = [];
  int? projectId, associationId;

  RxList<DashboardData> summaryData = <DashboardData>[
    DashboardData(
        title: "totalDonations",
        value: "acrossAllProjects".tr,
        icon: "${"currency".tr} 0 ",
        backColor: AppColors.lightBlueColor1,
        style: AppTextStyle.darkBlue16spTextStyle),
    DashboardData(
        title: "averageDonationAmount",
        value: "perDonors".tr,
        icon: "${"currency".tr} 0 ",
        backColor: AppColors.lightGreenColor2,
        style: AppTextStyle.darkGreenColor16spTextStyle1),
    DashboardData(
        title: "refundedDonations",
        value: "refundOrCancelled".tr,
        icon: "${"currency".tr} 0 ",
        backColor: AppColors.lightPinkColor,
        style: AppTextStyle.darkPink16spTextStyle),
  ].obs;

  List<DashboardData> dashboardData = [
    DashboardData(
        title: "donations",
        value: "",
        backColor: AppColors.lightBlueColor1,
        style: AppTextStyle.darkBlue16spTextStyle),
    DashboardData(
        title: "top5Projects",
        value: "",
        backColor: AppColors.lightPurpleColor,
        style: AppTextStyle.darkPurple16spTextStyle),
    DashboardData(
        title: "top5Associations",
        value: "",
        backColor: AppColors.lightGreenColor1,
        style: AppTextStyle.darkGreenColor16spTextStyle1),
  ];

  @override
  onInit() {
    _initializeData();
    super.onInit();
  }

  _initializeData() {
    Utils.logEvent(name: EventConstant.donationsDataDashboardScreen);
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
    donorsBreakdownChart.value = [
      DashboardData(
        title: "companies",
        value: "0",
        valueInDouble: 0,
        backColor: AppColors.fullRefundColor,
      ),
      DashboardData(
        title: "individuals",
        value: "0",
        valueInDouble: 0,
        backColor: AppColors.cashColor,
      )
    ];
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
    _fetchData(init: true);
  }

  _fetchData({bool init = false}) async {
    try {
      Utils.showLoadingDialog();
      await Future.wait([
        fetchDonations(),
        fetchTop5Projects(),
        fetchTop5Associations(),
        fetchAverageDonations(),
        donorsBreakdown(),
        if (init) fetchProjects(),
        if (init) fetchAssociations(),
        fetchLineChartData(),
        fetchDonorSummary()
      ]);
    } finally {
      Utils.hideLoadingDialog();
    }
  }

  Future fetchDonations() async {
    ApiResponse apiResponse = await repo.fetchDonations(
        request: RequestBody(queryParameters: _queryParameters()));
    if (apiResponse.appState == AppState.onSuccess) {
      List<AssociationDonations> donations = apiResponse.data;
      donationProjects.value = donations
          .map((data) => {
                "key":
                    Utils.isArabic ? data.projectNameArabic : data.projectName,
                "value":
                    "${"currency".tr} ${Utils.getCurrency(data.collectedAmount.toInt())}"
              })
          .toList();
      totalDonations.value = donations.fold(
              0, (sum, proj) => sum! + proj.collectedAmount.toInt()) ??
          0;
    } else {
      Utils.handleAPIError(apiResponse);
    }
  }

  Future fetchTop5Projects() async {
    ApiResponse apiResponse = await repo.fetchTop5Projects(
        request: RequestBody(queryParameters: _queryParameters()));
    if (apiResponse.appState == AppState.onSuccess) {
      List<AssociationDonations> donations = apiResponse.data;
      topProjects.value = donations
          .map((data) => {
                "key":
                    Utils.isArabic ? data.projectNameArabic : data.projectName,
                "value":
                    "${"currency".tr} ${Utils.getCurrency(data.collectedAmount.toInt())}"
              })
          .toList();
    } else {
      Utils.handleAPIError(apiResponse);
    }
  }

  Future fetchTop5Associations() async {
    ApiResponse apiResponse = await repo.fetchTop5Associations(
        request: RequestBody(queryParameters: _queryParameters()));
    if (apiResponse.appState == AppState.onSuccess) {
      List<Top5Associations> association = apiResponse.data;
      topAssociations.value = association
          .map((data) => {
                "key": Utils.isArabic
                    ? data.associationNameArabic
                    : data.associationName,
                "value":
                    "${"currency".tr} ${Utils.getCurrency(data.collectedAmount.toInt())}"
              })
          .toList();
    } else {
      Utils.handleAPIError(apiResponse);
    }
  }

  Future fetchAverageDonations() async {
    final result = await getAverageDonations(_queryParameters());
    if (result != null) {
      AssociationAverageSummary summary = result;
      summaryData[0].icon =
          "${"currency".tr} ${Utils.getCurrency(summary.totalDonations.toInt())} ";
      summaryData[1].icon =
          "${"currency".tr} ${Utils.getCurrency(summary.averageDonationPerDonor.toInt())} ";
      summaryData[2].icon =
          "${"currency".tr} ${Utils.getCurrency(summary.refundedDonations.toInt())} ";
      summaryData.refresh();
    }
  }

  Future fetchDonorSummary() async {
    ApiResponse apiResponse = await repo.fetchDonorSummary(
        request: RequestBody(queryParameters: _queryParameters()));
    if (apiResponse.appState == AppState.onSuccess) {
      final List<PieChartData> data = apiResponse.data;
      _updatePieChartData(data, "First Time Donor", 0);
      _updatePieChartData(data, "Returning Donor", 1);
      pieChartData.refresh();
    } else {
      Utils.handleAPIError(apiResponse);
    }
  }

  Future donorsBreakdown() async {
    ApiResponse apiResponse = await repo.donorsBreakdown(
        request: RequestBody(queryParameters: _queryParameters()));
    if (apiResponse.appState == AppState.onSuccess) {
      final List<PieChartData> data = apiResponse.data;
      _updatePieChartData(data, "Companies", 0,
          targetList: donorsBreakdownChart);
      _updatePieChartData(data, "Individuals", 1,
          targetList: donorsBreakdownChart);
      totalDonors.value =
          data.fold(0, (sum, item) => sum + item.donorCount).toString();
      donorsBreakdownChart.refresh();
    } else {
      Utils.handleAPIError(apiResponse);
    }
  }

  void _updatePieChartData(List<PieChartData> data, String type, int index,
      {RxList<DashboardData>? targetList}) {
    final donor = data.firstWhereOrNull((d) => d.donorType == type);
    final list = targetList ?? pieChartData;
    list[index].value = donor?.donorCount.toString() ?? "0";
    list[index].valueInDouble = donor?.percentage.toDouble() ?? 0;
  }

  Future fetchLineChartData() async {
    ApiResponse apiResponse = await repo.donationDataMonthWiseAODD(
        request: RequestBody(queryParameters: _queryParameters()));
    if (apiResponse.appState == AppState.onSuccess) {
      List<LineChartModel> data = apiResponse.data;
      spots.clear();
      months.clear();
      for (int i = 0; i < data.length; i++) {
        spots.add(fl.FlSpot(i.toDouble(), data[i].donationAmount));
        months.add(data[i].monthName.toLowerCase().tr);
      }
      spots.refresh();
      months.refresh();
    } else {
      Utils.handleAPIError(apiResponse);
    }
  }

  datePicker() async {
    DateTimeRange? newDateRange = await Utils.dateRangePicker(
        selectedDateRange, dateTimeRange, currentDate);
    if (newDateRange != null) {
      selectedDateRange = newDateRange;
      dateRange.text =
          "${Utils.dateFormat1.format(selectedDateRange!.start)} - ${Utils.dateFormat1.format(selectedDateRange!.end)}";
      _fetchData();
    }
  }

  Future fetchProjects() async {
    ApiResponse apiResponse =
        await genericRepo.fetchAllProjects(request: RequestBody());
    if (apiResponse.appState == AppState.onSuccess) {
      allProjects = apiResponse.data;
      List<String> stringProjectList = allProjects
          .map((project) =>
              Utils.isArabic ? project.projectNameArabic : project.projectName)
          .toSet()
          .toList();
      projectList.addAll(stringProjectList);
      projectList.refresh();
    } else {
      Utils.handleAPIError(apiResponse);
    }
  }

  Future fetchAssociations() async {
    ApiResponse apiResponse =
        await homeRepo.fetchAssociations(request: RequestBody());
    if (apiResponse.appState == AppState.onSuccess) {
      allAssociations = apiResponse.data;
      List<String> stringProjectList = allAssociations
          .map((association) => Utils.isArabic
              ? association.accountNameArabic
              : association.accountName)
          .toSet()
          .toList();
      associationList.addAll(stringProjectList);
      associationList.refresh();
    } else if (apiResponse.appState == AppState.onFailure) {
      Utils.showGlobalSnackBar(message: apiResponse.message!);
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
    _fetchData();
  }

  onAssociationSelected(String value) {
    selectedAssociation.value = value;
    if (selectedAssociation.value != "allAssociations") {
      associationId = allAssociations.firstWhere((association) {
        String name = Utils.isArabic
            ? association.accountNameArabic
            : association.accountName;
        return selectedAssociation.value == name;
      }).accountId;
    } else {
      associationId = null;
    }
    _fetchData();
  }

  Map<String, dynamic> _queryParameters() => {
        "startDate": Utils.newDateFormat.format(selectedDateRange!.start),
        "endDate": Utils.newDateFormat.format(selectedDateRange!.end),
        if (projectId != null) "projectId": projectId,
        if (associationId != null) "associationId": associationId
      };

  @override
  void onClose() {
    dateRange.dispose();

    totalDonations.close();
    totalDonors.close();
    selectedProject.close();
    donorsBreakdownChart.close();
    selectedAssociation.close();
    pieChartData.close();
    projectList.close();
    associationList.close();
    donationProjects.close();
    topProjects.close();
    topAssociations.close();
    spots.close();
    months.close();
    summaryData.close();
    super.onClose();
  }
}
