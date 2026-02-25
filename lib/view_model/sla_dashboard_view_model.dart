import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/data/response/app_state.dart';
import 'package:zakat_fund/data/response/network_response.dart';
import 'package:zakat_fund/model/base_api_model.dart';
import 'package:zakat_fund/model/compliance_per_workflow.dart';
import 'package:zakat_fund/model/donor_demographic.dart';
import 'package:zakat_fund/model/request_body.dart';
import 'package:zakat_fund/model/requests.dart';
import 'package:zakat_fund/model/sla_by_approver_group.dart';
import 'package:zakat_fund/model/stats_data.dart';
import 'package:zakat_fund/repository/requests_repo.dart';
import 'package:zakat_fund/repository/sla_dashboard_repo.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/utils/constants/event_constant.dart';
import 'package:zakat_fund/utils/utils.dart';

class SLADashboardViewModel extends GetxController {

  final repo = SlaDashboardRepoImpl();
  final requestsRepo = RequestsRepoImpl();

  final scrollController = ScrollController();
  final dateRange = TextEditingController();

  RxList<StatsData> stats = [
    StatsData(
        title: "totalRequests",
        value: "0",
        titleStyle: AppTextStyle.darkPinkColor12spTextStyle,
        valueStyle: AppTextStyle.darkPink16spTextStyle1,
        backgroundColor: AppColors.darkPinkColor),
    StatsData(
        title: "onTrackRequests",
        value: "0%",
        titleStyle: AppTextStyle.darkGreen12spTextStyle,
        valueStyle: AppTextStyle.darkGreenColor16spTextStyle5,
        backgroundColor: AppColors.darkGreenColor1),
    StatsData(
        title: "breachedRequests",
        value: "0%",
        titleStyle: AppTextStyle.darkPurple12spTextStyle3,
        valueStyle: AppTextStyle.darkOrange16spTextStyle1,
        backgroundColor: AppColors.darkOrangeColor),
    StatsData(
        title: "escalationRate",
        value: "0%",
        titleStyle: AppTextStyle.darkPurple12spTextStyle,
        valueStyle: AppTextStyle.darkPurple16spTextStyle1,
        backgroundColor: AppColors.darkPurpleColor),
  ].obs;

  RxList<Requests> requests = <Requests>[].obs;
  RxList<DonorDemographic> workflowSpots = <DonorDemographic>[].obs;
  RxList<DonorDemographic> levelsSpots = <DonorDemographic>[].obs;
  RxList<DonorDemographic> groupsSpots = <DonorDemographic>[].obs;

  RxList<String> workFlowMonths = <String>[].obs;
  RxList<String> levelsMonths = <String>[].obs;
  RxList<String> groupsMonths = <String>[].obs;

  int currentPage = 1;
  int pageSize = 10;
  int totalRecords = 0;

  DateTime currentDate = DateTime.now();
  late DateTimeRange dateTimeRange;
  DateTimeRange? selectedDateRange;

  @override
  void onInit() {
    _initializeData();
    super.onInit();
  }

  _initializeData() {
    Utils.logEvent(name: EventConstant.slaComplianceDashboardScreen);
    dateTimeRange = DateTimeRange(
      start: currentDate.subtract(Duration(days: 1)),
      end: currentDate,
    );
    selectedDateRange = DateTimeRange(
        start:
            DateTime(currentDate.year, currentDate.month - 1, currentDate.day),
        end: currentDate);
    dateRange.text =
        "${Utils.dateFormat1.format(selectedDateRange!.start)} - ${Utils.dateFormat1.format(selectedDateRange!.end)}";

    scrollController.addListener(_scrollListener);
    _fetchData();
  }

