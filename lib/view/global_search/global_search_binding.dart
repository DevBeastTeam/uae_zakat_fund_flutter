import 'package:get/get.dart';
import 'package:zakat_fund/view_model/global_search_view_model.dart';

class GlobalSearchBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(GlobalSearchViewModel());
  }
}
