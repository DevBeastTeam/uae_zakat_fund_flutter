import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/utils/constants/input_formatters.dart';
import 'package:zakat_fund/utils/validator.dart';
import 'package:zakat_fund/view_model/log_in_view_model.dart';
import 'package:zakat_fund/view_model/register_view_model.dart';
import 'package:zakat_fund/widgets/already_have_account.dart';
import 'package:zakat_fund/widgets/elevated_button.dart';
import 'package:zakat_fund/widgets/elevated_icon_button.dart';
import 'package:zakat_fund/widgets/emirate_id_btn.dart';
import 'package:zakat_fund/widgets/footer.dart';
import 'package:zakat_fund/widgets/label_text_field.dart';
import 'package:zakat_fund/widgets/or_text_widget.dart';
import 'package:zakat_fund/widgets/password_match_widget.dart';
import 'package:zakat_fund/widgets/social_loggin_btn.dart';

class RegisterScreen extends GetView<RegisterViewModel> {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _buildBody(),
    );
  }

  KeyboardDismissOnTap _buildBody() {
    return KeyboardDismissOnTap(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
        child: SafeArea(
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeading(),
                20.verticalSpace,
                _buildEmailTextField(),
                16.verticalSpace,
                _buildPasswordTextField(),
                16.verticalSpace,
                _buildConfirmPasswordTextField(),
                Obx(() => controller.passwordEmpty.value
                    ? const SizedBox.shrink()
                    : buildPasswordErrors(controller)),
                16.verticalSpace,
                elevatedButton(
                  text: "register",
                  onPressed: () => controller.registerUser(),
                ),
                16.verticalSpace,
                elevatedIconButton(
                  text: "previous",
                  next: false,
                  backgroundColor: AppColors.lightGreyColor,
                  onPressed: () => Get.back(),
                ),
                buildOrWidget(),
                buildEmiratesBtn(
                    title: 'registerWithEmiratesId',
                    onPressed: () =>
                        Get.find<LogInViewModel>().uaePassSignIn(true)),
                16.verticalSpace,
                Text(
                  "uaePassTagline".tr,
                  textAlign: TextAlign.center,
                  style: AppTextStyle.secondaryPrimaryBlack12spTextStyle,
                ),
                16.verticalSpace,
                buildSignInOptions(true),
                20.verticalSpace,
                buildAlreadyHaveAccount(),
                20.verticalSpace,
                buildFooter(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Obx _buildConfirmPasswordTextField() {
    return Obx(() => LabelTextField(
          label: "confirmPassword",
          checkValidation: true,
          isArabicDirection: true,
          validator: (value) {
            return Validator.validateConfirmPassword(
                pass2: value!, pass1: controller.passwordController.text);
          },
          controller: controller.confirmPasswordController,
          isPassword: true,
          obscureText: controller.showConfirmPassword.value,
          onSuffixTap: () => controller.updateShowConfirmPassword(),
        ));
  }

  Obx _buildPasswordTextField() {
    return Obx(() => LabelTextField(
          label: "password",
          isPassword: true,
          validator: (value) {
            return Validator.validatePassword(value: value!);
          },
          checkValidation: true,
          isArabicDirection: true,
          onChanged: (val) => controller.validatePassword(val),
          controller: controller.passwordController,
          obscureText: controller.showPassword.value,
          onSuffixTap: () => controller.updateShowPassword(),
        ));
  }

  LabelTextField _buildEmailTextField() {
    return LabelTextField(
        label: "emailOrPhone",
        keyboardType: TextInputType.emailAddress,
        isArabicDirection: true,
        inputFormatters: InputFormatters.denySpaces,
        validator: (value) =>
            Validator.validateEmailOrPhoneEmpty(value: value!),
        checkValidation: true,
        controller: controller.phoneEmailController);
  }

  Align _buildHeading() {
    return Align(
      alignment: Alignment.center,
      child: Text(
        "registration".tr,
        style: AppTextStyle.secondaryDarkBrown36spTextStyle,
      ),
    );
  }
}
