import 'package:get/get.dart';
import 'package:zakat_fund/view_model/association_preview_view_model.dart';

class AssociationPreviewBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AssociationPreviewViewModel());
  }
}
