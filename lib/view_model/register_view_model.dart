import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/data/response/app_state.dart';
import 'package:zakat_fund/data/response/network_response.dart';
import 'package:zakat_fund/model/password_validation.dart';
import 'package:zakat_fund/model/request_body.dart';
import 'package:zakat_fund/model/user_selection_type.dart';
import 'package:zakat_fund/repository/registration_repo.dart';
import 'package:zakat_fund/utils/constants/event_constant.dart';
import 'package:zakat_fund/utils/routes/app_routes.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/utils/validator.dart';
import 'package:zakat_fund/view_model/user_selection_view_model.dart';

class RegisterViewModel extends GetxController {
  final formKey = GlobalKey<FormState>();

  final phoneEmailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final showPassword = true.obs;
  final showConfirmPassword = true.obs;
  final passwordEmpty = true.obs;

  final passwordErrors = <PasswordValidation>[
    PasswordValidation(error: '8CharPassword'),
    PasswordValidation(error: 'uppercaseLetter'),
    PasswordValidation(error: 'lowercaseLetter'),
    PasswordValidation(error: 'numberAtLeast'),
  ].obs;

  final RegistrationRepo repo = RegistrationRepoImpl();
  final UserSelectionViewModel userSelection = Get.find();

  @override
  void onInit() {
    Utils.logEvent(name: EventConstant.signupScreen);
    super.onInit();
  }

  updateShowPassword() => showPassword.value = !showPassword.value;

  updateShowConfirmPassword() => showConfirmPassword.value = !showConfirmPassword.value;

  void validatePassword(String value) {
    passwordEmpty.value = value.isEmpty;
    if (value.isEmpty) return;

    passwordErrors[0].isError = value.length < 8;
    passwordErrors[1].isError = !RegExp(r'[A-Z]').hasMatch(value);
    passwordErrors[2].isError = !RegExp(r'[a-z]').hasMatch(value);
    passwordErrors[3].isError = !RegExp(r'[0-9]').hasMatch(value);

    passwordErrors.refresh();
  }

  registerUser() async {
    if (!_isFormValid()) return;
    Utils.showLoadingDialog();
    String phone = phoneEmailController.text;
    UserSelectionType user = userSelection.selectedUser;
    var body = {
      "userTypeId": user.userType,
      "roleId": user.roleId,
      "userName": phone.toLowerCase(),
      "password": passwordController.text,
    };
    ApiResponse apiResponse =
        await repo.registerUser(request: RequestBody(body: body));
    Utils.hideLoadingDialog();
    if (apiResponse.appState == AppState.onSuccess) {
      Utils.showGlobalSnackBar(message: apiResponse.data);
      Get.toNamed(AppRoutes.otpVerificationScreen,
          arguments: {"isRegister": true, "email": phone});
    } else if (apiResponse.appState == AppState.onFailure) {
      Utils.showGlobalSnackBar(message: apiResponse.message!);
    }
  }

  bool _isFormValid() {
    final isValid = formKey.currentState?.validate() ?? false;
    if (!isValid) return false;

    final phone = phoneEmailController.text;
    if (!Validator.isValidEmailOrPhone(phone)) {
      return false;
    }

    final hasPasswordError = passwordErrors.any((e) => e.isError);
    if (hasPasswordError) {
      return false;
    }

    if (passwordController.text != confirmPasswordController.text) {
      Utils.showGlobalSnackBar(message: "passwordMismatch".tr);
      return false;
    }

    formKey.currentState!.save();
    return true;
  }

  @override
  void onClose() {
    phoneEmailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();

    showPassword.close();
    showConfirmPassword.close();
    passwordEmpty.close();
    passwordErrors.close();
    super.onClose();
  }

}
