import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/model/receipt_details.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/utils/utils.dart';

Container buildProjectContainear(ReceiptDetails? transactionDetails,
    {bool isNew = false}) {
  return Container(
    padding: EdgeInsets.symmetric(vertical: 16.h),
    margin: isNew
        ? EdgeInsets.zero
        : EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        border: isNew ? null : Border.all(color: AppColors.lightGrey)),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Text(
            "projects".tr,
            style: AppTextStyle.secondaryPrimaryBlack20spTextStyle2,
          ),
        ),
        8.verticalSpace,
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "projectName".tr,
                style: AppTextStyle.darkerGrey16spTextStyle,
              ),
              Text(
                "amount".tr,
                style: AppTextStyle.darkerGrey16spTextStyle,
              ),
            ],
          ),
        ),
        10.verticalSpace,
        Padding(
          padding:
              isNew ? EdgeInsets.symmetric(horizontal: 16.w) : EdgeInsets.zero,
          child: buildDivider(),
        ),
        Column(
          children: List.generate(transactionDetails!.projects.length, (index) {
            Detail project = transactionDetails.projects[index];
            return Column(
              children: [
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                  child: buildProjectLabels(
                      title: Utils.isArabic
                          ? project.projectNameArabic
                          : project.projectName,
                      value: '${"currency".tr} ${project.amount}'),
                ),
                Padding(
                  padding: isNew
                      ? EdgeInsets.symmetric(horizontal: 16.w)
                      : EdgeInsets.zero,
                  child: buildDivider(),
                ),
              ],
            );
          }),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: buildProjectLabels(
              title: "totalAmount",
              value: '${"currency".tr} ${transactionDetails.totalAmount}'),
        ),
      ],
    ),
  );
}

Row buildProjectLabels({required String title, required String value}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Flexible(
          child: Text(
        title.tr,
        style: AppTextStyle.secondaryPrimaryBlack13spTextStyle2,
      )),
      10.horizontalSpace,
      Text(
        value,
        style: AppTextStyle.secondaryPrimaryBlack13spTextStyle2,
      ),
    ],
  );
}

Widget buildDivider() => const Divider(
      color: AppColors.lightGrey,
      height: 0,
    );
