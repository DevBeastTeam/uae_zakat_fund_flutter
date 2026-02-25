import 'package:get/get.dart';

class OnboardingViewModel extends GetxController {
  RxInt currentIndex = 0.obs;

  updateIndex(int index) => currentIndex.value = index;
}
