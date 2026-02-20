import 'package:get/get.dart';
import 'package:zakat_fund/view_model/faq_view_model.dart';

class FaqBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(FaqViewModel());
  }
}
