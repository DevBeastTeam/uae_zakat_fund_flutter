import 'package:get/get.dart';
import 'package:zakat_fund/view_model/authenticate_task_view_model.dart';

class AuthTaskBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthenticateTaskViewModel());
  }
}
