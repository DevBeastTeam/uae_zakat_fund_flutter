import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:zakat_fund/my_app/my_app.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_resources.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/view/bottom_bar/cart/payment/payment_method_widget.dart';
import 'package:zakat_fund/view_model/payment_method_view_model.dart';
import 'package:zakat_fund/widgets/elevated_button.dart';
import 'package:zakat_fund/widgets/label_text_field.dart';

class OnlinePaymentMethodWidget extends GetView<PaymentMethodViewModel> {
  const OnlinePaymentMethodWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.r),
      child: Form(
        key: controller.dpFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // SizedBox(
            //   height: 72.h,
            //   child: ListView(
            //     scrollDirection: Axis.horizontal,
            //     padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            //     children: [
            //       if (controller.showCreditCard) ...[
            //         _buildCreditCardOption(),
            //         16.horizontalSpace
            //       ],
            //       if (Platform.isAndroid && controller.showGooglePay)
            //         GooglePayButton(
            //           paymentItems: controller.paymentItems,
            //           type: GooglePayButtonType.donate,
            //           onPaymentResult: (paymentResult) {
            //             log("Payment Result: $paymentResult");
            //           },
            //           loadingIndicator: const Center(
            //             child: CircularProgressIndicator(),
            //           ),
            //           paymentConfiguration: defaultGooglePayConfig,
            //         ),
            //       if (Platform.isIOS && controller.showApplePay)
            //         ApplePayButton(
            //           paymentItems: controller.paymentItems,
            //           type: ApplePayButtonType.donate,
            //           onPaymentResult: (paymentResult) {
            //             print("Payment Result: $paymentResult");
            //           },
            //           loadingIndicator: const Center(
            //             child: CircularProgressIndicator(),
            //           ),
            //           paymentConfiguration: defaultApplePayConfig,
            //         ),
            //     ],
            //   ),
            // ),
            if (userBox.isEmpty) ...[
              16.verticalSpace,
              LabelTextField(
                controller: controller.dpfNameController,
                label: "fullName",
                isRequired: true,
                checkValidation: true,
                hint: "fullName",
              ),
              // 16.verticalSpace,
              // LabelTextField(
              //   controller: controller.dplNameController,
              //   label: "lastName",
              //   isRequired: true,
              //   checkValidation: true,
              //   hint: "lastName",
              // ),
              16.verticalSpace,
              LabelTextField(
                controller: controller.dpEmailController,
                label: "email",
                hint: "enterEmail",
                isRequired: true,
                checkValidation: true,
              ),
              16.verticalSpace,
              LabelTextField(
                controller: controller.dpPhoneController,
                label: "phoneNumber",
                hint: "+971xxxxxxxxx",
                isArabicDirection: true,
                inputFormatters: [
                  MaskTextInputFormatter(
                    mask: "+971#########",
                    initialText: "+971",
                    filter: {"#": RegExp(r'[0-9]')},
                  )
                ],
                checkValidation: true,
                isRequired: true,
              ),
              16.verticalSpace,
            ],
            elevatedButton(
                text: "payNow",
                onPressed: () {
                  if (!controller.dpFormKey.currentState!.validate()) {
                    return;
                  }
                  controller.addGuestUser();
                }),
            if (controller.isCart) 16.verticalSpace,
            if (controller.isCart)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: backButton(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCreditCardOption() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: AppColors.lightGreyColor,
        borderRadius: BorderRadius.circular(50.r),
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            AppResources.creditDebitCardIcon,
            color: AppColors.newGreyColor,
            width: 16.w,
            height: 16.h,
          ),
          8.horizontalSpace,
          Text(
            "creditDebitCard".tr,
            style: AppTextStyle.newGreyColor12spTextStyle1,
          ),
        ],
      ),
    );
  }
}
