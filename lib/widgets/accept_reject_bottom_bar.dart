import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/widgets/elevated_button.dart';

Widget acceptRejectBottomBar({
  required VoidCallback? onAccept,
  VoidCallback? onReject,
  required VoidCallback? onReturn,
  VoidCallback? onPreview,
  String? btnText,
}) {
  final List<Widget> buttons = [];

  if (onAccept != null) {
    buttons.add(
      elevatedButton(
        text: btnText ?? "accept",
        onPressed: onAccept,
      ),
    );
  }

  if (onReturn != null) {
    if (buttons.isNotEmpty) buttons.add(10.verticalSpace);
    buttons.add(
      OutlinedButton(
        onPressed: onReturn,
        style: OutlinedButton.styleFrom(
          side: BorderSide(width: 1.w, color: AppColors.darkBrownColor),
          padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 16.w),
          backgroundColor: AppColors.chipBackgroundColor,
        ),
        child: Text(
          "return".tr,
          style: AppTextStyle.darkBrown16spTextStyle,
        ),
      ),
    );
  }

  if (onReject != null) {
    if (buttons.isNotEmpty) buttons.add(10.verticalSpace);
    buttons.add(
      ElevatedButton(
        onPressed: onReject,
        style: ElevatedButton.styleFrom(
          fixedSize: Size(Get.width, 45.h),
          backgroundColor: AppColors.lightRedColor1,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100.r),
          ),
        ),
        child: Text(
          "reject".tr,
          maxLines: 1,
          style: AppTextStyle.red16spTextStyle,
        ),
      ),
    );
  }

  if (buttons.isEmpty) {
    return const SizedBox.shrink();
  }

  return Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: buttons,
  );
}
