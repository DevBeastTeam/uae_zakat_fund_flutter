import 'package:get/get.dart';
import 'package:zakat_fund/view_model/onboarding_view_model.dart';

class OnboardingBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(OnboardingViewModel());
  }
}
