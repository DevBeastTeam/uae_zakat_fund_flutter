import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/data/response/app_state.dart';
import 'package:zakat_fund/data/response/network_response.dart';
import 'package:zakat_fund/model/dashboard_data.dart';
import 'package:zakat_fund/model/financial_statement.dart';
import 'package:zakat_fund/model/money_transferred.dart';
import 'package:zakat_fund/model/request_body.dart';
import 'package:zakat_fund/model/user.dart';
import 'package:zakat_fund/my_app/my_app.dart';
import 'package:zakat_fund/repository/financial_statement_repo.dart';
import 'package:zakat_fund/utils/constants/event_constant.dart';
import 'package:zakat_fund/utils/utils.dart';

class FinancialStatementViewModel extends GetxController {
  final RxList<DashboardData> financialStatement = <DashboardData>[].obs;
  final RxList<FinancialStatementByMonth> breakdownProjects = <FinancialStatementByMonth>[].obs;
  final RxMap<String, bool> expandedGroups = <String, bool>{}.obs;
  final RxString selectedPeriod = "monthly".obs;
  final TextEditingController dateController = TextEditingController();

  final FinancialStatementRepoImpl repo = FinancialStatementRepoImpl();

  late final User user;
  late DateTime currentDate;
  late DateTimeRange dateTimeRange;
  DateTimeRange? selectedDateRange;

  List<MoneyTransferred> moneyTransferred = [];

  @override
  onInit() {
    _initializeData();
    super.onInit();
  }

  _initializeData(){
    Utils.logEvent(name: EventConstant.financialStatementScreen);
    currentDate = DateTime.now();
    setInitialDates();
    user = userBox.getAt(0);
    financialStatement.value = [
      DashboardData(title: 'overallCollectedDonations', value: '0'),
      DashboardData(title: 'initialFundBalance', value: '0'),
      DashboardData(title: 'monthlyDonationsBreakdown', value: '0'),
      DashboardData(title: 'moneyTransferred', value: '0'),
      DashboardData(title: 'overallMoneyTransferredTillDate', value: '0'),
      DashboardData(title: 'remainingFundsCollectedBalance', value: '0'),
    ];
    fetchData();
  }

  setInitialDates(){
    selectedPeriod.value == "monthly"
        ? setInitialDateTime()
        : setYearlyDateTime();
  }

  fetchData() async {
    try{
      Utils.showLoadingDialog();
      await Future.wait([fetchBalance(), fetchDonations(),fetchMoneyTransferred()]);
    }finally{
      Utils.hideLoadingDialog();
    }
  }

  setInitialDateTime() {
    dateTimeRange = DateTimeRange(
      start: DateTime(currentDate.year, currentDate.month, 1),
      end: currentDate,
    );
    selectedDateRange = dateTimeRange;
    setDateTime();
  }

  setYearlyDateTime() {
    dateTimeRange = DateTimeRange(
      start: DateTime(currentDate.year, 1, 1),
      end: currentDate,
    );
    selectedDateRange = dateTimeRange;
    setDateTime();
  }

  Future fetchBalance() async {
    var params = {
      "accountId": user.accountId,
      "startDate": Utils.newDateFormat.format(selectedDateRange!.start),
      "endDate": Utils.newDateFormat.format(selectedDateRange!.end),
    };
    ApiResponse apiResponse =
        await repo.financialStatementBalance(request: RequestBody(queryParameters: params));
    if (apiResponse.appState == AppState.onSuccess) {
      FinancialStatementBalance? balance = apiResponse.data;
      if (balance != null) {
        double remainingFundsCollectedBalance = balance.overAllCollectedDonations - balance.overAllMoneyTransferredTillDate;
        financialStatement[0].value = Utils.getCurrency(balance.overAllCollectedDonations.toInt());
        financialStatement[1].value = Utils.getCurrency(balance.initialFundBalance.toInt());
        financialStatement[4].value = Utils.getCurrency(balance.overAllMoneyTransferredTillDate.toInt());
        financialStatement[5].value = Utils.getCurrency(remainingFundsCollectedBalance.toInt());
        financialStatement.refresh();
      }
    } else {
      Utils.handleAPIError(apiResponse);
    }
  }

  Future fetchDonations() async {
    breakdownProjects.clear();
    final isMonthly = selectedPeriod.value == "monthly";
    financialStatement[2].title = isMonthly ? "monthlyDonationsBreakdown" : "yearlyDonationsBreakdown";
    financialStatement[2].value = "0";
    financialStatement.refresh();
    var params = {
      "accountId": user.accountId,
      "startDate": Utils.newDateFormat.format(selectedDateRange!.start),
      "endDate": Utils.newDateFormat.format(selectedDateRange!.end),
      "selectedPeriod": isMonthly ? "Month" : "Year",
      "currentLanguage": Get.locale?.languageCode,
    };
    ApiResponse apiResponse = await repo.financialStatementByMonth(
        request: RequestBody(queryParameters: params));
    if (apiResponse.appState == AppState.onSuccess) {
      breakdownProjects.value = apiResponse.data;
      double totalAmount = breakdownProjects.fold(0, (sum, proj) => sum + double.parse(proj.totalAmount));
      financialStatement[2].value = Utils.getCurrency(totalAmount.toInt());
      financialStatement.refresh();
    } else {
      Utils.handleAPIError(apiResponse);
    }
  }

  Future fetchMoneyTransferred() async {
    var params = {
      "accountId": user.accountId,
      "startDate": Utils.newDateFormat.format(selectedDateRange!.start),
      "endDate": Utils.newDateFormat.format(selectedDateRange!.end),
      "currentLanguage": Get.locale?.languageCode,
    };
    ApiResponse apiResponse = await repo.moneyTransferred(request: RequestBody(queryParameters: params));
    if (apiResponse.appState == AppState.onSuccess) {
      moneyTransferred = apiResponse.data;
      int amount = moneyTransferred.fold(0, (sum, proj) => sum! + double.parse(proj.totalAmount).toInt()) ?? 0;
      financialStatement[3].value = Utils.getCurrency(amount);
    } else {
      financialStatement[3].value = "0";
      Utils.handleAPIError(apiResponse);
    }
  }

  dateRangePicker() async {
    DateTimeRange? newDateRange = await Utils.dateRangePicker(
        selectedDateRange, dateTimeRange, currentDate);
    if (newDateRange != null) {
      selectedDateRange = newDateRange;
      setDateTime();
      fetchData();
    }
  }

  setDateTime() {
    dateController.text = "${Utils.dateFormat1.format(selectedDateRange!.start)} - ${Utils.dateFormat1.format(selectedDateRange!.end)}";
  }

  onChangePeriod(String value){
    selectedPeriod.value = value;
    setInitialDates();
    fetchData();
  }

  @override
  void onClose() {
    dateController.dispose();

    financialStatement.close();
    breakdownProjects.close();
    expandedGroups.close();
    selectedPeriod.close();
    super.onClose();
  }

}
