import 'package:get/get.dart';
import 'package:zakat_fund/view_model/about_us_view_model.dart';

class AboutUsBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AboutUsViewModel());
  }
}
