import 'package:get/get.dart';
import 'package:zakat_fund/view_model/cms_about_us_view_model.dart';

class CMSAboutUsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CMSAboutUsViewModel>(() => CMSAboutUsViewModel());
  }
}
