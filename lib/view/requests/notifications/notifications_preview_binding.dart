import 'package:get/get.dart';
import 'package:zakat_fund/view_model/notifications_preview_view_model.dart';

class NotificationsPreviewBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(NotificationsPreviewViewModel());
  }
}
