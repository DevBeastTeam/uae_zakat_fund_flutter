import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/model/dashboard_data.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';

Container dashboardContainer({required DashboardData data}) {
  return Container(
    margin: EdgeInsets.only(bottom: 16.h),
    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.all(Radius.circular(15.r)),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          offset: const Offset(0.0, 4.0),
          blurRadius: 150.0,
        ),
      ],
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          data.title.tr,
          style: AppTextStyle.secondaryPrimaryBlack14spTextStyle,
        ),
        8.verticalSpace,
        Text(data.value, style: AppTextStyle.btnText18spTextStyle)
      ],
    ),
  );
}