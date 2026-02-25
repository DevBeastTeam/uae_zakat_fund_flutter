import 'package:get/get.dart';
import 'package:zakat_fund/view_model/add_feedback_view_model.dart';

class AddFeedbackBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AddFeedbackViewModel());
  }
}
