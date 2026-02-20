import 'package:get/get.dart';
import 'package:zakat_fund/view_model/uae_log_in_view_model.dart';

class UaeLogInBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(UaeLogInViewModel());
  }
}
