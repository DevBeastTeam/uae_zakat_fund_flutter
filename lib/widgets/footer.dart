import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zakat_fund/utils/constants/app_resources.dart';

Widget buildFooter() {
  return Directionality(
    textDirection: TextDirection.ltr,
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Flexible(child: Image.asset(AppResources.uaeLogo)),
          20.horizontalSpace,
          Flexible(flex: 5,child: Image.asset(AppResources.awqafLogo),),
          20.horizontalSpace,
          Flexible(child: Image.asset(AppResources.weUAELogo)),
        ],
      ),
    ),
  );
}
