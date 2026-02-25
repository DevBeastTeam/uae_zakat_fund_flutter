import 'package:get/get.dart';
import 'package:zakat_fund/view_model/search_result_view_model.dart';

class SearchResultBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(SearchResultViewModel());
  }
}
