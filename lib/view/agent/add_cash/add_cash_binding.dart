import 'package:get/get.dart';
import 'package:zakat_fund/view_model/add_cash_view_model.dart';

class AddCashBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AddCashViewModel());
  }
}
