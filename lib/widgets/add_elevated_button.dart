import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/my_app/my_app.dart';
import 'package:zakat_fund/utils/constants/app_resources.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';

Widget addElevatedButton(
    {required VoidCallback? onPressed,
    required String text,
    String icon = AppResources.addIcon}) {
  return ElevatedButton.icon(
    style: ButtonStyle(
      fixedSize: WidgetStatePropertyAll(Size(Get.width, 40.h)),
      backgroundColor: WidgetStatePropertyAll(themeViewModel.color),
      elevation: const WidgetStatePropertyAll(0),
    ),
    onPressed: onPressed,
    label: Text(
      text.tr,
      style: AppTextStyle.white14spTextStyle1,
    ),
    icon: SvgPicture.asset(icon),
  );
}
