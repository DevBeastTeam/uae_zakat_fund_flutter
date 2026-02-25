import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';

Container buildContainer({required Widget child}) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.lightGrey)),
    child: child,
  );
}