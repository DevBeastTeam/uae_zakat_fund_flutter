import 'package:get/get.dart';
import 'package:zakat_fund/view_model/add_notification_view_model.dart';

class AddNotificationBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AddNotificationViewModel());
  }
}
