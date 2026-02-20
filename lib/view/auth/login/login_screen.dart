import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/utils/routes/app_routes.dart';
import 'package:zakat_fund/view_model/log_in_view_model.dart';
import 'package:zakat_fund/widgets/emirate_id_btn.dart';
import 'package:zakat_fund/widgets/my_app_bar.dart';

class LoginScreen extends GetView<LogInViewModel> {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: myAppBar(title: "login"),
      body: Center(
        child: Container(
          constraints: BoxConstraints(minHeight: 580.h, maxHeight: 580.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: AppColors.brownPrimaryColor),
          ),
          padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 25.h),
          margin: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "loginWithEmiratesId".tr,
                style: AppTextStyle.secondaryPrimaryBlack24spTextStyle2,
              ),
              Spacer(),
              buildEmiratesBtn(
                title: 'loginWithEmiratesId',
                onPressed: () => controller.uaePassSignIn(false),
              ),
              const SizedBox(height: 16),
              Text(
                "uaePassSignInMessage".tr,
                textAlign: TextAlign.center,
                style: AppTextStyle.secondaryPrimaryBlack12spTextStyle,
              ),
              Spacer(),
              Text.rich(
                TextSpan(
                  text: 'haveLegacyAccount'.tr,
                  style: AppTextStyle.secondaryPrimaryBlack16spTextStyle1,
                  children: [
                    TextSpan(
                      text: "loginHere".tr,
                      style: AppTextStyle.secondaryDarkBrownColor16spTextStyle
                          .copyWith(
                              decoration: TextDecoration.underline,
                              decorationColor:
                                  AppColors.secondaryDarkBrownColor),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Get.toNamed(AppRoutes.legacyLoginScreen);
                        },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
