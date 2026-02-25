import 'package:get/get.dart';
import 'package:zakat_fund/view_model/add_donation_remioder_view_model.dart';

class AddDonationReminderBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AddDonationReminderViewModel());
  }
}
