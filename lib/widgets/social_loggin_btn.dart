import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_resources.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/view_model/log_in_view_model.dart';
import 'package:zakat_fund/widgets/more_signin.dart';

FittedBox buildSignInOptions(bool forRegister) {
  return FittedBox(
    child: Row(
      children: [
        _signInOptionBtn(
            icon: AppResources.googleIcon, label: "google", onTap: () {
              Get.find<LogInViewModel>().googleSigIn(forRegister);
        }),
        8.horizontalSpace,
        _signInOptionBtn(
            icon: AppResources.fbIcon, label: "facebook", onTap: () {
          Get.find<LogInViewModel>().fbSignIn(forRegister);
        }),
        8.horizontalSpace,
        _signInOptionBtn(
            icon: AppResources.moreIcon, label: "more", onTap: () {
          showLoginOptionsDialog(forRegister);
        }),
      ],
    ),
  );
}

Widget _signInOptionBtn(
    {required String icon, required String label, required Function()? onTap}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      width: 124.w,
      height: 45.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50.r),
        border: Border.all(
          color: AppColors.accentGreyColor,
          width: 1.0.w,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            icon,
            width: 16.w,
            height: 16.h,
          ),
          8.horizontalSpace,
          Flexible(
            child: Text(
              label.tr,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyle.darkBlack14spTextStyle,
            ),
          )
        ],
      ),
    ),
  );
}
