import 'package:get/get.dart';
import 'package:zakat_fund/view_model/service_detail_view_model.dart';

class ServiceDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ServiceDetailViewModel());
  }
}
