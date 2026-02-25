import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/my_app/my_app.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/routes/app_routes.dart';
import 'package:zakat_fund/utils/utils.dart';

Widget activityLogBtn(
    {required dynamic model,
    required int? status,
    required int? id,
    required String type}) {
  if (model == null || status == 8) {
    return SizedBox.shrink();
  }
    return Align(
      alignment: Utils.isArabic ? Alignment.centerLeft : Alignment.centerRight,
      child: ElevatedButton.icon(
        style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(themeViewModel.color),
            elevation: const WidgetStatePropertyAll(0),
            shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100.r)))),
        onPressed: () => Get.toNamed(AppRoutes.activityLogScreen, arguments: {"id": id, "type": type}),
        label: Text(
          "activityLog".tr,
          style: TextStyle(
              fontSize: 16.sp,
              fontFamily: 'Alexandria',
              color: AppColors.btnTextColor,
              fontWeight: FontWeight.w500),
        ),
        icon: const Icon(
          Icons.timer_outlined,
          color: AppColors.btnTextColor,
          size: 20,
        ),
      ),
    );


}
