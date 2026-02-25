import 'package:get/get.dart';
import 'package:zakat_fund/view_model/notif_pref_view_model.dart';

class NotificationPreferenceBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(NotificationPreferenceViewModel());
  }
}
