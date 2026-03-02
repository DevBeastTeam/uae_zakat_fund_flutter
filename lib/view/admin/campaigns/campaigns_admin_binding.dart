import 'package:get/get.dart';
import 'package:zakat_fund/view_model/campaigns_admin_view_model.dart';

class CampaignsAdminBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CampaignsAdminViewModel());
  }
}
