import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/model/categories.dart';
import 'package:zakat_fund/my_app/my_app.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';

TabBar tabBarWidget(
  tabController,
  tabs,
  currentTab, {
  bool newTab = false,
  bool icon = false,
  List<Categories>? cats,
}) {
  return TabBar(
      dividerColor: Colors.transparent,
      indicatorColor: Colors.transparent,
      labelPadding: EdgeInsets.zero,
      splashBorderRadius: BorderRadius.circular(100.r),
      padding:
          newTab ? EdgeInsets.zero : const EdgeInsets.symmetric(vertical: 8),
      indicator: _buildIndicator(newTab),
      tabAlignment: TabAlignment.start,
      isScrollable: true,
      controller: tabController,
      labelStyle: _getLabelStyle(newTab),
      unselectedLabelStyle: _getUnselectedLabelStyle(newTab),
      tabs: icon
          ? _buildIconTabs(tabController, currentTab, cats!)
          : _buildTextTabs(tabController, currentTab, tabs));
}

TextStyle _getLabelStyle(bool isCustom) {
  return isCustom
      ? AppTextStyle.white12spTextStyle.copyWith(fontFamily: "Alexandria")
      : AppTextStyle.secondaryBlack14spTextStyle2
          .copyWith(fontFamily: "Alexandria");
}

TextStyle _getUnselectedLabelStyle(bool isCustom) {
  return isCustom
      ? AppTextStyle.newGreyColor12spTextStyle
          .copyWith(fontFamily: "Roboto")
      : AppTextStyle.darkGrey14spTextStyle.copyWith(fontFamily: "Roboto");
}

Decoration _buildIndicator(bool isCustom) {
  return ShapeDecoration(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100.r)),
    color: isCustom ? themeViewModel.color : Colors.white,
    shadows: isCustom
        ? null
        : [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              offset: const Offset(0, 2),
              blurRadius: 100,
            )
          ],
  );
}

List<Widget> _buildIconTabs(
    TabController tabController, int currentTab, List<Categories> cats) {
  final isSelected = tabController.index == currentTab;

  return cats
      .map<Widget>((tab) => Padding(
            padding: EdgeInsets.symmetric(
                horizontal: isSelected ? 16.w : 0, vertical: 10.h),
            child: Row(
              children: [
                SvgPicture.asset(
                  tab.icon!,
                  color: currentTab == cats.indexOf(tab)
                      ? Colors.white
                      : AppColors.newGreyColor,
                  width: 16.w,
                  height: 16.h,
                ),
                8.horizontalSpace,
                Text(
                  tab.name.tr,
                ),
              ],
            ),
          ))
      .toList();
}

List<Widget> _buildTextTabs(
    TabController tabController, int currentTab, List<String> tabs) {
  final isSelected = tabController.index == currentTab;
  return tabs
      .map<Widget>((tab) => Padding(
            padding: EdgeInsets.symmetric(horizontal: isSelected ? 16.w : 0),
            child: Tab(text: tab.toString().tr),
          ))
      .toList();
}
