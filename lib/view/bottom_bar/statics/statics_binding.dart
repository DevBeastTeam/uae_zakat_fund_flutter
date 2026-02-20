import 'package:get/get.dart';
import 'package:zakat_fund/view_model/statics_view_model.dart';

class StaticsBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(StaticsViewModel());
  }
}
