import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_resources.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/utils/utils.dart';

Widget pleaseNoteContainer(
        {String? title, String? message, bool success = false,bool isNew=false}) =>
    Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 0.h),
      decoration: BoxDecoration(
        color: success ? AppColors.accentGreen : AppColors.warningBackColor,
        borderRadius: BorderRadius.circular(20.r),
        border: Border(
          left: Utils.isArabic
              ? BorderSide.none
              : BorderSide(
                  color: success
                      ? AppColors.darkerGreenColor
                      : AppColors.lightBrownColor,
                  width: 2.w),
          right: Utils.isArabic
              ? BorderSide(
                  color: success
                      ? AppColors.darkerGreenColor
                      : AppColors.lightBrownColor,
                  width: 2.w)
              : BorderSide.none,
        ),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        isThreeLine: title != null && message != null&&!isNew,
        dense: title != null && message != null&&!isNew,
        horizontalTitleGap: 8.w,
        leading: isNew?null:success
            ? const Icon(
                CupertinoIcons.checkmark_alt_circle,
                color: AppColors.darkerGreenColor,
              )
            : title != null && message != null
                ? Image.asset(AppResources.warningIcon,
                    width: 24.w, height: 24.h)
                : null,
        titleTextStyle: success
            ? AppTextStyle.darkerGreen14spTextStyle
            : message == null
                ? AppTextStyle.secondaryPrimaryBlack14spTextStyle
                : AppTextStyle.darkBrown16spTextStyle,
        subtitleTextStyle: AppTextStyle.secondaryPrimaryBlack12spTextStyle,
        title: Padding(
          padding: EdgeInsets.only(bottom: 8.h),
          child: Text(title!.tr),
        ),
        subtitle: message != null ? Text(message.tr) : null,
      ),
    );
