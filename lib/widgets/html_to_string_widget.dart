import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';

Container buildHtmlContainer(String data) {
  return Container(
    width: Get.width,
    constraints: BoxConstraints(maxHeight: 110.h, minHeight: 40.h),
    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
    decoration: BoxDecoration(
        color: AppColors.lightGreyColor,
        borderRadius: BorderRadius.circular(20.r),
        border:
        Border.all(width: 1.w, color: AppColors.secondaryLightGreyColor)),
    child: HtmlWidget(
      data,
      renderMode: RenderMode.listView,
      textStyle: AppTextStyle.secondaryBlack14spTextStyle1,
    ),
  );
}