import 'package:get/get.dart';
import 'package:zakat_fund/view_model/my_refunds_view_model.dart';

class MyRefundsBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(MyRefundsViewModel());
  }
}
