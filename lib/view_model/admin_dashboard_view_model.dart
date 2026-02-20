import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/model/admin_dashbaord_data.dart';
import 'package:zakat_fund/model/association_dashboard_data.dart';
import 'package:zakat_fund/model/campaign_project_header_data.dart';
import 'package:zakat_fund/model/dashboard_data.dart';
import 'package:zakat_fund/model/donor_header_data.dart';
import 'package:zakat_fund/model/engagemnt_interaction.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/utils/constants/event_constant.dart';
import 'package:zakat_fund/utils/mixins/generic_mixin.dart';
import 'package:zakat_fund/utils/utils.dart';

class AdminDashboardViewModel extends GetxController with GenericMixin {
  final dateRange = TextEditingController();

  DateTimeRange? selectedDateRange;
  late final DateTime currentDate;
  late final DateTimeRange dateTimeRange;

  RxString totalAssociations = '0'.obs;
  RxString totalCompanies = '0'.obs;
  RxString totalProjects = '0'.obs;

  RxList<DashboardData> associationsChart = <DashboardData>[].obs;
  RxList<DashboardData> companiesChart = <DashboardData>[].obs;
  RxList<DashboardData> projectsChart = <DashboardData>[].obs;
  RxList<PreferredLoginPeriod> preferredLoginPeriod = <PreferredLoginPeriod>[].obs;
  RxList<PreferredLoginDay> preferredLoginDay = <PreferredLoginDay>[].obs;

  RxList<DashboardData> financialData = <DashboardData>[
    DashboardData(
        title: "totalDonations",
        value: "totalDonationsSubMessage".tr,
        icon: "${"currency".tr} 0 ",
        backColor: AppColors.lightBlueColor1,
        style: AppTextStyle.darkBlue16spTextStyle),
    DashboardData(
        title: "availableBalance",
        value: "availableBalanceSubMessage".tr,
        icon: "${"currency".tr} 0 ",
        backColor: AppColors.lightPurpleColor,
        style: AppTextStyle.darkPurple16spTextStyle),
  ].obs;

