import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/data/response/app_state.dart';
import 'package:zakat_fund/data/response/network_response.dart';
import 'package:zakat_fund/model/request_body.dart';
import 'package:zakat_fund/repository/forgot_password_repo.dart';
import 'package:zakat_fund/utils/constants/event_constant.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/utils/validator.dart';

class ForgotPasswordViewModel extends GetxController {
  var formKey = GlobalKey<FormState>();
  final phoneEmailController = TextEditingController();
  final ForgotPasswordRepo repo = ForgotPasswordRepoImpl();

  @override
  void onInit() {
    Utils.logEvent(name: EventConstant.forgotPasswordScreen);
    super.onInit();
  }

  sendForgotPassword() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    if (!Validator.isValidEmailOrPhone(phoneEmailController.text)) {
      return;
    }
    formKey.currentState!.save();
    Utils.showLoadingDialog();
    var body = {"userName": phoneEmailController.text.toLowerCase()};
    ApiResponse apiResponse =
        await repo.forgotPassword(request: RequestBody(body: body));
    Utils.hideLoadingDialog();
    if (apiResponse.appState == AppState.onSuccess) {
      Utils.showGlobalSnackBar(message: apiResponse.data);
      Get.back();
    } else if (apiResponse.appState == AppState.onFailure) {
      Utils.showGlobalSnackBar(message: apiResponse.message!);
    }
  }

  @override
  void onClose() {
    phoneEmailController.dispose();
    super.onClose();
  }

}
