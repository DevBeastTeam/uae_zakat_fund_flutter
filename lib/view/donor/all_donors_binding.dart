import 'package:get/get.dart';
import 'package:zakat_fund/view_model/all_donors_view_model.dart';

class AllDonorsBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AllDonorsViewModel());
  }
}
