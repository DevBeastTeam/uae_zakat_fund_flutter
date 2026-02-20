import 'package:get/get.dart';
import 'package:zakat_fund/view_model/password_security_view_model.dart';

class PasswordSecurityBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(PasswordSecurityViewModel());
  }
}
