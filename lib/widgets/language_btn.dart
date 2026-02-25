import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/my_app/my_app.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';

Expanded buildButton(selectedLanguage, bool english, index,{required void Function() onPressed}) {
  return Expanded(
    child: OutlinedButton(
      onPressed: onPressed,
      style: ButtonStyle(
          backgroundColor: selectedLanguage == index
              ?  WidgetStatePropertyAll(themeViewModel.color)
              : null,
          fixedSize: WidgetStatePropertyAll(Size(Get.width, 45.h)),
          side: WidgetStatePropertyAll(
              BorderSide(width: 0.5.w, color: const Color(0xffD1D0D1))),
          shape: WidgetStatePropertyAll(RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50.r)))),
      child: Text(
        english ? "English" : "العربية",
        style: selectedLanguage == index
            ? TextStyle(
                color: Colors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600)
            : TextStyle(
                color: AppColors.darkGreyColor,
                fontSize: 16.sp,
                fontWeight: FontWeight.w400),
      ),
    ),
  );
}
