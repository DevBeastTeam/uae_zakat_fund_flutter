import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/model/categories.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_resources.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/utils/utils.dart';

Widget accountMenuWidget(
    {required Categories tab,
    required VoidCallback? onTap,
    bool subTab = false}) {
  EdgeInsetsGeometry padding = subTab
      ? EdgeInsets.symmetric(horizontal: 20.w, vertical: 0)
      : EdgeInsets.symmetric(horizontal: 20.w);
  return ListTile(
    title: Text(
      tab.name.tr,
      style: AppTextStyle.secondaryPrimaryBlack16spTextStyle,
    ),
    splashColor: Colors.transparent,
    onTap: onTap,
    contentPadding: padding,
    leading: SvgPicture.asset(
      subTab ? AppResources.donationsIcon : tab.icon!,
      width: 20.w,
      height: 20.h,
      color: subTab ? Colors.white : AppColors.secondaryPrimaryBlackColor,
    ),
    dense: true,
    minVerticalPadding: subTab ? 0 : null,
    trailing: tab.isExpansion
        ? Transform.rotate(
            angle: tab.isOpen ? 1.6 : -1.6,
            child: Image.asset(
              AppResources.arrowRight,
              color: AppColors.secondaryPrimaryBlackColor,
            ))
        : Transform.flip(
            flipX: Utils.isArabic ? true : false,
            child: Image.asset(
              AppResources.arrowRight,
              width: 7.5.w,
              height: 13.75.h,
              color: AppColors.secondaryPrimaryBlackColor,
            )),
  );
}
