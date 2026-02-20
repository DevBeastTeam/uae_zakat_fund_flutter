import 'package:get/get.dart';
import 'package:zakat_fund/view_model/add_service_view_model.dart';

class AddServicesBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AddServiceViewModel());
  }
}
