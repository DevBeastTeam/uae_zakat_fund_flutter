import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/my_app/my_app.dart';
import 'package:zakat_fund/utils/constants/app_resources.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/view_model/log_in_view_model.dart';

void showLoginOptionsDialog(bool forRegister) {
  final viewModel = Get.find<LogInViewModel>();
  Get.dialog(
    Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      backgroundColor: Colors.white,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "loginOptions".tr,
                  style: AppTextStyle.secondaryPrimaryBlack16spTextStyle,
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Get.back(),
                ),
              ],
            ),
            _buildLoginButton("google", AppResources.googleIcon, onPressed: () {
              Get.back();
              Get.find<LogInViewModel>().googleSigIn(forRegister);
            }),
            _buildLoginButton("facebook", AppResources.fbIcon, onPressed: () {
              Get.back();
              Get.find<LogInViewModel>().fbSignIn(forRegister);
            }),
            // _buildLoginButton("Twitter", AppResources.twitter, onPressed: () {
            //   Get.back();
            // }),
            if (Platform.isIOS)
              _buildLoginButton("apple", AppResources.applePayIcon1,
                  onPressed: () {
                Get.back();
                Get.find<LogInViewModel>().appleSignIn(forRegister);
              }),
            if (biometricsBox.isNotEmpty &&
                !forRegister &&
                viewModel.availableBiometrics.isNotEmpty)
              _buildLoginButton("biometricAuth", AppResources.touchId,
                  onPressed: () => viewModel.biometricLogin()),
          ],
        ),
      ),
    ),
  );
}

Widget _buildLoginButton(String title, String iconPath,
    {required VoidCallback onPressed}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        backgroundColor: Colors.white,
        side: const BorderSide(color: Colors.grey, width: 0.5),
        elevation: 0,
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            iconPath,
            height: 16.h,
            width: 16.w,
          ),
          const SizedBox(width: 10),
          Text(
            title.tr,
            style: AppTextStyle.darkBlack14spTextStyle1,
          ),
        ],
      ),
    ),
  );
}
