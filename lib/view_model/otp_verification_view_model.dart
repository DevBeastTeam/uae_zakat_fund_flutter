import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/data/response/app_state.dart';
import 'package:zakat_fund/data/response/network_response.dart';
import 'package:zakat_fund/model/request_body.dart';
import 'package:zakat_fund/repository/otp_verification_repo.dart';
import 'package:zakat_fund/utils/constants/event_constant.dart';
import 'package:zakat_fund/utils/routes/app_routes.dart';
import 'package:zakat_fund/utils/utils.dart';

class OtpVerificationViewModel extends GetxController {
  TextEditingController otpTextEditingController = TextEditingController();
  OtpVerificationRepo repo = OtpVerificationRepoImpl();
  var formKey = GlobalKey<FormState>();


  @override
  void onInit() {
    Utils.logEvent(name: EventConstant.accountVerificationScreen);
    super.onInit();
  }

  validateOtp(dynamic arguments) async {
    final otp = otpTextEditingController.text.trim();
    if (_isOtpValid(otp)) {
      Utils.showGlobalSnackBar(message: "invalidCode".tr);
      return;
    }
    Utils.showLoadingDialog();
    var body = {
      "userName": arguments["email"].toString().toLowerCase(),
      "otp": otp
    };
    ApiResponse apiResponse = await repo.validateOTP(request: RequestBody(body: body));
    Utils.hideLoadingDialog();
    if (apiResponse.appState == AppState.onSuccess) {
      Utils.showGlobalSnackBar(message: apiResponse.data);
      Get.toNamed(AppRoutes.registerSuccessScreen);
    }else{
      Utils.handleAPIError(apiResponse);
    }
  }

  resendOtp(dynamic arguments, {bool resend = false}) async {
    if (arguments["isRegister"] || resend) Utils.showLoadingDialog();
    var body = {"userName": arguments["email"].toString().toLowerCase()};
    ApiResponse apiResponse =
    await repo.sendOTP(request: RequestBody(body: body));
    Utils.hideLoadingDialog();
    if (apiResponse.appState == AppState.onSuccess) {
      Utils.showGlobalSnackBar(message: apiResponse.data);
      if (!resend) {
        Get.toNamed(AppRoutes.otpVerificationScreen, arguments: arguments);
      }
    }else{
      Utils.handleAPIError(apiResponse);
    }
  }

  bool _isOtpValid(String otp) => otp.isEmpty || otp.length <5;

}
