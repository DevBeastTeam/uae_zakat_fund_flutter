import 'package:get/get.dart';
import 'package:zakat_fund/view_model/smtp_config_view_model.dart';

class SmtpConfigBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(SMTPConfigViewModel());
  }
}
