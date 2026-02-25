import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/model/password_validation.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';

Widget buildPasswordErrors(controller) =>
    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      4.verticalSpace,
      Text("passwordMustBe".tr,
          style: AppTextStyle.secondaryPrimaryBlack14spTextStyle1),
      8.verticalSpace,
      Obx(() => Column(
          children: controller.passwordErrors
              .map<Widget>((message) => buildPasswordWarningItem(message: message))
              .toList())),
    ]);

Widget buildPasswordWarningItem({required PasswordValidation message}) {
  return Column(
    children: [
      Row(children: [
        Icon(
          message.isError ? Icons.cancel : Icons.check_circle,
          size: 16.h,
          color: message.isError ? AppColors.redColor : AppColors.greenColor,
        ),
        8.horizontalSpace,
        Text(
          message.error.tr,
          style: message.isError
              ? AppTextStyle.red12spTextStyle
              : AppTextStyle.green12spTextStyle,
        ),
      ]),
      4.verticalSpace
    ],
  );
}