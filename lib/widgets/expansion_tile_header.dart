import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/my_app/my_app.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';

Widget expansionTileHeader(
    {required String title,
    required bool isExpanded,
    required VoidCallback? onTap}) {
  final IconData icon = isExpanded ? Icons.remove : Icons.add;
  return GestureDetector(
    onTap: onTap,
    child: Container(
      clipBehavior: Clip.hardEdge,
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
      decoration: BoxDecoration(
          color: themeViewModel.color,
          borderRadius: BorderRadius.circular(100.r)),
      child: Row(
        children: [
          Icon(icon, color: Colors.white),
          8.horizontalSpace,
          Flexible(
            child: Text(
              title.tr,
              style: AppTextStyle.white18spTextStyle,
            ),
          ),
        ],
      ),
    ),
  );
}
