import 'package:get/get.dart';
import 'package:zakat_fund/view_model/register_view_model.dart';

class RegisterBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(RegisterViewModel());
  }
}
