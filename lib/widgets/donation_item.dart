import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';

Container buildDonationItem(List<dynamic> data) {
  return Container(
    padding: EdgeInsets.symmetric(vertical: 10.h),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.lightGrey)),
    child: listItemWidget(data),
  );
}

Padding listItemWidget(List<dynamic> data) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 16.w),
    child: Column(
      children: List.generate(
          data.length,
              (dataIndex) => Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    data[dataIndex]["key"].toString().tr,
                    style: AppTextStyle.primaryDarkGrey12spTextStyle1,
                  ),
                  16.horizontalSpace,
                  Flexible(
                    child: Text(
                      data[dataIndex]["value"],
                      textAlign: TextAlign.right,
                      style: AppTextStyle
                          .secondaryPrimaryBlack12spTextStyle1,
                    ),
                  ),
                ],
              ),
              4.verticalSpace,
            ],
          )).toList(),
    ),
  );
}