import 'package:get/get.dart';
import 'package:zakat_fund/view_model/feedback_view_model.dart';

class FeedbackBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(FeedbackViewModel());
  }
}
