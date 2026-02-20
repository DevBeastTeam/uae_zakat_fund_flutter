import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_resources.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/view/bottom_bar/cart/payment/payment_method_widget.dart';
import 'package:zakat_fund/view_model/payment_method_view_model.dart';
import 'package:zakat_fund/widgets/elevated_button.dart';

class WalletPaymentMethodWidget extends GetView<PaymentMethodViewModel> {
  const WalletPaymentMethodWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return controller.showWalletDashboard.value
          ? _buildWalletDashboard()
          : _buildEmptyWallet();
    });
  }

  Widget _buildWalletDashboard() {
    const horizontalPadding = EdgeInsets.symmetric(horizontal: 16);
    return Column(
      children: [
        Container(
          margin: horizontalPadding.copyWith(top: 16.h,bottom: 16.h),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 22.h),
          decoration: const BoxDecoration(
            color: AppColors.chipBackgroundColor,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHeader(),
              16.verticalSpace,
              _buildBalanceText(),
              8.verticalSpace,
              _buildTotalBalanceText(),
            ],
          ),
        ),
        25.verticalSpace,
        Padding(
          padding: horizontalPadding,
          child: elevatedButton(
            text: "payNow".tr,
            onPressed: controller.payViaWallet,
          ),
        ),
        16.verticalSpace,
        if (controller.isCart)
          Padding(
            padding: horizontalPadding,
            child: backButton(),
          ),
      ],
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          AppResources.myWalletIcon,
          width: 24.w,
          height: 24.h,
        ),
        8.horizontalSpace,
        Text(
          "myWallet".tr,
          style: AppTextStyle.btnText24spTextStyle1,
        ),
      ],
    );
  }

  Widget _buildBalanceText() {
    return Text(
      "${"currency".tr} ${controller.walletBalance.value}",
      style: AppTextStyle.btnText24spTextStyle2,
    );
  }

  Widget _buildTotalBalanceText() {
    return RichText(
      text: TextSpan(
        text: 'totalBalance'.tr,
        style: AppTextStyle.secondaryPrimaryBlack20spTextStyle2,
        children: [
          TextSpan(
            text: ' ${controller.walletBalance.value}',
            style: AppTextStyle.lightBrown20spTextStyle,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyWallet() {
    const horizontalPadding = EdgeInsets.symmetric(horizontal: 16);
    return Center(
      child: Padding(
        padding: horizontalPadding,
        child: Column(
          children: [
            20.verticalSpace,
            SvgPicture.asset(AppResources.emptyWalletIcon),
            16.verticalSpace,
            Text(
              "emptyWalletMessage".tr,
              textAlign: TextAlign.center,
            ),
            16.verticalSpace,
            elevatedButton(
              text: "topUpYourWallet",
              onPressed: controller.topUpWallet,
            ),
            16.verticalSpace,
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: BorderSide(width: 2.w, color: AppColors.darkBrownColor),
                minimumSize: Size(Get.width, 45.h),
              ),
              onPressed: () {
                controller.showWalletDashboard.value = true;
              },
              child: Text(
                "back".tr,
                maxLines: 1,
                style: AppTextStyle.primaryDarkBrown16spTextStyle1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

