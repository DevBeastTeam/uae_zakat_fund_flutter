import 'package:get/get.dart';
import 'package:zakat_fund/view_model/splash_view_model.dart';

class LanguageBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(SplashViewModel(true));
  }
}
