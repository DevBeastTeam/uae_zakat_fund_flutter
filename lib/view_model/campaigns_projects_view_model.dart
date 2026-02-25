import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/data/response/app_state.dart';
import 'package:zakat_fund/data/response/network_response.dart';
import 'package:zakat_fund/model/campaign_funding_gap.dart';
import 'package:zakat_fund/model/campaign_project_header_data.dart';
import 'package:zakat_fund/model/dashboard_data.dart';
import 'package:zakat_fund/model/projects_reaching_end.dart';
import 'package:zakat_fund/model/request_body.dart';
import 'package:zakat_fund/model/top_performing_projects.dart';
import 'package:zakat_fund/repository/campaigns_projects_repo.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_resources.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/utils/constants/event_constant.dart';
import 'package:zakat_fund/utils/mixins/generic_mixin.dart';
import 'package:zakat_fund/utils/utils.dart';

class CampaignsAndProjectsViewModel extends GetxController
    with GetTickerProviderStateMixin, GenericMixin {
  late TabController tabController;
  final TextEditingController dateRange = TextEditingController();
  RxInt currentTabIndex = 0.obs;

  late DateTime currentDate;
  late DateTimeRange dateTimeRange;
  DateTimeRange? selectedDateRange;

  final CampaignsProjectsRepoImpl repo = CampaignsProjectsRepoImpl();

  final RxList<DashboardData> dashboardData = <DashboardData>[
    DashboardData(
        title: "activeProjects",
        value: "0",
        icon: AppResources.totalProjectsIcon,
        backColor: AppColors.lightBlueColor1,
        style: AppTextStyle.darkBlue16spTextStyle),
    DashboardData(
        title: "campaignSuccessRate",
        value: "0",
        icon: AppResources.campaignRateIcon,
        backColor: AppColors.lightPurpleColor,
        style: AppTextStyle.darkPurple16spTextStyle),
    DashboardData(
        title: "completedProjects",
        value: "0%",
        icon: AppResources.completedProjectsIcon,
        backColor: AppColors.lightGreenColor1,
        style: AppTextStyle.darkGreenColor16spTextStyle),
  ].obs;

  final RxList<TopPerformingProjects> topPerformingProjects = <TopPerformingProjects>[].obs;
  final RxList<CampaignFundingGap> campaignFundingGap = <CampaignFundingGap>[].obs;
  final RxList<ProjectsReachingEnd> projectsReachingEnd = <ProjectsReachingEnd>[].obs;

  @override
  onInit() {
    _initializeData();
    super.onInit();
  }

  _initializeData() {
    Utils.logEvent(name: EventConstant.campaignsProjectsDashboardScreen);
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
        fetchTopPerformingProjects(),
        fetchCampaignFundingGap(),
        fetchProjectsReachingEnd(),
      ]);
    }finally{
      Utils.hideLoadingDialog();
    }
  }

  Future fetchHeaderData() async {
    final result = await getHeaderData(_queryParameters());
    if(result!=null){
      CampaignAndProjectsHeaderData headerData = result;
      dashboardData[0].value = "${headerData.activeProjects}";
      dashboardData[1].value = "${headerData.campaignSuccessRate}";
      dashboardData[2].value = "${headerData.completedProjectsPercentage}%";
      dashboardData.refresh();
    }
  }

  Future fetchTopPerformingProjects() async {
    ApiResponse apiResponse = await repo.fetchTopPerformingProjects(
        request: RequestBody(queryParameters: _queryParameters()));
    if (apiResponse.appState == AppState.onSuccess) {
      topPerformingProjects.value = apiResponse.data;
    } else {
      Utils.handleAPIError(apiResponse);
    }
  }

  Future fetchCampaignFundingGap() async {
    ApiResponse apiResponse = await repo.fetchCampaignFundingGap(
        request: RequestBody(queryParameters: _queryParameters()));
    if (apiResponse.appState == AppState.onSuccess) {
      campaignFundingGap.value = apiResponse.data;
    } else {
      Utils.handleAPIError(apiResponse);
    }
  }

  Future fetchProjectsReachingEnd() async {
    ApiResponse apiResponse = await repo.fetchProjectsReachingEnd(
        request: RequestBody(queryParameters: _queryParameters()));
    if (apiResponse.appState == AppState.onSuccess) {
      projectsReachingEnd.value = apiResponse.data;
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

  Map<String, dynamic> _queryParameters() => {
        'startDate': Utils.newDateFormat.format(selectedDateRange!.start),
        'endDate': Utils.newDateFormat.format(selectedDateRange!.end),
      };

  @override
  void onClose() {
    tabController.removeListener(_tabListener);
    tabController.dispose();
    dateRange.dispose();

    currentTabIndex.close();
    dashboardData.close();
    topPerformingProjects.close();
    campaignFundingGap.close();
    projectsReachingEnd.close();

    super.onClose();
  }

}
