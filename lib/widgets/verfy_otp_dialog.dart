import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/widgets/elevated_button.dart';

verifyOtpDialog({required String userName,required Function(String) onVerify}) {
  final otpController = TextEditingController();
  Get.dialog(
      Dialog(
    insetPadding: EdgeInsets.symmetric(horizontal: 16.w,vertical: 16.h),
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(8)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            userName.contains("@")?"verifyYourEmail".tr:"verifyPhoneNumber".tr,
            style: AppTextStyle.secondaryPrimaryBlack16spTextStyle,
          ),
          10.verticalSpace,
          RichText(
            text: TextSpan(
                text: 'activationMessage'.tr,
                style: AppTextStyle.darkerGrey14spTextStyle1
                    .copyWith(fontFamily: 'Roboto'),
                children: <TextSpan>[
                  TextSpan(
                      text: userName.tr,
                      style: AppTextStyle.secondaryPrimaryBlack14spTextStyle2
                          .copyWith(fontFamily: 'Roboto'))
                ]),
          ),
          16.verticalSpace,
          Directionality(
            textDirection: TextDirection.ltr,
            child: PinCodeTextField(
              appContext: Get.context!,
              length: 5,
              // autoDisposeControllers:false,
              animationType: AnimationType.fade,
              pinTheme: PinTheme(
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(10.r),
                fieldHeight: 50,
                fieldWidth: 40,
                activeColor: AppColors.secondaryLightGreyColor,
                inactiveColor: AppColors.secondaryLightGreyColor,
                selectedColor: AppColors.primaryDarkBrownColor,
                activeFillColor: AppColors.lightGreyColor,
                selectedFillColor: AppColors.lightGreyColor,
                inactiveFillColor: AppColors.lightGreyColor,
              ),
              animationDuration: const Duration(milliseconds: 300),
              enableActiveFill: true,
              controller: otpController,
              keyboardType: TextInputType.number,
              onCompleted: (v) {

              },
              textStyle: AppTextStyle.secondaryBlack18spTextStyle,
              pastedTextStyle: AppTextStyle.secondaryBlack18spTextStyle,
              onChanged: (value) {
                debugPrint(value);
              },
              beforeTextPaste: (text) {
                return true;
              },
              dialogConfig: DialogConfig(
                  dialogContent: "Do you want to paste ",
                  dialogTitle: "Paste OTP"),
            ),
          ),
          16.verticalSpace,
          elevatedButton(text: "verify", onPressed: (){
            if(otpController.text.length<5){
              return;
            }
            onVerify(otpController.text);
          }),
          10.verticalSpace,
          elevatedButton(
              text: "cancel",
              onPressed: () => Get.back(),
              backgroundColor: AppColors.lightGreyColor),
        ],
      ),
    ),
  ));
}
