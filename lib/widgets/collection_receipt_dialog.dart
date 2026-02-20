import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/model/cash_notes.dart';
import 'package:zakat_fund/model/task_receipt.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_resources.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/utils/pdf_helper.dart';
import 'package:zakat_fund/view_model/theme_view_model.dart';
import 'package:zakat_fund/widgets/cache_image.dart';
import 'package:zakat_fund/widgets/cash_receipt.dart';

receiptDialog(
    {required bool isCash,
    required List<String> imagesList,
    required var cashData,
    required List<CashNotes> cashNotes,
    required int totalAmount,
    required TaskReceipt details}) async {
  await Get.dialog(
      AlertDialog(
        backgroundColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(vertical: 16.h),
        insetPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        content: SizedBox(
          width: Get.width,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Row(
                  children: [
                    const Spacer(),
                    Text(
                      "yourReceipt".tr,
                      style: AppTextStyle.secondaryPrimaryBlack18spTextStyle1,
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        Get.back();
                        Get.back(result: true);
                      },
                      child: SvgPicture.asset(
                        AppResources.closeCircleIcon,
                      ),
                    ),
                  ],
                ),
              ),
              16.verticalSpace,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: cashReceipt(cashData),
              ),
              16.verticalSpace,
              SizedBox(
                height: 110.h,
                child: ListView.separated(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) => ClipRRect(
                      borderRadius: BorderRadius.circular(8.r),
                      child: CachedImage(
                        image: imagesList[index],
                        width: 130.w,
                        height: 110.h,
                      )),
                  itemCount: imagesList.length,
                  separatorBuilder: (BuildContext context, int index) =>
                      16.horizontalSpace,
                ),
              ),
              if (isCash)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: buildCashNotesContainer(
                      cashNotes: cashNotes, totalAmount: totalAmount),
                ),
              16.verticalSpace,
              Align(
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () =>
                          PDFHelper.generateTaskCollectionReceiptPdf(details,
                              isPreview: true),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          side: BorderSide(
                              color: Get.find<ThemeViewModel>().color),
                          elevation: 0),
                      child: Text(
                        "view".tr,
                        style: TextStyle(
                            fontSize: 14.sp,
                            color: Get.find<ThemeViewModel>().color,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    16.horizontalSpace,
                    ElevatedButton(
                      onPressed: () =>
                          PDFHelper.generateTaskCollectionReceiptPdf(details),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Get.find<ThemeViewModel>().color,
                          elevation: 0),
                      child: Text(
                        "download".tr,
                        style: TextStyle(
                            fontSize: 14.sp,
                            color: AppColors.btnTextColor,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      barrierDismissible: false);
}

Widget buildCashNotesContainer(
        {required List<CashNotes> cashNotes, required int totalAmount}) =>
    Container(
      margin: EdgeInsets.only(top: 16.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
          color: AppColors.grayColor),
      child: Column(children: [
        ...List.generate(
            cashNotes.length,
            (index) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                              '${cashNotes[index].notes}x${cashNotes[index].amount}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyle.secondaryBlack16spTextStyle2),
                        ),
                        4.horizontalSpace,
                        Flexible(
                          child: Text(
                              '${cashNotes[index].totalAmount} ${"currency".tr}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyle.secondaryBlack16spTextStyle2),
                        ),
                      ],
                    ),
                    8.verticalSpace
                  ],
                )),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('total'.tr, style: AppTextStyle.secondaryBlack18spTextStyle2),
            Text('$totalAmount ${"currency".tr}',
                style: AppTextStyle.secondaryBlack18spTextStyle2),
          ],
        ),
      ]),
    );
