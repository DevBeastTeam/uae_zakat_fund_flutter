import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/model/dashboard_data.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/view_model/cart_view_model.dart';
import 'package:zakat_fund/view_model/main_view_model.dart';

class BottomNavBar extends StatelessWidget {
  BottomNavBar({super.key});

  final MainViewModel controller = Get.find();
  final CartViewModel cartViewModel = Get.find();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 8.w),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: controller.bottomNavItems
            .map((item) => _buildNavItem(item))
            .toList(),
      ),
    );
  }

  Widget _buildNavItem(DashboardData item) {
    return Obx(() {
      final currentIndex = controller.currentIndex.value;
      final index = controller.bottomNavItems.indexOf(item);
      final bool isSelected = index == currentIndex;

      return GestureDetector(
        onTap: () => controller.switchTab(index),
        child: Container(
          padding: isSelected
              ? EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h)
              : EdgeInsets.all(4.r),
          decoration: isSelected
              ? BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xff4B4F58),
                      Color(0xff9EA2A9),
                    ],
                  ),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24.r),
                      topRight: Radius.circular(24.r),
                      bottomLeft: Radius.circular(8.r),
                      bottomRight: Radius.circular(8.r)),
                )
              : null,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                isSelected ? item.value : item.icon!,
                width: 18.w,
                height: 18.h,
              ),
              4.verticalSpace,
              Text(
                item.title.tr,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: isSelected
                    ? AppTextStyle.white16spTextStyle.copyWith(fontSize: 14)
                    : AppTextStyle.bottomBarTextColor16spTextStyle
                        .copyWith(fontSize: 14),
              )
            ],
          ),
        ),
      );
    });
  }
}
