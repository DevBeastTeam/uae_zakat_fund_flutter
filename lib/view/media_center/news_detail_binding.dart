import 'package:get/get.dart';
import 'package:zakat_fund/view_model/news_detail_view_model.dart';

class NewsDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.create<NewsDetailViewModel>(() => NewsDetailViewModel());
  }
}
