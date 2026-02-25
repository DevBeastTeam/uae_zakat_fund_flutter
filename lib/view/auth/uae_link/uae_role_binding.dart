import 'package:get/get.dart';
import 'package:zakat_fund/view_model/uae_role_view_model.dart';

class UaeRoleBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(UaeRoleViewModel());
  }
}
