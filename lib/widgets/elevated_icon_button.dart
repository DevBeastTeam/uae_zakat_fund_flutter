import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/my_app/my_app.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';

Widget elevatedIconButton(
    {required String text,
    required VoidCallback? onPressed,
    bool next = true,
    Color? backgroundColor}) {
  final Color bgColor = backgroundColor ?? themeViewModel.color;
  final IconData icon = next ? CupertinoIcons.right_chevron : CupertinoIcons.left_chevron;
  final IconAlignment iconAlignment = next ? IconAlignment.end : IconAlignment.start;

  return ElevatedButton.icon(
    style: ButtonStyle(
      fixedSize: WidgetStatePropertyAll(Size(Get.width, 45.h)),
      backgroundColor: WidgetStatePropertyAll(bgColor),
      elevation: const WidgetStatePropertyAll(0),
    ),
    onPressed: onPressed,
    label: Text(
      text.tr,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: next?AppTextStyle.white18spTextStyle1:AppTextStyle.btnText18spTextStyle,
    ),
    iconAlignment: iconAlignment,
    icon: Icon(
      icon,
      color: AppColors.btnTextColor,
    ),
  );
}
