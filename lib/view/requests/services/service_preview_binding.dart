import 'package:get/get.dart';
import 'package:zakat_fund/view_model/service_preview_view_model.dart';

class ServicePreviewBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ServicePreviewViewModel());
  }
}
