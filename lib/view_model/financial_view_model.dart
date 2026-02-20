import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/data/response/app_state.dart';
import 'package:zakat_fund/data/response/network_response.dart';
import 'package:zakat_fund/model/association_dashboard_data.dart';
import 'package:zakat_fund/model/dashboard_data.dart';
import 'package:zakat_fund/model/payment_method_history.dart';
import 'package:zakat_fund/model/request_body.dart';
import 'package:zakat_fund/repository/financial_dashboard_repo.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_resources.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/utils/constants/event_constant.dart';
import 'package:zakat_fund/utils/mixins/generic_mixin.dart';
import 'package:zakat_fund/utils/utils.dart';

class FinancialDashboardViewModel extends GetxController with GenericMixin {

  final dateRange = TextEditingController();

  late DateTime currentDate;
  late DateTimeRange dateTimeRange;
  DateTimeRange? selectedDateRange;

  final RxList<DashboardData> dashboardData = [
    DashboardData(
      title: "totalRevenue",
      value: "${"currency".tr} 0",
      icon: AppResources.totalRevenueIcon,
      backColor: AppColors.lightBlueColor1,
      style: AppTextStyle.darkBlue16spTextStyle,
    ),
    DashboardData(
      title: "availableBalance",
      value: "${"currency".tr} 0",
      icon: AppResources.availableBalanceIcon1,
      backColor: AppColors.lightPurpleColor,
      style: AppTextStyle.darkPurple16spTextStyle,
    ),
    DashboardData(
      title: "transferredAmount",
      value: "${"currency".tr} 0",
      icon: AppResources.targetedAmountIcon,
      backColor: AppColors.lightGreenColor2,
      style: AppTextStyle.darkGreenColor16spTextStyle1,
    ),
    DashboardData(
      title: "pendingTransfers",
      value: "${"currency".tr} 0",
      icon: AppResources.pendingTransfersIcon,
      backColor: AppColors.lightOrangeColor,
      style: AppTextStyle.darkOrange16spTextStyle,
    ),
  ].obs;

  final RxList<DashboardData> paymentMethodsChart = <DashboardData>[].obs;
  final RxList<DashboardData> pendingCollectionsChart = <DashboardData>[].obs;
  final RxString pendingCollections = "0".obs;

  final repo = FinancialDashboardRepoImpl();

  @override
  onInit() {
    _initializeData();
    super.onInit();
  }

  _initializeData() {
    Utils.logEvent(name: EventConstant.financialDataDashboardScreen);
    currentDate = DateTime.now();
    dateTimeRange = DateTimeRange(
      start: currentDate.subtract(Duration(days: 1)),
      end: currentDate,
    );
    selectedDateRange = DateTimeRange(
        start: DateTime(currentDate.year, currentDate.month - 2, currentDate.day),
        end: currentDate);
    dateRange.text = "${Utils.dateFormat1.format(selectedDateRange!.start)} - ${Utils.dateFormat1.format(selectedDateRange!.end)}";

    _fetchDashboardData();
  }

  _fetchDashboardData() async {
    try{
      Utils.showLoadingDialog();
      await Future.wait([
        fetchHeaderData(),
        fetchPaymentMethods(),
        fetchPendingCollections(),
      ]);
    }finally{
      Utils.hideLoadingDialog();
    }
  }

  Future fetchHeaderData() async {
    final result = await getAdminDashboardGetHeaderDataFDD(_queryParameters());
    if(result!=null){
      AssociationAverageSummary summary = result;
      dashboardData[0].value =
      "${"currency".tr} ${Utils.getCurrency(summary.totalDonations.toInt())}";
      dashboardData[1].value =
      "${"currency".tr} ${Utils.getCurrency(summary.availableBalance.toInt())}";
      dashboardData[2].value =
      "${"currency".tr} ${Utils.getCurrency(summary.transferredAmount.toInt())}";
      dashboardData[3].value =
      "${"currency".tr} ${Utils.getCurrency(summary.pendingTransfers.toInt())}";
      dashboardData.refresh();
    }
  }

  Future fetchPaymentMethods() async {
    ApiResponse apiResponse =
    await repo.adminDashboardGetDonationsWRTPaymentTypeFDD(request: RequestBody(queryParameters: _queryParameters()));
    if (apiResponse.appState == AppState.onSuccess) {
      List<PaymentMethodHistory> history = apiResponse.data;
      if (history.isEmpty) {
        paymentMethodsChart.clear();
        return;
      }
      _processData(
        history: history,
        chartData: paymentMethodsChart,
        totalValue: RxString("0"),
      );
    } else {
      Utils.handleAPIError(apiResponse);
    }
  }

  Future fetchPendingCollections() async {
    ApiResponse apiResponse =
        await repo.adminDashboardGetPendingCollectionDataFDD(
            request: RequestBody(queryParameters: _queryParameters()));
    if (apiResponse.appState == AppState.onSuccess) {
      List<PaymentMethodHistory> history = apiResponse.data;
      if (history.isEmpty) {
        pendingCollectionsChart.clear();
        pendingCollections.value = "0";
        return;
      }
      _processData(
        history: history,
        chartData: pendingCollectionsChart,
        totalValue: pendingCollections,
      );
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
      _fetchDashboardData();
    }
  }

  void _processData({
    required List<PaymentMethodHistory> history,
    required RxList<DashboardData> chartData,
    required RxString totalValue,
  }) {
    double totalBalance =
        history.fold(0.0, (sum, item) => sum + item.totalAmount);
    totalValue.value = totalBalance.toInt().toString();

    chartData.value = history.map((data) {
      double ratio = totalBalance > 0 ? data.totalAmount / totalBalance : 0;
      return DashboardData(
        title: data.paymentType,
        value: data.totalAmount.toInt().toString(),
        valueInDouble: ratio,
        backColor: Utils.getPaymentMethodColorByName(data.paymentType),
      );
    }).toList();
  }

  Map<String, dynamic> _queryParameters() => {
    'startDate': Utils.newDateFormat.format(selectedDateRange!.start),
    'endDate': Utils.newDateFormat.format(selectedDateRange!.end),
  };

  @override
  void onClose() {
    dateRange.dispose();

    dashboardData.close();
    paymentMethodsChart.close();
    pendingCollectionsChart.close();
    pendingCollections.close();
    super.onClose();
  }

}