  RxList<DashboardData> donationsData = <DashboardData>[
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

  RxList<DashboardData> campaignAndProjectsData = [
    DashboardData(
        title: "activeProjects",
        value: "currentlyActiveProjects".tr,
        icon: "0 ",
        backColor: AppColors.lightBlueColor1,
        style: AppTextStyle.darkBlue16spTextStyle),
    DashboardData(
        title: "campaignSuccessRate",
        value: "reachedFundingTarget".tr,
        icon: "0 ",
        backColor: AppColors.lightPurpleColor,
        style: AppTextStyle.darkPurple16spTextStyle),
    DashboardData(
        title: "completedProjects",
        value: "successfullyMetFundingTarget".tr,
        icon: "0% ",
        backColor: AppColors.lightGreenColor1,
        style: AppTextStyle.darkGreenColor16spTextStyle),
  ].obs;

  RxList<DashboardData> donorsData = [
    DashboardData(
        title: "totalDonors",
        value: "donorsOnPlatform".tr,
        icon: "0 ",
        backColor: AppColors.lightBlueColor1,
        style: AppTextStyle.darkBlue16spTextStyle),
    DashboardData(
        title: "activeDonors",
        value: "donationLastMonth".tr,
        icon: "0 ",
        backColor: AppColors.lightPurpleColor,
        style: AppTextStyle.darkPurple16spTextStyle),
    DashboardData(
        title: "donorRetentionRate",
        value: "secondDonation".tr,
        icon: "0 ",
        backColor: AppColors.lightGreenColor2,
        style: AppTextStyle.darkGreenColor16spTextStyle1),
  ].obs;

  RxList<DashboardData> userEngagementData = [
    DashboardData(
        title: "preferredLoginPeriod",
        value: "",
        backColor: AppColors.lightPurpleColor,
        style: AppTextStyle.darkPurple16spTextStyle),
    DashboardData(
        title: "preferredLoginDay",
        value: "",
        backColor: AppColors.lightGreenColor1,
        style: AppTextStyle.darkGreenColor16spTextStyle1),
  ].obs;
  RxList<DashboardData> lowestActivityTime = <DashboardData>[
    DashboardData(
        title: "weekdays",
        value: "",
        icon: "0 ${"logins".tr}",
        backColor: AppColors.lightGreenColor3,
        style: AppTextStyle.darkGreenColor16spTextStyle2),
    DashboardData(
        title: "weekends",
        value: "",
        icon: "0 ${"logins".tr}",
        backColor: AppColors.lightRedColor3,
        style: AppTextStyle.darkRed16spTextStyle)
  ].obs;

  RxList<DashboardData> activityChartData = <DashboardData>[
    DashboardData(
        title: 'weekdayLogin',
        value: '0',
        valueInDouble: 0.0,
        backColor: AppColors.lightBrownColor2),
    DashboardData(
        title: 'weekendLogin',
        value: '0',
        valueInDouble: 0.0,
        backColor: AppColors.lightYellowColor1),
  ].obs;

  @override
  void onInit() {
    _initializeData();
    super.onInit();
  }

  _initializeData() {
    Utils.logEvent(name: EventConstant.adminDashboardScreen);
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

  _fetchData() async {
    try{
      Utils.showLoadingDialog();
      await Future.wait([
        fetchAdminAndOperationsData(),
        fetchFinancialData(),
        fetchDonationsData(),
        fetchCampaignAndProjectsData(),
        fetchDonorsData(),
        fetchUserEngagementData(),
      ]);
    }finally{
      Utils.hideLoadingDialog();
    }
  }

  Future fetchAdminAndOperationsData() async {
    final result = await getAdminOperationsDashboardData(_queryParameters());
    if(result!=null){
      AdminDashboardData data = result;
      totalAssociations.value = '${data.totalAssociations}';
      associationsChart.value = Utils.buildChartData(
          [
            data.approvedAssociations,
            data.pendingAssociations,
            data.rejectedAssociations
          ],
          data.totalAssociations,
          [
            AppColors.lightBrownColor,
            AppColors.pendingColor,
            AppColors.darkRedColor
          ],
          ['approved', 'pending', 'rejected']);
      totalCompanies.value = '${data.totalCompanies}';
      companiesChart.value = Utils.buildChartData(
          [
            data.approvedCompanies,
            data.pendingCompanies,
            data.rejectedCompanies
          ],
          data.totalCompanies,
          [
            AppColors.lightBrownColor,
            AppColors.pendingColor,
            AppColors.darkRedColor
          ],
          ['approved', 'pending', 'rejected']);
      totalProjects.value = '${data.totalProjects}';
      projectsChart.value = Utils.buildChartData(
          [data.completedProjects, data.activeProjects, data.inactiveProjects],
          data.totalProjects,
          [
            AppColors.lightBrownColor,
            AppColors.fullRefundColor,
            AppColors.darkPinkColor
          ],
          ['completed', 'active', 'inactive']);
  }
  }

  Future fetchFinancialData() async {
    final result = await getAdminDashboardGetHeaderDataFDD(_queryParameters());
    if(result!=null){
      AssociationAverageSummary summary = result;
      financialData[0].icon =
      "${"currency".tr} ${Utils.getCurrency(summary.totalDonations.toInt())} ";
      financialData[1].icon =
      "${"currency".tr} ${Utils.getCurrency(summary.availableBalance.toInt())} ";
      financialData.refresh();
    }
  }

  Future fetchDonationsData() async {
    final result = await getAverageDonations(_queryParameters());
    if(result!=null){
      AssociationAverageSummary summary = result;
      donationsData[0].icon =
      "${"currency".tr} ${Utils.getCurrency(summary.totalDonations.toInt())} ";
      donationsData[1].icon =
      "${"currency".tr} ${Utils.getCurrency(summary.averageDonationPerDonor.toInt())} ";
      donationsData[2].icon =
      "${"currency".tr} ${Utils.getCurrency(summary.refundedDonations.toInt())} ";
      donationsData.refresh();
    }
  }

  Future fetchCampaignAndProjectsData() async {
    final result = await getHeaderData(_queryParameters());
    if(result!=null){
      CampaignAndProjectsHeaderData headerData = result;
      campaignAndProjectsData.asMap().forEach((i, item) {
        item.icon = i == 2
            ? '${headerData.completedProjectsPercentage}% '
            : i == 0
            ? '${headerData.activeProjects} '
            : '${headerData.campaignSuccessRate} ';
      });
      campaignAndProjectsData.refresh();
    }
  }

  Future fetchDonorsData() async {
    final result = await getDonorHeaderData(_queryParameters());
    if(result!=null){
      DonorHeaderData donorHeaderData = result;
      donorsData[0].icon = "${donorHeaderData.totalDonor} ";
      donorsData[1].icon = "${donorHeaderData.activeDonor} ";
      donorsData[2].icon = "${donorHeaderData.returningDonor}% ";
      donorsData.refresh();
    }
  }

  Future fetchUserEngagementData() async {
    final result = await getAdminDashboardGetHeaderDataUEIDD(_queryParameters());
    if(result!=null){
      UserEngagementInteraction d = result;
      preferredLoginPeriod.value = d.preferredLoginPeriods;
      preferredLoginDay.value = d.preferredLoginDays;
      activityChartData.value = [
        DashboardData(
            title: 'weekdayLogin',
            value:
            '${d.weekdayWeekendLogins.firstWhereOrNull((e) => e.loginType == 'Weekdays Login')?.logins ?? 0}',
            valueInDouble: Utils.calculateRation(
                d.weekdayWeekendLogins
                    .firstWhereOrNull(
                        (e) => e.loginType == 'Weekdays Login')
                    ?.logins ??
                    0,
                2),
            backColor: AppColors.lightBrownColor2),
        DashboardData(
            title: 'weekendLogin',
            value:
            '${d.weekdayWeekendLogins.firstWhereOrNull((e) => e.loginType == 'Weekend Login')?.logins ?? 0}',
            valueInDouble: Utils.calculateRation(
                d.weekdayWeekendLogins
                    .firstWhereOrNull((e) => e.loginType == 'Weekend Login')
                    ?.logins ??
                    0,
                2),
            backColor: AppColors.lightYellowColor1),
      ];
      lowestActivityTime.value = [
        DashboardData(
            title: 'weekdays',
            value: d.lowestActivityTimesWeekdays.firstOrNull?.timeRange ?? '',
            icon:
            '${d.lowestActivityTimesWeekdays.firstOrNull?.logins ?? 0} ${'logins'.tr}',
            backColor: AppColors.lightGreenColor3,
            style: AppTextStyle.darkGreenColor16spTextStyle2),
        DashboardData(
            title: 'weekends',
            value: d.lowestActivityTimesWeekends.firstOrNull?.timeRange ?? '',
            icon:
            '${d.lowestActivityTimesWeekends.firstOrNull?.logins ?? 0} ${'logins'.tr}',
            backColor: AppColors.lightRedColor3,
            style: AppTextStyle.darkRed16spTextStyle),
      ];
    }
  }

  Map<String, dynamic> _queryParameters() => {
        'startDate': Utils.newDateFormat.format(selectedDateRange!.start),
        'endDate': Utils.newDateFormat.format(selectedDateRange!.end),
      };

  datePicker() async {
    DateTimeRange? newDateRange = await Utils.dateRangePicker(
        selectedDateRange, dateTimeRange, DateTime(currentDate.year + 50));
    if (newDateRange != null) {
      selectedDateRange = newDateRange;
      dateRange.text = "${Utils.dateFormat1.format(selectedDateRange!.start)} - ${Utils.dateFormat1.format(selectedDateRange!.end)}";
      _fetchData();
    }
  }

  @override
  void onClose() {
    dateRange.dispose();

    totalAssociations.close();
    totalCompanies.close();
    totalProjects.close();

    associationsChart.close();
    companiesChart.close();
    projectsChart.close();
    preferredLoginPeriod.close();
    preferredLoginDay.close();
    financialData.close();
    donationsData.close();
    campaignAndProjectsData.close();
    donorsData.close();
    userEngagementData.close();
    lowestActivityTime.close();
    activityChartData.close();

    super.onClose();
  }

}
