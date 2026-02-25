import 'package:get/get.dart';
import 'package:zakat_fund/view_model/cms_news_view_model.dart';

class CMSNewsBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(CMSNewsViewModel());
  }
}
