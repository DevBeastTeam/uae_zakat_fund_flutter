import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/model/user.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/widgets/elevated_button.dart';

import '../my_app/my_app.dart';

updateEmailAddressPopUp({required VoidCallback onConfirm}) {
  final User? switchAccountUser = switchAccountBox.isNotEmpty?switchAccountBox.getAt(0):null;
  Get.dialog(AlertDialog(
    backgroundColor: Colors.white,
    contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
    insetPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text("updateEmailAddress".tr,style: AppTextStyle.secondaryPrimaryBlack16spTextStyle),
        8.verticalSpace,
        Text(switchAccountUser!=null&&switchAccountUser.roles.length>1?"updateEmailAddressMessage1".tr:"updateEmailAddressMessage2".tr,style: AppTextStyle.secondaryPrimaryBlack16spTextStyle1),
        20.verticalSpace,
        Row(
          children: [
            Expanded(
              child: elevatedButton(
                text: 'cancel',
                backgroundColor: AppColors.lightGreyColor,
                onPressed: ()=>Get.back(),
              ),
            ),
            10.horizontalSpace,
            Expanded(
              child: elevatedButton(
                text: 'confirm',
                onPressed: onConfirm,
              ),
            ),
          ],
        )
      ],
    ),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
  ));
}