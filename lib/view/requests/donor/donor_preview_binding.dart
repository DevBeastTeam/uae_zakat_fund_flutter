import 'package:get/get.dart';
import 'package:zakat_fund/view_model/donor_preview_view_model.dart';

class DonorPreviewBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(DonorPreviewViewModel());
  }
}
