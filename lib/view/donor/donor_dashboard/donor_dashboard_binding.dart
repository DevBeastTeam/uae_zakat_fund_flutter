import 'package:get/get.dart';
import 'package:zakat_fund/view_model/donor_dashboard_view_model.dart';

class DonorDashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(DonorDashboardViewModel());
  }
}
