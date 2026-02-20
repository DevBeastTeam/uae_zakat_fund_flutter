import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/data/response/app_state.dart';
import 'package:zakat_fund/data/response/network_response.dart';
import 'package:zakat_fund/model/password_validation.dart';
import 'package:zakat_fund/model/request_body.dart';
import 'package:zakat_fund/model/user.dart';
import 'package:zakat_fund/my_app/my_app.dart';
import 'package:zakat_fund/repository/forgot_password_repo.dart';
import 'package:zakat_fund/utils/constants/event_constant.dart';
import 'package:zakat_fund/utils/utils.dart';

class ChangePasswordViewModel extends GetxController {

  final formKey = GlobalKey<FormState>();

  final showCurrentPassword = true.obs;
  final showPassword = true.obs;
  final showConfirmPassword = true.obs;

  final currentPasswordController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final passwordEmpty = true.obs;
  final passwordErrors = <PasswordValidation>[
    PasswordValidation(error: '8CharPassword'),
    PasswordValidation(error: 'uppercaseLetter'),
    PasswordValidation(error: 'lowercaseLetter'),
    PasswordValidation(error: 'numberAtLeast'),
  ].obs;

  final repo = ForgotPasswordRepoImpl();
  late final User user;

  static const int minPasswordLength = 8;
  static final RegExp hasUppercase = RegExp(r'[A-Z]');
  static final RegExp hasLowercase = RegExp(r'[a-z]');
  static final RegExp hasDigit = RegExp(r'\d');

  @override
  void onInit() {
    _initializeData();
    super.onInit();
  }

  _initializeData(){
    Utils.logEvent(name: EventConstant.changePasswordScreen);
    user = userBox.getAt(0);
  }

  updateShowPassword() => showPassword.toggle();

  updateCurrentPassword() => showCurrentPassword.toggle();

  updateShowConfirmPassword() => showConfirmPassword.toggle();

  void validatePassword(String val) {
    passwordEmpty.value = val.isEmpty;
    if (val.isEmpty) return;

    passwordErrors[0].isError = val.length < 8;
    passwordErrors[1].isError = !hasUppercase.hasMatch(val);
    passwordErrors[2].isError = !hasLowercase.hasMatch(val);
    passwordErrors[3].isError = !hasDigit.hasMatch(val);
    passwordErrors.refresh();
  }

  changePassword() async {
    if (!formKey.currentState!.validate()) return;

    final hasValidationError = passwordErrors.any((validation) => validation.isError);
    if (hasValidationError) return;

    Utils.showLoadingDialog();
    var body = {
      "userId": user.empId,
      "oldPassword": currentPasswordController.text,
      "newPassword": passwordController.text,
    };
    ApiResponse apiResponse =
        await repo.changePassword(request: RequestBody(body: body));
    Utils.hideLoadingDialog();
    if (apiResponse.appState == AppState.onSuccess) {
      if (rememberMeBox.isNotEmpty) {
        await rememberMeBox.clear();
        await rememberMeBox
            .add({"email": user.email??"", "password": passwordController.text});
      }
      Utils.showGlobalSnackBar(message: apiResponse.data);
      Get.back();
    }else{
      Utils.handleAPIError(apiResponse);
    }
  }

  @override
  void onClose() {
    currentPasswordController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();

    showCurrentPassword.close();
    showPassword.close();
    showConfirmPassword.close();
    passwordEmpty.close();
    passwordErrors.close();

    super.onClose();
  }

}
