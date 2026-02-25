import 'package:get/get.dart';
import 'package:zakat_fund/view_model/workflow_config_view_model.dart';

class WorkflowConfigBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(WorkflowConfigViewModel());
  }
}
