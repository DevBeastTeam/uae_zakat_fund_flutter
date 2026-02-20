import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/flavor/flavor_config.dart';
import 'package:zakat_fund/model/additional_documents.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_resources.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/utils/routes/app_routes.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/widgets/label_text_field.dart';
import 'package:zakat_fund/widgets/text_field_label.dart';

Widget fileViewWidget({required bool isImage, required String value}) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
    decoration: BoxDecoration(
        color: AppColors.lightGreyColor,
        borderRadius: BorderRadius.circular(50.r),
        border:
            Border.all(width: 1.w, color: AppColors.secondaryLightGreyColor)),
    child: Row(
      children: [
        SvgPicture.asset(
            isImage ? AppResources.imageIcon : AppResources.documentIcon),
        8.horizontalSpace,
        Expanded(
          child: Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyle.secondaryBlack14spTextStyle1,
          ),
        ),
        SizedBox(
          width: 25.w,
          height: 25.h,
          child: IconButton(
              onPressed: () {
                if(value!=""){
                  Utils.downloadFile(url: value);
                }
              },
              padding: EdgeInsets.zero,
              icon: SvgPicture.asset(AppResources.downloadIcon)),
        ),
        4.horizontalSpace,
        SizedBox(
          width: 25.w,
          height: 25.h,
          child: IconButton(
              onPressed: () {
                if (value == "") {
                  return;
                }
                if(Utils.isImageFile(value)){
                  Get.toNamed(AppRoutes.photoViewScreen,arguments: value);
                }else{
                  Utils.openUrl("${FlavorConfig.storageUrl}$value");

                }
              },
              padding: EdgeInsets.zero,
              icon: SvgPicture.asset(
                AppResources.eyeIcon,
                color: AppColors.darkerGreyColor,
              )),
        )
      ],
    ),
  );
}

Widget additionalDocumentViewWidget(AdditionalDocuments document) {
  bool showEndDate = document.endDate!=null&&document.endDate!="";
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Column(
        children: [
          16.verticalSpace,
          textFieldLabel(
              label: Utils.isArabic
                  ? document.documentNameAr
                  : document.documentName),
        4.verticalSpace,
          fileViewWidget(isImage: false, value: document.selectedFileName),
          if (document.requiresDate) 10.verticalSpace,
          if (document.requiresDate)
            LabelTextField(
              controller: document.startDateController,
              readOnly: true,
              label:
                  Utils.isArabic ? document.startDateAr! : document.startDate!,
              isDate: true,
            ),
            if(showEndDate)10.verticalSpace,
          if(showEndDate)LabelTextField(
              controller: document.endDateController,
              readOnly: true,
              label: "licenseExpiryDate",
              isDate: true,
            ),
        ],
      )
    ],
  );
}
