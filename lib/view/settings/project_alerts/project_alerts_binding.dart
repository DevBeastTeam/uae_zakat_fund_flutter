import 'package:get/get.dart';
import 'package:zakat_fund/view_model/project_alerts_view_model.dart';

class ProjectAlertsBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ProjectAlertsViewModel());
  }
}
