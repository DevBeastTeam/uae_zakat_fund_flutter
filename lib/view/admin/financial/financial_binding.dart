import 'package:get/get.dart';
import 'package:zakat_fund/view_model/financial_view_model.dart';

class FinancialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(FinancialDashboardViewModel());
  }
}
