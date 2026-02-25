import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';

IconButton buildIconButton(
    {required String icon,
      Color? color,
    required void Function()? onPressed,
    bool isLink = false}) {
  return IconButton(
    padding: EdgeInsets.zero,
    visualDensity: VisualDensity.compact,
    onPressed: onPressed,
    icon: SvgPicture.asset(
      icon,
      color: color??AppColors.secondaryDarkBrownColor,
      width: isLink?20.w:null,
      height: isLink?20.h:null,
    ),
  );
}
