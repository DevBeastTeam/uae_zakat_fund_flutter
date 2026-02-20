import 'package:get/get.dart';
import 'package:zakat_fund/view_model/projects_donated_view_model.dart';

class LastDonatedBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ProjectsDonatedViewModel());
  }
}
