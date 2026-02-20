import 'package:get/get.dart';
import 'package:zakat_fund/view_model/add_approver_group_view_model.dart';

class AddApproverGroupBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AddApproverGroupViewModel());
  }
}
