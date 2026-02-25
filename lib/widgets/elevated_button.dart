import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/my_app/my_app.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';

Widget elevatedButton(
    {required String text,
    required VoidCallback? onPressed,
    Color? backgroundColor,
    Color txtColor = Colors.white,
    bool isClosed = false}) {
  final Color bgColor = isClosed
      ? AppColors.darkRedColor
      : backgroundColor ?? themeViewModel.color;

  return ElevatedButton(
    style: ButtonStyle(
        fixedSize: WidgetStatePropertyAll(Size(Get.width, 48.h)),
        backgroundColor: WidgetStatePropertyAll(bgColor),
        elevation: const WidgetStatePropertyAll(0),
        shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.r)))),
    onPressed: onPressed,
    child: Text(
      text.tr,
      maxLines: 1,
      style: TextStyle(
          fontSize: 14.sp,
          color: txtColor,
          fontWeight: FontWeight.w500),
    ),
  );
}
