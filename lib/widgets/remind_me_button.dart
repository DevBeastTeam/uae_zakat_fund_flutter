import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_resources.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';

class RemindMeButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const RemindMeButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 35.h,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        iconAlignment: IconAlignment.end,
        style: ElevatedButton.styleFrom(
            elevation: 0,
            side: BorderSide(color: AppColors.lightBrownColor2),
            backgroundColor: AppColors.warningBackColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r))),
        icon: SvgPicture.asset(AppResources.timerIcon),
        label: Text(
          "remindMe".tr,
          style: AppTextStyle.lightBrown14spTextStyle5,
        ),
      ),
    );
  }
}
