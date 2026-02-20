import 'package:get/get.dart';
import 'package:zakat_fund/view_model/forgot_password_view_model.dart';

class ForgotPasswordBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ForgotPasswordViewModel());
  }
}
