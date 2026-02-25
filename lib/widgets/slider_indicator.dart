import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';

SizedBox buildSliderIndicator(int currentIndex, {int length=4}) {
  return SizedBox(
    height: 8.h,
    child: ListView.separated(
      shrinkWrap: true,
      itemCount: length,
      scrollDirection: Axis.horizontal,
      separatorBuilder: (_, __) => SizedBox(width: 4.w),
      itemBuilder: (_, index) => _buildIndicator(isActive: index == currentIndex),

    ),
  );
}

Widget _buildIndicator({required bool isActive}) {
  return AnimatedContainer(
    duration: const Duration(milliseconds: 300),
    curve: Curves.easeInOut,
    width: isActive ? 27.w : 8.w,
    height: 8.h,
    decoration: BoxDecoration(
      color: isActive ? AppColors.lightBrownColor : AppColors.secondaryLightGreyColor,
      borderRadius: BorderRadius.circular(isActive ? 5.r : 100.r), // large value = circle
    ),
  );
}