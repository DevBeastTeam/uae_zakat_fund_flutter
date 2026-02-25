import 'package:get/get.dart';
import 'package:zakat_fund/view_model/add_news_view_model.dart';

class AddNewsBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AddNewsViewModel());
  }
}
