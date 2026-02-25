import 'package:get/get.dart';
import 'package:zakat_fund/view_model/requests_view_model.dart';

class RequestsBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(RequestsViewModel());
  }
}
