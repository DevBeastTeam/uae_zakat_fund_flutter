import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_resources.dart';
import 'package:zakat_fund/utils/utils.dart';

Widget buildHeader({required String title,required VoidCallback? onPressed}) => Padding(
  padding: EdgeInsets.symmetric(horizontal: 16.w),
  child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Expanded(
        child: Text(
          title.tr,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: AppColors.darkBrownColor,
            fontSize: 18.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      TextButton.icon(
        onPressed: onPressed,
        style: TextButton.styleFrom(padding: EdgeInsets.zero),
        iconAlignment: IconAlignment.end,
        label: Text(
          "viewMore".tr,
          style: TextStyle(
            color: AppColors.darkBrownColor,
            fontWeight: FontWeight.w500,
            fontSize: 12.sp,
          ),
        ),
        icon: Image.asset(
          Utils.isArabic
              ? AppResources.arrowLeftFillIcon
              : AppResources.arrowRightFillIcon,
          width: 16.w,
          height: 16.h,
        ),
      )
    ],
  ),
);