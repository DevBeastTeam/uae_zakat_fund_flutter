import 'package:get/get.dart';
import 'package:zakat_fund/view_model/main_view_model.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(MainViewModel());
  }
}
