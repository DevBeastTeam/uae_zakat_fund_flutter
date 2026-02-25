import 'package:get/get.dart';
import 'package:zakat_fund/view_model/notification_view_model.dart';

class NotificationBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(NotificationViewModel());
  }
}
