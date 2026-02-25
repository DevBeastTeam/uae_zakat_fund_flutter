import 'package:get/get.dart';
import 'package:zakat_fund/view_model/recipients_campaign_view_model.dart';

class RecipientsCampaignBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(RecipientsCampaignViewModel());
  }
}
