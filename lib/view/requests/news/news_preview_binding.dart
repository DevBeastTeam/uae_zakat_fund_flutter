import 'package:get/get.dart';
import 'package:zakat_fund/view_model/news_preview_view_model.dart';

class NewsPreviewBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(NewsPreviewViewModel());
  }
}
