import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';

Widget textFieldLabel({
  required String label,
  bool isRequired = false,
  bool isBlack = false,
}) {

  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Flexible(
        child: Text(label.tr,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyle.secondaryPrimaryBlack16spTextStyle3),
      ),
      if (isRequired)
        Text(
          " * ",
          style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.redColor,
              fontWeight: FontWeight.w700),
        )
    ],
  );
}
