import 'package:get/get.dart';
import 'package:zakat_fund/view_model/cms_static_page_view_model.dart';

class StaticPagesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CMSStaticPageViewModel>(() => CMSStaticPageViewModel());
  }
}
