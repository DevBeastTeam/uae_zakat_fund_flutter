import 'package:get/get.dart';
import 'package:zakat_fund/view_model/otp_verification_view_model.dart';

class OtpVerificationBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(OtpVerificationViewModel());
  }
}
