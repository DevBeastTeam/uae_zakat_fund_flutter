import 'package:get/get.dart';
import 'package:zakat_fund/view_model/cms_services_view_model.dart';

class CmsServicesBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(CMSServicesViewModel());
  }
}