  _scrollListener() async {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      if (requests.length == totalRecords) {
        return;
      }
      currentPage++;
      Utils.showLoadingDialog();
      await fetchAllRequests();
      Utils.hideLoadingDialog();
    }
  }

  _fetchData() async {
    try{
      Utils.showLoadingDialog();
      await Future.wait([
        fetchHeaderData(),
        fetchCompliancePerWorkflow(),
        fetchSLAByApproversGroups(),
        fetchBreakdownByLevel(),
        fetchAllRequests(),
      ]);
    }finally{
      Utils.hideLoadingDialog();
    }
  }

  Future fetchHeaderData() async {
    ApiResponse apiResponse = await repo.adminDashboardSLAGetHeaderData(
        request: RequestBody(queryParameters: _queryParameters()));
    if (apiResponse.appState == AppState.onSuccess) {
      Stats statsData = apiResponse.data;
      stats[0].value = "${statsData.totalRequests}";
      stats[1].value = "${statsData.onTrackRate}%";
      stats[2].value = "${statsData.breachedRate}%";
      stats[3].value = "${statsData.escalationRate}%";
      stats.refresh();
    } else {
      Utils.handleAPIError(apiResponse);
    }
  }

  Future fetchCompliancePerWorkflow() async {
    ApiResponse apiResponse =
        await repo.adminDashboardGetSLADetailsPerWorkflowType(
            request: RequestBody(queryParameters: _queryParameters()));
    if (apiResponse.appState == AppState.onSuccess) {
      List<SlaCompliancePerWorkflow> workflow = apiResponse.data;
      workFlowMonths.clear();
      workflowSpots.clear();
      for (SlaCompliancePerWorkflow data in workflow) {
        workFlowMonths.add(Utils.toCamelCase(data.workflowType).tr);
        workflowSpots.add(
          DonorDemographic(
              countryResidenceId: 0,
              countryName: "",
              countryNameArabic: "",
              male: data.onTrack,
              female: data.breached,
              ageGroup: ""),
        );
      }
      workFlowMonths.refresh();
      workflowSpots.refresh();
    } else {
      Utils.handleAPIError(apiResponse);
    }
  }

  Future fetchSLAByApproversGroups() async {
    ApiResponse apiResponse =
        await repo.adminDashboardGetSLADetailsPerWorkflowApproverGroup(
            request: RequestBody(queryParameters: _queryParameters()));
    if (apiResponse.appState == AppState.onSuccess) {
      List<SlaByApproversGroups> approverGroups = apiResponse.data;
      groupsMonths.clear();
      groupsSpots.clear();
      for (SlaByApproversGroups group in approverGroups) {
        groupsMonths
            .add(Utils.isArabic ? group.groupNameAr : group.groupNameEn);
        groupsSpots.add(
          DonorDemographic(
              countryResidenceId: 0,
              countryName: "",
              countryNameArabic: "",
              male: group.onTrack,
              female: group.breached,
              ageGroup: ""),
        );
      }
      groupsMonths.refresh();
      groupsSpots.refresh();
    } else {
      Utils.handleAPIError(apiResponse);
    }
  }

  Future fetchBreakdownByLevel() async {
    ApiResponse apiResponse =
        await repo.adminDashboardGetSLADetailsPerWorkflowLevel(
            request: RequestBody(queryParameters: _queryParameters()));
    if (apiResponse.appState == AppState.onSuccess) {
      List<SlaCompliancePerWorkflow> workflow = apiResponse.data;
      levelsMonths.clear();
      levelsSpots.clear();
      for (SlaCompliancePerWorkflow data in workflow) {
        levelsMonths.add(
            "${Utils.toCamelCase(data.workflowType).tr} (${data.levelId})");
        levelsSpots.add(
          DonorDemographic(
              countryResidenceId: 0,
              countryName: "",
              countryNameArabic: "",
              male: data.onTrack,
              female: data.breached,
              ageGroup: ""),
        );
      }
      levelsMonths.refresh();
      levelsSpots.refresh();
    } else {
      Utils.handleAPIError(apiResponse);
    }
  }

  Future fetchAllRequests({bool clear = false}) async {
    if (clear) {
      currentPage = 1;
    }
    Map<String, dynamic>? queryParameters = _queryParameters()
      ..addAll({"pageNumber": currentPage, "pageSize": pageSize});
    ApiResponse apiResponse = await requestsRepo.fetchAllUserRequests(
        request: RequestBody(queryParameters: queryParameters));
    if (apiResponse.appState == AppState.onSuccess) {
      BaseApiModel baseApiModel = apiResponse.data;
      totalRecords = baseApiModel.totalRecords;
      List<Requests> requestData = List<Requests>.from(
          baseApiModel.data.map((x) => Requests.fromJson(x)));
      if (clear) {
        requests.value = requestData;
      } else {
        requests.addAll(requestData);
      }
      requests.refresh();
    } else {
      Utils.logInAgain();
    }
  }

  datePicker() async {
    DateTimeRange? newDateRange = await Utils.dateRangePicker(
        selectedDateRange, dateTimeRange, DateTime(currentDate.year + 50));
    if (newDateRange != null) {
      selectedDateRange = newDateRange;
      dateRange.text =
          "${Utils.dateFormat1.format(selectedDateRange!.start)} - ${Utils.dateFormat1.format(selectedDateRange!.end)}";
      requests.clear();
      currentPage = 1;
      _fetchData();
    }
  }

  Map<String, dynamic> _queryParameters() => {
        "startDate": Utils.newDateFormat.format(selectedDateRange!.start),
        "endDate": Utils.newDateFormat.format(selectedDateRange!.end)
      };

  @override
  void onClose() {
    scrollController.removeListener(_scrollListener);
    scrollController.dispose();
    dateRange.dispose();

    stats.close();
    requests.close();
    workflowSpots.close();
    levelsSpots.close();
    groupsSpots.close();
    workFlowMonths.close();
    levelsMonths.close();
    groupsMonths.close();
    super.onClose();
  }

}