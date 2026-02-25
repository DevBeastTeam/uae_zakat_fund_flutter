import 'package:get/get.dart';
import 'package:zakat_fund/view_model/audit_log_view_model.dart';

class AuditLogBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AuditLogViewModel());
  }
}
