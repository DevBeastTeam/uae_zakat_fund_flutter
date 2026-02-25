import 'package:get/get.dart';
import 'package:zakat_fund/view_model/platform_doc_view_model.dart';

class PlatformDocumentsBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(PlatformDocViewModel());
  }
}
