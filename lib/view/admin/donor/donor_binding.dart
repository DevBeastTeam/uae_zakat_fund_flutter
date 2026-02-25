import 'package:get/get.dart';
import 'package:zakat_fund/view_model/donor_view_model.dart';

class DonorBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(DonorViewModel());
  }
}
