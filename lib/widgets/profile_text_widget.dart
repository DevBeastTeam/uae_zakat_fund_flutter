import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/flavor/flavor_config.dart';
import 'package:zakat_fund/model/additional_documents.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_resources.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/utils/routes/app_routes.dart';
import 'package:zakat_fund/utils/utils.dart';

Widget profileTextWidget({required String label, required String value}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label.tr,
        style: AppTextStyle.primaryDarkGrey14spTextStyle1,
      ),
      8.verticalSpace,
      Utils.isArabic && label == "fax" ||
              Utils.isArabic && label == "phoneNumber" ||
              Utils.isArabic && label == "mobileNumberPrimary" ||
              Utils.isArabic && label == "mobileNumberSecondary"
          ? Directionality(
              textDirection: TextDirection.ltr,
              child: Text(
                value,
                style: AppTextStyle.black14spTextStyle1,
              ),
            )
          : Text(
              value,
              style: AppTextStyle.black14spTextStyle1,
            ),
      16.verticalSpace,
    ],
  );
}

Widget profileAttachWidget({required String label, required String value}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label.tr,
        style: AppTextStyle.primaryDarkGrey14spTextStyle1,
      ),
      8.verticalSpace,
      if (value != "")
        GestureDetector(
          onTap: () {
            if (Utils.isImageFile(value)) {
              Get.toNamed(AppRoutes.photoViewScreen, arguments: value);
              return;
            }
            Utils.openUrl("${FlavorConfig.storageUrl}$value");
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                AppResources.attachIcon,
                width: 14.w,
                height: 14.h,
                color: AppColors.quickDonateColor,
              ),
              6.horizontalSpace,
              Text(
                "attachment".tr,
                style: AppTextStyle.lightBrown12spTextStyle2,
              ),
            ],
          ),
        ),
      16.verticalSpace,
    ],
  );
}

Widget profileAdditionDocWidget(List<AdditionalDocuments> additionalDocuments) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        "additionalDocuments".tr,
        style: AppTextStyle.secondaryBlack14spTextStyle2,
      ),
      16.verticalSpace,
      ...List.generate(additionalDocuments.length, (index) {
        AdditionalDocuments document = additionalDocuments[index];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            profileAttachWidget(
                label: Utils.isArabic
                    ? document.documentNameAr
                    : document.documentName,
                value: document.selectedFileName),
            if (document.requiresDate)
              profileTextWidget(
                  label: Utils.isArabic
                      ? document.startDateAr!
                      : document.startDate!,
                  value: document.startDateController.text),
            if (document.endDate != null && document.endDate != "")
              profileTextWidget(
                  label:
                      Utils.isArabic ? document.endDateAr! : document.endDate!,
                  value: document.endDateController.text),
          ],
        );
      }),
    ],
  );
}
