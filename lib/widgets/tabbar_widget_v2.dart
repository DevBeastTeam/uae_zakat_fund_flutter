import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/my_app/my_app.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';

class TabBarWidgetV2 extends StatelessWidget {
  /// List of tab label strings to display.
  final List<String> tabs;

  /// Index of the currently selected tab.
  final int currentIndex;

  /// Called when a tab is tapped, with the tapped tab's index.
  final ValueChanged<int> onTabChanged;

  const TabBarWidgetV2({
    super.key,
    required this.tabs,
    required this.currentIndex,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Container(
        height: 50.h,
        padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 10),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.lightGrey),
          borderRadius: BorderRadius.circular(40.r),
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(
              tabs.length,
              (index) => _buildTabItem(tabs[index], index),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabItem(String text, int index) {
    final isSelected = currentIndex == index;
    return GestureDetector(
      onTap: () => onTabChanged(index),
      child: Container(
        height: 36.h,
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        margin: EdgeInsets.symmetric(horizontal: 2.w),
        decoration: BoxDecoration(
          color: isSelected
              ? themeViewModel.color.withValues(alpha: 0.12)
              : Colors.transparent,
          // color: isSelected
          //     ? AppColors.secondaryDarkBrownColor.withValues(alpha: 0.12)
          //     : Colors.transparent,
          borderRadius: BorderRadius.circular(24.r),
        ),
        alignment: Alignment.center,
        child: Text(
          text.tr,
          style: isSelected
              ? AppTextStyle.themeTextColor14spTextStyle
              // ? AppTextStyle.secondaryDarkBrownColor14spTextStyle
              : AppTextStyle.greyColor14spTextStyle,
          maxLines: 1,
        ),
      ),
    );
  }
}
