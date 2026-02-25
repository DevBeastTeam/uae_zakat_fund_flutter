import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/model/admin_dashbaord_data.dart';
import 'package:zakat_fund/model/dashboard_data.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/event_constant.dart';
import 'package:zakat_fund/utils/mixins/generic_mixin.dart';
import 'package:zakat_fund/utils/utils.dart';

class AdminAndOperationsViewModel extends GetxController with GenericMixin {
  final dateRange = TextEditingController();

  late DateTimeRange dateTimeRange;
  late DateTime currentDate;
  DateTimeRange? selectedDateRange;

  RxList<DashboardData> associationsChart = <DashboardData>[].obs;
  RxList<DashboardData> requestsChart = <DashboardData>[].obs;
  RxList<DashboardData> companiesChart = <DashboardData>[].obs;
  RxList<DashboardData> projectsChart = <DashboardData>[].obs;
  RxList<DashboardData> employeesChart = <DashboardData>[].obs;

  RxString totalAssociations = "0".obs;
  RxString totalRequests = "0".obs;
  RxString totalCompanies = "0".obs;
  RxString totalProjects = "0".obs;
  RxString totalEmployees = "0".obs;

  @override
  onInit() {
    _initializeData();
    super.onInit();
  }

  _initializeData() {
    Utils.logEvent(name: EventConstant.adminOperationsDashboardScreen);
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
    fetchData();
  }

  fetchData() async {
    Utils.showLoadingDialog();
    Map<String, dynamic>? queryParameters = {
      "startDate": Utils.newDateFormat.format(selectedDateRange!.start),
      "endDate": Utils.newDateFormat.format(selectedDateRange!.end),
    };
    final result = await getAdminOperationsDashboardData(queryParameters);
    Utils.hideLoadingDialog();
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


      totalRequests.value = '${data.totalRequests}';
      requestsChart.value = Utils.buildChartData(
          [
            data.approvedRequests,
            data.pendingRequests,
            data.returnedRequests,
            data.rejectedRequests
          ],
          data.totalRequests,
          [
            AppColors.lightBrownColor,
            AppColors.pendingColor,
            AppColors.maleColor,
            AppColors.darkRedColor
          ],
          ['approved', 'pending','returned', 'rejected']);

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
          [
            data.completedProjects,
            data.activeProjects,
            data.inactiveProjects
          ],
          data.totalProjects,
          [
            AppColors.lightBrownColor,
            AppColors.fullRefundColor,
            AppColors.darkPinkColor
          ],
          ['completed', 'active', 'inactive']);


      totalEmployees.value = '${data.totalEmployees}';
      employeesChart.value = Utils.buildChartData(
          [
            data.activeEmployees,
            data.inactiveEmployees
          ],
          data.totalEmployees,
          [
            AppColors.fullRefundColor,
            AppColors.darkPinkColor
          ],
          ['active', 'inactive']);

    }

  }

  datePicker() async {
    DateTimeRange? newDateRange = await Utils.dateRangePicker(
        selectedDateRange, dateTimeRange, currentDate);
    if (newDateRange != null) {
      selectedDateRange = newDateRange;
      dateRange.text =
          "${Utils.dateFormat1.format(selectedDateRange!.start)} - ${Utils.dateFormat1.format(selectedDateRange!.end)}";
      fetchData();
    }
  }

  @override
  void onClose() {
    associationsChart.close();
    requestsChart.close();
    companiesChart.close();
    projectsChart.close();
    employeesChart.close();
    totalAssociations.close();
    totalRequests.close();
    totalCompanies.close();
    totalProjects.close();
    totalEmployees.close();

    super.onClose();
  }

}
