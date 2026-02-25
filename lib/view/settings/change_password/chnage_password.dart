import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/validator.dart';
import 'package:zakat_fund/view_model/chnage_password_view_model.dart';
import 'package:zakat_fund/widgets/elevated_button.dart';
import 'package:zakat_fund/widgets/label_text_field.dart';
import 'package:zakat_fund/widgets/my_app_bar.dart';
import 'package:zakat_fund/widgets/password_match_widget.dart';

class ChangePasswordScreen extends GetView<ChangePasswordViewModel> {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: myAppBar(title: "changePassword"),
      body: _buildBody(),
    );
  }

  KeyboardDismissOnTap _buildBody() {
    return KeyboardDismissOnTap(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
        child: Form(
          key: controller.formKey,
          child: Column(
            children: [
              Obx(() => LabelTextField(
                    label: "currentPassword",
                    isPassword: true,
                    validator: (value) => Validator.validatePassword(value: value!),
                    checkValidation: true,
                    isArabicDirection: true,
                    controller: controller.currentPasswordController,
                    obscureText: controller.showCurrentPassword.value,
                    onSuffixTap: () => controller.updateCurrentPassword(),
                  )),
              16.verticalSpace,
              Obx(() => LabelTextField(
                    label: "newPassword",
                    isPassword: true,
                    validator: (value) => Validator.validatePassword(value: value!),
                    onChanged: (val) => controller.validatePassword(val),
                    checkValidation: true,
                    isArabicDirection: true,
                    controller: controller.passwordController,
                    obscureText: controller.showPassword.value,
                    onSuffixTap: () => controller.updateShowPassword(),
                  )),
              16.verticalSpace,
              Obx(() => LabelTextField(
                    label: "confirmNewPassword",
                    checkValidation: true,
                    isArabicDirection: true,
                    validator: (value) => Validator.validateConfirmPassword(
                          pass2: value!,
                          pass1: controller.passwordController.text),
                    controller: controller.confirmPasswordController,
                    isPassword: true,
                    obscureText: controller.showConfirmPassword.value,
                    onSuffixTap: () => controller.updateShowConfirmPassword(),
                  )),
              20.verticalSpace,
              Obx(() => controller.passwordEmpty.value
                  ? const SizedBox.shrink()
                  : buildPasswordErrors(controller)),
              20.verticalSpace,
              elevatedButton(
                text: "changePassword",
                onPressed: ()=>controller.changePassword(),
              ),
              16.verticalSpace,
              elevatedButton(
                  text: "cancel",
                  onPressed: () => Get.back(),
                  backgroundColor: AppColors.lightGreyColor),
            ],
          ),
        ),
      ),
    );
  }
}
