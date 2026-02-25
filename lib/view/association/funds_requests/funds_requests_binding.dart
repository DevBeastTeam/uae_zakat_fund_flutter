import 'package:get/get.dart';
import 'package:zakat_fund/view_model/funds_requests_view_model.dart';

class FundsRequestsBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(FundsRequestsViewModel());
  }
}
