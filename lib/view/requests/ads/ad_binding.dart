import 'package:get/get.dart';
import 'package:zakat_fund/view_model/ad_view_model.dart';

class AdBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AdViewModel());
  }
}
