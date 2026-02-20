import 'package:get/get.dart';
import 'package:zakat_fund/view_model/settings_view_model.dart';

class SettingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(SettingsViewModel());
  }
}
