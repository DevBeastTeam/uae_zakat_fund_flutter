import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/utils/constants/input_formatters.dart';
import 'package:zakat_fund/utils/routes/app_routes.dart';
import 'package:zakat_fund/utils/validator.dart';
import 'package:zakat_fund/view_model/log_in_view_model.dart';
import 'package:zakat_fund/widgets/elevated_button.dart';
import 'package:zakat_fund/widgets/elevated_icon_button.dart';
import 'package:zakat_fund/widgets/emirate_id_btn.dart';
import 'package:zakat_fund/widgets/footer.dart';
import 'package:zakat_fund/widgets/label_text_field.dart';
import 'package:zakat_fund/widgets/or_text_widget.dart';
import 'package:zakat_fund/widgets/social_loggin_btn.dart';

class LogInScreen extends GetView<LogInViewModel> {
  const LogInScreen({super.key});

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
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: SafeArea(
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                20.verticalSpace,
                _buildHeading(),
                20.verticalSpace,
                _buildEmailPhoneTextField(),
                16.verticalSpace,
                _buildPasswordTextField(),
                _buildRowForgotPass(),
                20.verticalSpace,
                elevatedButton(
                  text: "login",
                  onPressed: () => controller.logInUser(),
                ),
                16.verticalSpace,
                elevatedIconButton(
                  text: "backToHomePage",
                  next: false,
                  backgroundColor: AppColors.lightGreyColor,
                  onPressed: () => Get.back(),
                ),
                buildOrWidget(),
                buildEmiratesBtn(
                  title: 'loginWithEmiratesId',
                  onPressed: () => controller.uaePassSignIn(false),
                ),
                16.verticalSpace,
                _buildUAEPassMessage(),
                16.verticalSpace,
                buildSignInOptions(false),
                20.verticalSpace,
                _buildCreateNewAccount(),
                20.verticalSpace,
                buildFooter(),
                16.verticalSpace,
              ],
            ),
          ),
        ),
      ),
    );
  }

  Align _buildCreateNewAccount() {
    return Align(
      alignment: Alignment.center,
      child: RichText(
        text: TextSpan(
            text: 'dontHaveAccount'.tr,
            style: AppTextStyle.darkerGrey14spTextStyle
                .copyWith(fontFamily: 'Roboto'),
            children: <TextSpan>[
              TextSpan(
                  text: 'createNewAccount'.tr,
                  style: AppTextStyle.primaryDarkBrown14spTextStyle1.copyWith(
                    decoration: TextDecoration.underline,
                    fontFamily: 'Roboto',
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => Get.toNamed(AppRoutes.userSelectionScreen))
            ]),
      ),
    );
  }

  Text _buildUAEPassMessage() {
    return Text(
      "uaePassTagline".tr,
      textAlign: TextAlign.center,
      style: AppTextStyle.secondaryPrimaryBlack12spTextStyle,
    );
  }

  Row _buildRowForgotPass() {
    return Row(
      children: [
        SizedBox(
          width: 20.w,
          height: 20.h,
          child: Obx(() => Checkbox(
                checkColor: Colors.white,
                value: controller.rememberMe.value,
                side: const BorderSide(color: AppColors.darkBlackColor),
                activeColor: AppColors.darkBlackColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.r)),
                onChanged: (bool? value) {
                  controller.updateRememberMe(value!);
                },
              )),
        ),
        10.horizontalSpace,
        Text(
          "rememberMe".tr,
          style: AppTextStyle.secondaryPrimaryBlack16spTextStyle1,
        ),
        const Spacer(),
        TextButton(
          onPressed: () => Get.toNamed(AppRoutes.forgotPasswordScreen),
          style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              visualDensity: const VisualDensity(vertical: -4)),
          child: Text(
            "forgotPassword?".tr,
            style: AppTextStyle.lightBrown14spTextStyle1.copyWith(
              decoration: TextDecoration.underline,
              decorationColor: AppColors.lightBrownColor,
            ),
          ),
        ),
      ],
    );
  }

  Obx _buildPasswordTextField() {
    return Obx(() => LabelTextField(
          label: "password",
          isPassword: true,
          validator: (value) {
            return Validator.validatePassword(value: value!);
          },
          isArabicDirection: true,
          checkValidation: true,
          obscureText: controller.showPassword.value,
          onSuffixTap: () => controller.updateShowPassword(),
          controller: controller.passwordController,
        ));
  }

  LabelTextField _buildEmailPhoneTextField() {
    return LabelTextField(
      label: "emailOrPhone",
      checkValidation: true,
      isArabicDirection: true,
      keyboardType: TextInputType.emailAddress,
      inputFormatters: InputFormatters.denySpaces,
      validator: (value) {
        return Validator.validateEmailOrPhoneEmpty(value: value!);
      },
      controller: controller.phoneEmailController,
    );
  }

  Align _buildHeading() {
    return Align(
      alignment: Alignment.center,
      child: Text(
        "login".tr,
        style: AppTextStyle.secondaryDarkBrown36spTextStyle,
      ),
    );
  }
}
