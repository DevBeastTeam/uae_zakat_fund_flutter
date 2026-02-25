import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/view_model/otp_verification_view_model.dart';
import 'package:zakat_fund/widgets/already_have_account.dart';
import 'package:zakat_fund/widgets/elevated_button.dart';
import 'package:zakat_fund/widgets/footer.dart';

class OtpVerificationScreen extends StatelessWidget {
  OtpVerificationScreen({super.key});

  final controller = Get.put(OtpVerificationViewModel());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _buildBody(context),
    );
  }

  Padding _buildBody(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeading(),
            4.verticalSpace,
            _buildSubHeading(),
            20.verticalSpace,
            _buildOTPInput(context),
            20.verticalSpace,
            elevatedButton(
              text: "activate",
              onPressed: () => controller.validateOtp(Get.arguments),
            ),
            16.verticalSpace,
            elevatedButton(
              text: "resend",
              backgroundColor: AppColors.lightGreyColor,
              onPressed: () =>
                  controller.resendOtp(Get.arguments, resend: true),
            ),
            const Spacer(),
            buildAlreadyHaveAccount(),
            20.verticalSpace,
            buildFooter(),
          ],
        ),
      ),
    );
  }

  Form _buildOTPInput(BuildContext context) {
    return Form(
      key: controller.formKey,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: PinCodeTextField(
          appContext: context,
          length: 5,
          cursorColor: AppColors.primaryDarkBrownColor,
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
          controller: controller.otpTextEditingController,
          keyboardType: TextInputType.number,
          onCompleted: (v) {
            debugPrint("Completed");
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
              dialogContent: "Do you want to paste ", dialogTitle: "Paste OTP"),
        ),
      ),
    );
  }

  RichText _buildSubHeading() {
    return RichText(
      text: TextSpan(
          text: 'activationMessage'.tr,
          style: AppTextStyle.darkerGrey14spTextStyle
              .copyWith(fontFamily: 'Alexandria'),
          children: <TextSpan>[
            TextSpan(
                text: Get.arguments["email"].toString().tr,
                style: AppTextStyle.primaryDarkBrown14spTextStyle1
                    .copyWith(fontFamily: 'Alexandria'))
          ]),
    );
  }

  Text _buildHeading() {
    return Text(
      "activationCode".tr,
      style: AppTextStyle.secondaryDarkBrown36spTextStyle.copyWith(height: 0),
    );
  }
}
