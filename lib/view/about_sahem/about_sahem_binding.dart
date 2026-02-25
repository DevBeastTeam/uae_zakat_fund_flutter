import 'package:get/get.dart';
import 'package:zakat_fund/view_model/about_sahem_view_model.dart';

class AboutSahemBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AboutSahemViewModel());
  }
}
