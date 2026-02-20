import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/my_app/my_app.dart';
import 'package:zakat_fund/utils/constants/event_constant.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/view_model/log_in_view_model.dart';

class UaeLogInViewModel extends GetxController {
  RxBool showPassword = true.obs;
  RxBool rememberMe = false.obs;

  final formKey = GlobalKey<FormState>();

  final TextEditingController phoneEmailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();


  @override
  void onInit() {
    _initializeData();
    super.onInit();
  }

  _initializeData(){
    Utils.logEvent(name: EventConstant.accountLinkingScreen);
    _loadRememberedCredentials();
  }

  void _loadRememberedCredentials() {
    if (rememberMeBox.isNotEmpty) {
      final data = rememberMeBox.getAt(0);
      phoneEmailController.text = data?["email"] ?? "";
      passwordController.text = data?["password"] ?? "";
    }
  }

  void linkAccount() {
    if (formKey.currentState?.validate() ?? false) {
      Get.find<LogInViewModel>().saveUaeUser(
        userName: phoneEmailController.text.trim(),
        password: passwordController.text.trim(),
      );
    }
  }

  void updateRememberMe(bool value) => rememberMe.value = value;

  void toggleShowPassword() => showPassword.toggle();

  @override
  void onClose() {
    phoneEmailController.dispose();
    passwordController.dispose();

    showPassword.close();
    rememberMe.close();
    super.onClose();
  }

}
