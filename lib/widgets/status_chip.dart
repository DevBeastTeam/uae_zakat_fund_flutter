import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/utils/utils.dart';

Widget statusChip(String status) {
  return Container(
    height: 36.h,
    padding: EdgeInsets.symmetric(horizontal: 16.w),
    alignment: Alignment.center,
    decoration: BoxDecoration(
        color: Utils.getStatusColor(status).withOpacity(0.10),
        borderRadius: BorderRadius.circular(10.r)),
    child: Text(
      status.tr,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: AppTextStyle.generic12spTextStyle
          .copyWith(color: Utils.getStatusColor(status)),
    ),
  );
}