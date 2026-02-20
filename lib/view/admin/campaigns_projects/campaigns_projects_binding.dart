import 'package:get/get.dart';
import 'package:zakat_fund/view_model/campaigns_projects_view_model.dart';

class CampaignsProjectsBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(CampaignsAndProjectsViewModel());
  }
}
