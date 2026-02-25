import 'package:get/get.dart';
import 'package:zakat_fund/view_model/admin_dashboard_view_model.dart';

class AdminDashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AdminDashboardViewModel());
  }
}
