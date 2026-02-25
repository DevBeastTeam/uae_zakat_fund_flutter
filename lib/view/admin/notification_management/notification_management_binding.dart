import 'package:get/get.dart';
import 'package:zakat_fund/view_model/notification_management_view_model.dart';

class NotificationManagementBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(NotificationManagementViewModel());
  }
}
