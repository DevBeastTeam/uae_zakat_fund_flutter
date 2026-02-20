import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/model/receipt_details.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/widgets/receipt_project_widgets.dart';
import 'package:zakat_fund/widgets/status_chip.dart';

detailsBottomSheet(ReceiptDetails details) {
  Get.bottomSheet(
      SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Text(
                    "donationPreview".tr,
                    style: AppTextStyle.secondaryPrimaryBlack24spTextStyle1,
                  ),
                ),
                IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(
                      Icons.highlight_remove_outlined,
                      color: AppColors.secondaryPrimaryBlackColor,
                    ))
              ],
            ),
            buildInfoRow("transactionId", details.transactionId),
            8.verticalSpace,
            buildInfoRow("date", Utils.dateFormat1.format(details.createdDate)),
            8.verticalSpace,
            buildInfoRow(
                "method", Utils.getPaymentType(details.paymentType).tr),
            8.verticalSpace,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "status".tr,
                    style: AppTextStyle.secondaryBlack16spTextStyle3,
                  ),
                  statusChip(Utils.statusIntoString(
                      details.paymentType == 1 ? 2 : details.requestStatus)),
                ],
              ),
            ),
            16.verticalSpace,
            const Divider(color: AppColors.grey, height: 0),
            buildProjectContainear(details, isNew: true),
          ],
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(30.r))));
}

Widget buildInfoRow(String title, String value) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 16.w),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title.tr,
          style: AppTextStyle.secondaryBlack16spTextStyle3,
        ),
        Text(
          value,
          style: AppTextStyle.secondaryDarkGrey16spTextStyle,
        ),
      ],
    ),
  );
}
