import 'package:get/get.dart';
import 'package:zakat_fund/view_model/financial_statement_view_model.dart';

class FinancialStatementBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(FinancialStatementViewModel());
  }
}
