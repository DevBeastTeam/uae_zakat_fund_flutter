import 'package:get/get.dart';
import 'package:zakat_fund/view_model/user_engagemnt_view_model.dart';

class UserEngagementBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(UserEngagementViewModel());
  }
}
