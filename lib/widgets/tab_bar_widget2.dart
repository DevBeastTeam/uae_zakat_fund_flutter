import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';

Widget tabBarWidget2(
  TabController tabController,
  List<String> tabs,
  int currentTab,
) {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
    decoration: BoxDecoration(
      color: AppColors.lightGrey.withValues(alpha: 0.5),
      borderRadius: BorderRadius.circular(12.r),
    ),
    child: TabBar(
      controller: tabController,
      dividerColor: Colors.transparent,
      indicatorColor: Colors.transparent,
      labelPadding: EdgeInsets.zero,
      splashBorderRadius: BorderRadius.circular(10.r),
      padding: EdgeInsets.all(4.r),
      indicator: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            offset: const Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      tabAlignment: TabAlignment.fill,
      isScrollable: false,
      labelStyle: AppTextStyle.secondaryDarkBrownColor14spTextStyle.copyWith(
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: AppTextStyle.darkGrey14spTextStyle,
      tabs: tabs
          .map<Widget>(
            (tab) => Tab(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 4.w),
                child: Text(
                  tab.tr,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: currentTab == tabs.indexOf(tab)
                      ? AppTextStyle.secondaryDarkBrownColor14spTextStyle
                          .copyWith(fontWeight: FontWeight.w600)
                      : AppTextStyle.darkGrey14spTextStyle,
                ),
              ),
            ),
          )
          .toList(),
    ),
  );
}
