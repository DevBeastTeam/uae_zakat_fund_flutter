import 'package:get/get.dart';
import 'package:zakat_fund/view_model/ads_management_view_model.dart';

class AdsManagementBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AdsManagementViewModel());
  }
}
