import 'package:get/get.dart';
import 'package:zakat_fund/view_model/sla_dashboard_view_model.dart';

class SlaDashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(SLADashboardViewModel());
  }
}
