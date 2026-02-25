import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/utils/routes/app_routes.dart';
import 'package:zakat_fund/utils/validator.dart';
import 'package:zakat_fund/view_model/log_in_view_model.dart';
import 'package:zakat_fund/widgets/elevated_button.dart';
import 'package:zakat_fund/widgets/label_text_field.dart';
import 'package:zakat_fund/widgets/my_app_bar.dart';

class LegacyLoginScreen extends StatelessWidget {
  const LegacyLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<LogInViewModel>();

    return Scaffold(
      appBar: myAppBar(title: "login"),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 32.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: AppColors.brownPrimaryColor),
              ),
              child: Form(
                key: controller.formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        "loginWithEmiratesId".tr,
                        style: AppTextStyle.secondaryPrimaryBlack24spTextStyle2,
                      ),
                    ),
                    25.verticalSpace,
                    Obx(() => controller.showLegacyMessage.value
                        ? Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColors.secondaryDarkBrownColor
                                  .withValues(alpha: 0.10),
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text(
                                    "legacyLoginMessage".tr,
                                    textAlign: TextAlign.center,
                                    style: AppTextStyle
                                        .secondaryDarkBrownColor12spTextStyle,
                                  ),
                                ),
                                8.horizontalSpace,
                                GestureDetector(
                                  onTap: () => controller.hideLegacyMessage(),
                                  child: Icon(Icons.close,
                                      size: 18, color: Colors.brown[400]),
                                ),
                              ],
                            ),
                          )
                        : SizedBox.shrink()),
                    25.verticalSpace,
                    LabelTextField(
                      isRequired: true,
                      checkValidation: true,
                      controller: controller.phoneEmailController,
                      label: 'userName',
                      hint: 'usernameHint',
                    ),
                    16.verticalSpace,
                    Obx(() => LabelTextField(
                          label: "password",
                          hint: "enterYourPassword",
                          isPassword: true,
                          validator: (value) {
                            return Validator.validatePassword(value: value!);
                          },
                          isArabicDirection: true,
                          checkValidation: true,
                          obscureText: controller.showPassword.value,
                          onSuffixTap: () => controller.updateShowPassword(),
                          controller: controller.passwordController,
                        )),
                    16.verticalSpace,
                    TextButton(
                      onPressed: () {
                        Get.toNamed(AppRoutes.forgotPasswordScreen);
                      },
                      child: Text(
                        'forgotPassword?'.tr,
                        style:
                            AppTextStyle.secondaryDarkBrownColor16spTextStyle1,
                      ),
                    ),
                    16.verticalSpace,
                    elevatedButton(
                        text: "login", onPressed: () => controller.logInUser()),
                    20.verticalSpace,
                    Center(
                      child: Text.rich(
                        TextSpan(
                          text: 'switchTo'.tr,
                          style:
                              AppTextStyle.secondaryPrimaryBlack16spTextStyle1,
                          children: [
                            TextSpan(
                              text: "loginWithUAEPass".tr,
                              style: AppTextStyle
                                  .secondaryDarkBrownColor16spTextStyle
                                  .copyWith(
                                      decoration: TextDecoration.underline,
                                      decorationColor:
                                          AppColors.secondaryDarkBrownColor),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Get.back();
                                },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
