import 'package:get/get.dart';
import 'package:zakat_fund/view_model/donation_reminder_view_model.dart';

class DonationReminderBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(DonationReminderViewModel());
  }
}
