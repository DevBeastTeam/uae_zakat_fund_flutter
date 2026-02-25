import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/view_model/association_view_model.dart';

Widget welcomeNoteContainer() {
  final BorderSide side = BorderSide(color: AppColors.darkGreenColor, width: 2.w);
  final BorderSide leftBorderSide = Utils.isArabic ? BorderSide.none : side;
  final BorderSide rightBorderSide = Utils.isArabic ? side : BorderSide.none;
  return Container(
      margin: EdgeInsets.only(left: 16.w, right: 16.w, top: 16.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 13.h),
      decoration: BoxDecoration(
        color: AppColors.lightGreen,
        borderRadius: BorderRadius.circular(20.r),
        border: Border(
          left: leftBorderSide,
          right: rightBorderSide,
        ),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        dense: true,
        trailing: GestureDetector(
          onTap: () => Get.find<AssociationViewModel>().showWelcome.value = false,
          child: const Icon(
            Icons.cancel_outlined,
            color: AppColors.darkGreenColor,
          ),
        ),
        horizontalTitleGap: 8.w,
        titleTextStyle: AppTextStyle.darkGreen16spTextStyle,
        subtitleTextStyle: AppTextStyle.secondaryPrimaryBlack12spTextStyle,
        title: Padding(
          padding: EdgeInsets.only(bottom: 8.h),
          child: Text("welcome".tr),
        ),
        subtitle: Text("welcomeMessage".tr),
      ),
    );
}
