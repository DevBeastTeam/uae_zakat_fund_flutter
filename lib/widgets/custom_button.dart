import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/my_app/my_app.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_resources.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/utils/enums/button_type.dart';

class CustomButton extends StatelessWidget {
  final ButtonType buttonType;
  final VoidCallback onPressed;
  final String? text;

  const CustomButton({
    super.key,
    required this.buttonType,
    required this.onPressed,
    this.text,
  });

  @override
  Widget build(BuildContext context) {
    return _buildButton();
  }

  Widget _buildButton() {
    switch (buttonType) {
      case ButtonType.preview:
        return _outlinedButton(
          text: text??"preview",
          icon: const Icon(Icons.visibility_rounded,
              color: AppColors.primaryDarkBrownColor),
          backgroundColor: AppColors.warningBackColor,
        );
      case ButtonType.draft:
        return _outlinedButton(
          text: "saveAsDraft",
          icon: SvgPicture.asset(AppResources.draftIcon),
        );
      case ButtonType.submit:
        return _elevatedButton(text: "submitForReview");
      case ButtonType.cancel:
        return _elevatedButton(text: "cancel");
      case ButtonType.back:
        return _elevatedButton(text: "back");
    }
  }

  Widget _outlinedButton({
    required String text,
    required Widget icon,
    Color? backgroundColor,
  }) {
    return OutlinedButton.icon(
      style: OutlinedButton.styleFrom(
        side: BorderSide(width: 1.w, color: AppColors.darkBrownColor),
        backgroundColor: backgroundColor ?? Colors.transparent,
        minimumSize: Size(Get.width, 45.h),
      ),
      onPressed: onPressed,
      label: Text(
        text.tr,
        maxLines: 1,
        style: AppTextStyle.primaryDarkBrown16spTextStyle1,
      ),
      icon: icon,
    );
  }

  Widget _elevatedButton({required String text}) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        fixedSize: Size(Get.width, 45.h),
        backgroundColor: text != "submitForReview"
            ? AppColors.lightGreyColor
            : themeViewModel.color,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100.r),
        ),
      ),
      onPressed: onPressed,
      child: Text(
        text.tr,
        maxLines: 1,
        style: TextStyle(
          fontSize: 16.sp,
          fontFamily: 'Alexandria',
          color: AppColors.btnTextColor,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
