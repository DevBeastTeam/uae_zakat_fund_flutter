import 'package:get/get.dart';
import 'package:zakat_fund/view_model/services_view_model.dart';

class ServicesBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(OurServiceViewModel());
  }
}
