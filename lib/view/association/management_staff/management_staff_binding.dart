import 'package:get/get.dart';
import 'package:zakat_fund/view_model/management_staff_view_model.dart';

class ManagementStaffBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ManagementStaffViewModel());
  }
}
