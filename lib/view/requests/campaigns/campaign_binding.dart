import 'package:get/get.dart';
import 'package:zakat_fund/view_model/campaign_view_model.dart';

class CampaignBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(CampaignViewModel());
  }
}
