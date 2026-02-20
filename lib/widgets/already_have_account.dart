import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/utils/routes/app_routes.dart';

Widget buildAlreadyHaveAccount() {
  return Align(
    alignment: Alignment.center,
    child: RichText(
      text: TextSpan(
          text: 'haveAccount?'.tr,
          style: AppTextStyle.darkerGrey14spTextStyle.copyWith(fontFamily: 'Alexandria'),
          children: <TextSpan>[
            TextSpan(
                text: 'login'.tr,
                style: AppTextStyle.primaryDarkBrown14spTextStyle1
                    .copyWith(decoration: TextDecoration.underline,fontFamily: 'Alexandria'),
                recognizer: TapGestureRecognizer()
                  ..onTap = () => Get.until((route) => route.settings.name == AppRoutes.logInScreen))
          ]),
    ),
  );
}