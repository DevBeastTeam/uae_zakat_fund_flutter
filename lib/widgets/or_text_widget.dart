import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';

Widget buildOrWidget() => Column(
      children: [
        20.verticalSpace,
        Row(
          children: [
            Expanded(
                child:
                    Container(color: AppColors.accentGreyColor, height: 1.h)),
            16.horizontalSpace,
            Text("or".tr, style: AppTextStyle.primaryDarkGrey14spTextStyle1),
            16.horizontalSpace,
            Expanded(
                child:
                    Container(color: AppColors.accentGreyColor, height: 1.h)),
          ],
        ),
        20.verticalSpace,
      ],
    );
