import 'package:get/get.dart';
import 'package:zakat_fund/view_model/admin_operations_view_model.dart';

class AdminAndOperationsBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AdminAndOperationsViewModel());
  }
}
