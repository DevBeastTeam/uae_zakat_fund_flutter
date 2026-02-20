import 'package:get/get.dart';
import 'package:zakat_fund/view_model/association_dashboard_view_model.dart';

class AssociationDashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AssociationDashboardViewModel());
  }
}
