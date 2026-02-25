import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/model/project.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/utils.dart';

Column buildFeatureColumn(
  ProjectElements project,
  String title,
) {
  final bool isCollected = title == "collected";
  final int amount = _resolveAmount(project, isCollected);
  final String formattedAmount = "${Utils.getCurrency(amount)} ${"currency".tr}";
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title.tr,
        style: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.w400,
          color: AppColors.lightGrey1,
        ),
      ),
      Text(
      formattedAmount,
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
          color: AppColors.lightGreyColor,
        ),
      ),
    ],
  );
}

int _resolveAmount(ProjectElements project, bool isCollected) {
  if (isCollected) {
    return project.totalDonations?.toInt() ?? 0;
  } else if (project.remainingAmount != null) {
    return project.remainingAmount!.toInt();
  } else {
    return double.tryParse(project.projectAmountObjective.toString())?.round() ?? 0;
  }
}
