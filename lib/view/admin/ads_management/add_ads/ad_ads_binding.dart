import 'package:get/get.dart';
import 'package:zakat_fund/view_model/add_ads_view_model.dart';

class AddAdsBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AddAdsViewModel());
  }
}
