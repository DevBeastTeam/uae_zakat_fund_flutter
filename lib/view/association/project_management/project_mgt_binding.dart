import 'package:get/get.dart';
import 'package:zakat_fund/view_model/project_management_view_model.dart';

class ProjectMgtBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ProjectManagementViewModel());
  }
}
