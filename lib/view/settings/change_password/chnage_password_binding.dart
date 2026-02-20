import 'package:get/get.dart';
import 'package:zakat_fund/view_model/chnage_password_view_model.dart';

class ChangePasswordBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ChangePasswordViewModel());
  }
}
