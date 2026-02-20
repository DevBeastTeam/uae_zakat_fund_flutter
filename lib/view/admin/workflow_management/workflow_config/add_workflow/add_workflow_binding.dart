import 'package:get/get.dart';
import 'package:zakat_fund/view_model/add_workflow_view_model.dart';

class AddWorkflowBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AddWorkflowViewModel());
  }
}
