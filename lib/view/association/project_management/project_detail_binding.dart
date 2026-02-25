import 'package:get/get.dart';
import 'package:zakat_fund/view_model/project_detail_view_model.dart';

class ProjectDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ProjectDetailViewModel());
  }
}
