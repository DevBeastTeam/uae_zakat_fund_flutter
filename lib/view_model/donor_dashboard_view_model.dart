import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/data/response/app_state.dart';
import 'package:zakat_fund/data/response/network_response.dart';
import 'package:zakat_fund/model/dashboard_data.dart';
import 'package:zakat_fund/model/donation_history.dart';
import 'package:zakat_fund/model/donor_dashboard_data.dart';
import 'package:zakat_fund/model/refund_history.dart';
import 'package:zakat_fund/model/request_body.dart';
import 'package:zakat_fund/model/user.dart';
import 'package:zakat_fund/my_app/my_app.dart';
import 'package:zakat_fund/repository/transaction_repo.dart';
import 'package:zakat_fund/utils/constants/api_constant.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_resources.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/utils/constants/event_constant.dart';
import 'package:zakat_fund/utils/utils.dart';

class DonorDashboardViewModel extends GetxController {
  final dateRange = TextEditingController();
  final repo = TransactionRepoImpl();

  final RxList<DashboardData> dashboardData = <DashboardData>[
    DashboardData(
      title: "numberOfProjectsDonated",
      value: "0",
      icon: AppResources.projectDonatedIcon,
      backColor: AppColors.lightPinkColor,
      style: AppTextStyle.darkPink16spTextStyle,
    ),
    DashboardData(
      title: "totalContribution",
      value: "${"currency".tr} 0",
      icon: AppResources.totalBeneficiariesIcon,
      backColor: AppColors.lightOrangeColor,
      style: AppTextStyle.darkOrange16spTextStyle,
    ),
    DashboardData(
      title: "totalBeneficiaries",
      value: "0",
      icon: AppResources.totalContributionIcon,
      backColor: AppColors.lightGreenColor1,
      style: AppTextStyle.darkGreenColor16spTextStyle,
    ),
    DashboardData(
      title: "totalRefund",
      value: "${"currency".tr} 0",
      icon: AppResources.totalRefundIcon,
      backColor: AppColors.lightPurpleColor,
      style: AppTextStyle.darkPurple16spTextStyle,
    ),
  ].obs;

  final RxList<DashboardData> donationHistoryChart = <DashboardData>[].obs;
  final RxList<DashboardData> refundHistoryChart = <DashboardData>[].obs;

  final RxString totalAmount = "0".obs;
  final RxString totalRefund = "0".obs;

  late final DateTime currentDate;
  late final DateTimeRange dateTimeRange;
  late DateTimeRange selectedDateRange;
  late final int id;
  late final User user;

  List<DonationHistory> donationHistory = [];
  List<RefundHistory> refundHistory = [];

  @override
  onInit() {
    _initializeData();
    super.onInit();
  }

  _initializeData() {
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
        "${Utils.dateFormat1.format(selectedDateRange.start)} - ${Utils.dateFormat1.format(selectedDateRange.end)}";
    user = userBox.getAt(0);
    id = user.roles.first == "Individuals" ? user.id : user.accountId ?? 0;
    Utils.logEvent(
      name: user.roles.first == "Individuals"
          ? EventConstant.donorDashboardScreen
          : EventConstant.companyDashboardScreen,
    );
    _fetchDashboardData();
  }

  _fetchDashboardData() async {
    try {
      Utils.showLoadingDialog();
      await Future.wait([
        fetchLatestDonations(),
        fetchRefundHistory(),
        fetchDashboardData(),
      ]);
    } finally {
      Utils.hideLoadingDialog();
    }
  }

  Future fetchDashboardData() async {
    Map<String, dynamic>? queryParameters = {
      "accountId": id,
      "startDate": Utils.newDateFormat.format(selectedDateRange.start),
      "endDate": Utils.newDateFormat.format(selectedDateRange.end),
    };
    ApiResponse apiResponse = await repo.donorDashboardData(
        request: RequestBody(
            endPoint: ApiConstant.transactions,
            queryParameters: queryParameters));
    if (apiResponse.appState == AppState.onSuccess) {
      DonorDashboardData donorDashboardData = apiResponse.data;
      dashboardData[0].value = "${donorDashboardData.numberOfProjectDonated}";
      dashboardData[1].value =
          "${"currency".tr} ${Utils.getCurrency(donorDashboardData.totalContribution.toInt())}";
      dashboardData[2].value = "${donorDashboardData.totalBeneficiaries}";
      dashboardData[3].value =
          "${"currency".tr} ${Utils.getCurrency(donorDashboardData.totalRefund.toInt())}";
      dashboardData.refresh();
    } else {
      Utils.handleAPIError(apiResponse);
    }
  }

