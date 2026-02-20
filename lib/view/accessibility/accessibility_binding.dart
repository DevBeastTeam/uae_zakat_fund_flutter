import 'package:get/get.dart';
import 'package:zakat_fund/view_model/accessibility_view_model.dart';

class AccessibilityBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AccessibilityViewModel());
  }
}
