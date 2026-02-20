import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/model/dashboard_data.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';

Widget statisticsContainer(DashboardData dashboardData) {
  return Container(
    padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 10.w),
    decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.lightGrey)),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          dashboardData.title.tr,
          style: AppTextStyle.secondaryPrimaryBlack12spTextStyle,
        ),
        2.verticalSpace,
        Text(
          dashboardData.value,
          style: AppTextStyle.darkBrown16spTextStyle1,
        )
      ],
    ),
  );
}