  Future fetchLatestDonations() async {
    Map<String, dynamic>? queryParameters = {
      "accountId": id,
      "startDate": Utils.newDateFormat.format(selectedDateRange.start),
      "endDate": Utils.newDateFormat.format(selectedDateRange.end),
    };
    ApiResponse apiResponse = await repo.donationHistory(
        request: RequestBody(
            endPoint: ApiConstant.transactions,
            queryParameters: queryParameters));
    if (apiResponse.appState == AppState.onSuccess) {
      donationHistory = apiResponse.data;
      _processTransactionSummary(
        transactions: donationHistory,
        chartData: donationHistoryChart,
        totalValue: totalAmount,
        isRefund: false,
      );
    } else {
      Utils.handleAPIError(apiResponse);
    }
  }

  Future fetchRefundHistory() async {
    Map<String, dynamic>? queryParameters = {
      "accountId": id,
      "startDate": Utils.newDateFormat.format(selectedDateRange.start),
      "endDate": Utils.newDateFormat.format(selectedDateRange.end),
    };
    ApiResponse apiResponse = await repo.refundHistory(
        request: RequestBody(queryParameters: queryParameters));
    if (apiResponse.appState == AppState.onSuccess) {
      refundHistory = apiResponse.data;
      _processTransactionSummary(
        transactions: refundHistory,
        chartData: refundHistoryChart,
        totalValue: totalRefund,
        isRefund: true,
      );
    } else {
      Utils.handleAPIError(apiResponse);
    }
  }

  void _processTransactionSummary<T>({
    required List<T> transactions,
    required RxList<DashboardData> chartData,
    required RxString totalValue,
    required bool isRefund,
  }) {
    final Map<int, double> paymentSummary = {};

    for (dynamic transaction in transactions) {
      final int type = isRefund
          ? (transaction as RefundHistory).refundType
          : (transaction as DonationHistory).paymentType;
      final double amount =
          isRefund ? transaction.refundAmount : transaction.payment;

      paymentSummary.update(type, (value) => value + amount,
          ifAbsent: () => amount);
    }

    double totalBalance =
        paymentSummary.values.fold(0.0, (sum, amount) => sum + amount);
    totalValue.value = totalBalance.toInt().toString();

    chartData.value = paymentSummary.entries.map((entry) {
      double amount = entry.value;
      double ratio = totalBalance != 0 ? amount / totalBalance : 0;

      return DashboardData(
        title: isRefund
            ? (entry.key == 1 ? "fullRefund" : "partialRefund")
            : Utils.getPaymentType(entry.key),
        value: amount.toInt().toString(),
        valueInDouble: ratio,
        backColor: isRefund
            ? (entry.key == 1 ? AppColors.fullRefundColor : AppColors.cashColor)
            : Utils.getPaymentMethodColor(entry.key),
      );
    }).toList();
  }

  datePicker() async {
    DateTimeRange? newDateRange = await Utils.dateRangePicker(
        selectedDateRange, dateTimeRange, DateTime(currentDate.year + 50));
    if (newDateRange != null) {
      selectedDateRange = newDateRange;
      dateRange.text =
          "${Utils.dateFormat1.format(selectedDateRange.start)} - ${Utils.dateFormat1.format(selectedDateRange.end)}";
      _fetchDashboardData();
    }
  }

  @override
  void onClose() {
    dateRange.dispose();

    donationHistoryChart.close();
    refundHistoryChart.close();
    dashboardData.close();
    totalAmount.close();
    totalRefund.close();

    super.onClose();
  }
}
