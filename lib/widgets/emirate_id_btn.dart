import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_resources.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';

Widget buildEmiratesBtn({
  required String title,
  required VoidCallback onPressed,
}) =>
    ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
          fixedSize: Size(Get.width, 48.h),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
          backgroundColor: AppColors.secondaryPrimaryBlackColor),
      icon: Image.asset(
        AppResources.fingerprintIcon,
        width: 24.w,
        height: 24.h,
      ),
      onPressed: onPressed,
      label: Text(
        title.tr,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTextStyle.white16spTextStyle,
      ),
    );
