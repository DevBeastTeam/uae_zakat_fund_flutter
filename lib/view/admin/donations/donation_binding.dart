import 'package:get/get.dart';
import 'package:zakat_fund/view_model/donation_data_view_model.dart';

class DonationDataBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(DonationDataViewModel());
  }
}
