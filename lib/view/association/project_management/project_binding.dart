import 'package:get/get.dart';
import 'package:zakat_fund/view_model/project_view_model.dart';

class ProjectBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ProjectViewModel());
  }
}
