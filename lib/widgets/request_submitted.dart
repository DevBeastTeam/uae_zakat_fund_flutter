import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_resources.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';

Widget buildRequestSubmitted() {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 16.w),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        20.verticalSpace,
        Image.asset(
          AppResources.tickCircleIcon,
          width: 56.w,
          height: 56.h,
        ),
        16.verticalSpace,
        Text(
          "thankYou!".tr,
          textAlign: TextAlign.center,
          style: AppTextStyle.secondaryPrimaryBlack26spTextStyle1,
        ),
        4.verticalSpace,
        Text(
          "requestPendingMessage".tr,
          textAlign: TextAlign.center,
          style: AppTextStyle.darkGrey114spTextStyle,
        ),
        20.verticalSpace,
        OutlinedButton.icon(
          style: OutlinedButton.styleFrom(
            side: BorderSide(width: 2.w, color: AppColors.darkBrownColor),
            minimumSize: Size(Get.width, 56.h),
          ),
          onPressed: ()=>Get.back(result: true),
          label: Text(
            "goToDashboard".tr,
            maxLines: 1,
            style: AppTextStyle.primaryDarkBrown16spTextStyle1,
          ),
          icon: const Icon(
            Icons.keyboard_backspace_outlined,
            color: AppColors.primaryDarkBrownColor,
          ),
        ),
      ],
    ),
  );
}