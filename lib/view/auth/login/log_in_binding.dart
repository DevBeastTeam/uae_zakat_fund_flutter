import 'package:get/get.dart';
import 'package:zakat_fund/view_model/log_in_view_model.dart';

class LogInBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(LogInViewModel());
  }
}
