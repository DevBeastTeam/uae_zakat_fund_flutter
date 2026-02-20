import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/utils/validator.dart';
import 'package:zakat_fund/view_model/forgot_password_view_model.dart';
import 'package:zakat_fund/widgets/elevated_button.dart';
import 'package:zakat_fund/widgets/label_text_field.dart';
import 'package:zakat_fund/widgets/my_app_bar.dart';

class ForgotPasswordScreen extends GetView<ForgotPasswordViewModel> {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: myAppBar(title: ""),
      body: _buildBody(),
    );
  }

  KeyboardDismissOnTap _buildBody() {
    return KeyboardDismissOnTap(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeading(),
              8.verticalSpace,
              _buildSubHeading(),
              20.verticalSpace,
              _buildEmailPhoneTextField(),
              20.verticalSpace,
              elevatedButton(
                text: "send",
                onPressed: () => controller.sendForgotPassword(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ElevatedButton _buildRememberPasswordBtn() {
    return ElevatedButton.icon(
      style: ButtonStyle(
        fixedSize: WidgetStatePropertyAll(Size(Get.width, 56.h)),
        backgroundColor:
            const WidgetStatePropertyAll(AppColors.chipBackgroundColor),
        elevation: const WidgetStatePropertyAll(0),
      ),
      onPressed: () => Get.back(),
      label: Text(
        "rememberedPassword".tr,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTextStyle.primaryDarkBrown16spTextStyle1,
      ),
      icon: const Icon(
        Icons.keyboard_backspace_outlined,
        color: AppColors.primaryDarkBrownColor,
      ),
    );
  }

  Form _buildEmailPhoneTextField() {
    return Form(
      key: controller.formKey,
      child: LabelTextField(
        label: "emailOrPhone",
        isArabicDirection: true,
        checkValidation: true,
        validator: (value) {
          return Validator.validateEmailOrPhoneEmpty(value: value!);
        },
        controller: controller.phoneEmailController,
      ),
    );
  }

  Text _buildSubHeading() {
    return Text(
      "forgotPasswordMessage".tr,
      style: AppTextStyle.primaryDarkGrey14spTextStyle1.copyWith(height: 0),
    );
  }

  Text _buildHeading() {
    return Text(
      "forgotPassword?".tr,
      style: AppTextStyle.secondaryDarkBrown36spTextStyle.copyWith(height: 0),
    );
  }
}
