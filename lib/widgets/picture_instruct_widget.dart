import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';

Widget pictureInstructWidget() {
  return Text(
    "maximumSize".tr,
    style: AppTextStyle.primaryDarkGrey12spTextStyle1,
  );
}

Widget fileInstructWidget({String hint="supportedFormat",String formats=""}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        "maximumSize".tr,
        style: AppTextStyle.primaryDarkGrey12spTextStyle1,
      ),
      4.verticalSpace,
      Text(
        hint.tr+formats,
        style: AppTextStyle.primaryDarkGrey12spTextStyle1,
      ),
    ],
  );
}
