import 'package:get/get.dart';
import 'package:zakat_fund/view_model/faq_preview_view_model.dart';

class FaqPreviewBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(FaqPreviewViewModel());
  }
}
