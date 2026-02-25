import 'package:get/get.dart';
import 'package:zakat_fund/view_model/project_preview_view_model.dart';

class ProjectPreviewBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ProjectPreviewViewModel());
  }
}
