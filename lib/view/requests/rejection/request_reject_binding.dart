import 'package:get/get.dart';
import 'package:zakat_fund/view_model/request_reject_view_model.dart';

class RequestRejectBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(RequestRejectViewModel());
  }
}
