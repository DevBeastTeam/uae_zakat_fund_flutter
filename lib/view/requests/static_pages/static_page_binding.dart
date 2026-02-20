import 'package:get/get.dart';
import 'package:zakat_fund/view_model/static_page_view_model.dart';

class StaticPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(StaticPageViewModel());
  }
}
