import 'package:get/get.dart';
import 'package:zakat_fund/view_model/campaign_templates_view_model.dart';

class CampaignTemplatesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CampaignTemplatesViewModel>(
      () => CampaignTemplatesViewModel(),
    );
  }
}
