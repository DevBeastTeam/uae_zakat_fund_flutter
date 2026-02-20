import 'package:get/get.dart';
import 'package:zakat_fund/view_model/activity_log_view_model.dart';

class ActivityLogBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ActivityLogViewModel());
  }
}
