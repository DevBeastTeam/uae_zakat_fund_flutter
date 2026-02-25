import 'package:get/get.dart';
import 'package:zakat_fund/view_model/survey_view_model.dart';

class SurveyBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(SurveyViewModel());
  }
}
