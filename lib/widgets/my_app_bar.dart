import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/my_app/my_app.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_resources.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/utils/routes/app_routes.dart';
import 'package:zakat_fund/view_model/cart_view_model.dart';
import 'package:zakat_fund/view_model/main_view_model.dart';

AppBar myAppBar({required String title, List<Widget>? customActions}) {
  final viewModel = Get.find<MainViewModel>();
  var cartViewModel = Get.find<CartViewModel>();

  return AppBar(
    backgroundColor: Colors.white,
    title: Text(title.tr, style: AppTextStyle.darkBlack18spTextStyle),
    centerTitle: true,
    actions: [
      if (customActions != null) ...customActions,
      if (userBox.isNotEmpty)
        Obx(() => GestureDetector(
              onTap: () {
                Get.toNamed(AppRoutes.notificationScreen);
              },
              child: Badge(
                label: Text(
                  '${viewModel.notificationCount.value}',
                  style: AppTextStyle.white12spTextStyle,
                ),
                offset: Offset(0, 4),
                isLabelVisible: viewModel.notificationCount.value > 0,
                backgroundColor: Colors.red,
                child: _circleButton(icon: AppResources.notificationIcon),
              ),
            )),
      16.horizontalSpace,
      if (Get.currentRoute != AppRoutes.cartScreen)
        GestureDetector(
          onTap: () {
            cartViewModel.resetData();
            cartViewModel.fetchCart(showLoading: true);
            Get.toNamed(AppRoutes.cartScreen);
          },
          child: Obx(() => Badge(
                label: Text(
                  '${cartViewModel.cartCount.value}',
                  style: AppTextStyle.white12spTextStyle,
                ),
                offset: Offset(0, -3),
                isLabelVisible: cartViewModel.cartCount.value > 0,
                backgroundColor: Colors.red,
                child: SvgPicture.asset(
                  AppResources.cartIcon,
                  width: 32.w,
                  height: 32.h,
                ),
              )),
        ),
      16.horizontalSpace,
    ],
  );
}

Widget _circleButton({required String icon}) {
  return Container(
    height: 40.h,
    width: 40.w,
    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
    decoration: BoxDecoration(
      color: Colors.white,
      shape: BoxShape.circle,
      border: Border.all(
          color: AppColors.lightGreyColor,
          width: 1.0.w,
          style: BorderStyle.solid),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.01),
          offset: const Offset(0.0, 4.0),
          blurRadius: 50.0,
        ),
      ],
    ),
    child: SvgPicture.asset(icon),
  );
}
