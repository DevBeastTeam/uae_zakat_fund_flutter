import 'package:get/get.dart';
import 'package:zakat_fund/view_model/individual_view_model.dart';

class IndividualBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(IndividualViewModel());
  }
}
