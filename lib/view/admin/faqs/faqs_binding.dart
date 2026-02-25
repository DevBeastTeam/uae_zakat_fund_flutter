import 'package:get/get.dart';
import 'package:zakat_fund/view_model/cms_faq_view_model.dart';

class FaqsBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(CMSFaqViewModel());
  }
}
