import 'package:get/get.dart';
import 'package:zakat_fund/view_model/approver_group_view_model.dart';

class ApproverGroupBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ApproverGroupViewModel());
  }
}
