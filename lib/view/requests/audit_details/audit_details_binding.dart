import 'package:get/get.dart';
import 'package:zakat_fund/view_model/audit_details_view_model.dart';

class AuditDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AuditDetailsViewModel());
  }
}
