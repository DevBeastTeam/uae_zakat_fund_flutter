import 'package:get/get.dart';
import 'package:zakat_fund/view_model/all_projects_view_model.dart';

class AllProjectsBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AllProjectsViewModel());
  }
}
