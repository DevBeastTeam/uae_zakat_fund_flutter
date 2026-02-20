import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/utils/routes/app_routes.dart';
import 'package:zakat_fund/view_model/uae_log_in_view_model.dart';
import 'package:zakat_fund/widgets/elevated_button.dart';
import 'package:zakat_fund/widgets/label_text_field.dart';
import 'package:zakat_fund/widgets/my_app_bar.dart';

class UaeLoginScreen extends GetView<UaeLogInViewModel> {
  const UaeLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(title: ""),
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
                _buildForgotPassRow(),
                20.verticalSpace,
                elevatedButton(
                  text: "linkWithUaePass",
                  onPressed: () => controller.linkAccount(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row _buildForgotPassRow() {
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
                onChanged: (bool? value) => controller.updateRememberMe(value!),
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

  Align _buildSignUp() {
    return Align(
      alignment: Alignment.center,
      child: RichText(
        text: TextSpan(
            text: 'dontHaveAccount'.tr,
            style: AppTextStyle.darkerGrey14spTextStyle,
            children: <TextSpan>[
              TextSpan(
                  text: 'signUp'.tr,
                  style: AppTextStyle.primaryDarkBrown14spTextStyle1.copyWith(
                    decoration: TextDecoration.underline,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => Get.toNamed(AppRoutes.userSelectionScreen))
            ]),
      ),
    );
  }

  Obx _buildPasswordTextField() {
    return Obx(() => LabelTextField(
          label: "password",
          isPassword: true,
          isArabicDirection: true,
          checkValidation: true,
          obscureText: controller.showPassword.value,
          onSuffixTap: () => controller.toggleShowPassword(),
          controller: controller.passwordController,
        ));
  }

  LabelTextField _buildEmailTextField() {
    return LabelTextField(
      label: "emailOrPhone",
      checkValidation: true,
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
