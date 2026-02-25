import 'package:get/get.dart';
import 'package:zakat_fund/view_model/funds_request_preview_view_model.dart';

class FundsRequestPreviewBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(FundsRequestPreviewViewModel());
  }
}
