import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_resources.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/view/bottom_bar/cart/payment/offline_payment_method.dart';
import 'package:zakat_fund/view/bottom_bar/cart/payment/online_payment_method.dart';
import 'package:zakat_fund/view/bottom_bar/cart/payment/wallet_payment_method.dart';
import 'package:zakat_fund/view_model/cart_view_model.dart';
import 'package:zakat_fund/view_model/payment_method_view_model.dart';
import 'package:zakat_fund/widgets/tab_bar_widget.dart';

class PaymentMethodWidget extends GetView<PaymentMethodViewModel> {
  const PaymentMethodWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final selectedTab = controller.currentTabIndex.value;
      return controller.isLoading.value
          ? SizedBox.shrink()
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                16.verticalSpace,
                // _buildTabs(),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Row(
                    children: [
                      Expanded(
                        child: Opacity(
                          opacity: 1,
                          child: Container(
                            height: 65.h,
                            padding: EdgeInsets.symmetric(horizontal: 8.w),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.r),
                                border: Border.all(color: AppColors.greyColor)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  AppResources.cardPayIcon,
                                  width: 20.w,
                                  height: 20.h,
                                  color: AppColors.darkGreyColor1,
                                ),
                                4.verticalSpace,
                                FittedBox(
                                  child: Text(
                                    "credit/DebitCard".tr,
                                    textAlign: TextAlign.center,
                                    style:
                                        AppTextStyle.darkGreyOne12spTextStyle3,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      8.horizontalSpace,
                      Expanded(
                        child: Opacity(
                          opacity: 1,
                          child: Container(
                            height: 65.h,
                            padding: EdgeInsets.symmetric(horizontal: 10.w),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.r),
                                border: Border.all(color: AppColors.greyColor)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  AppResources.bankTransferIcon,
                                  width: 20.w,
                                  height: 20.h,
                                  color: AppColors.darkGreyColor1,
                                ),
                                4.verticalSpace,
                                FittedBox(
                                  child: Text(
                                    "bankTransfer".tr,
                                    textAlign: TextAlign.center,
                                    style:
                                        AppTextStyle.darkGreyOne12spTextStyle3,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      8.horizontalSpace,
                      Expanded(
                        child: Opacity(
                          opacity: 0.4,
                          child: Container(
                            height: 65.h,
                            padding: EdgeInsets.symmetric(horizontal: 10.w),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.r),
                                border: Border.all(color: AppColors.greyColor)),
                            child: Image.asset(
                              AppResources.applePayIcon,
                              width: 58.w,
                              height: 24.h,
                            ),
                          ),
                        ),
                      ),
                      8.horizontalSpace,
                      Expanded(
                        child: Opacity(
                          opacity: 0.4,
                          child: Container(
                            height: 65.h,
                            padding: EdgeInsets.symmetric(horizontal: 10.w),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.r),
                                border: Border.all(color: AppColors.greyColor)),
                            child: SvgPicture.asset(
                              AppResources.googlePay,
                              width: 48.w,
                              height: 24.h,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (controller.showWallet &&
                    controller.tabs[selectedTab].name == "myWallet")
                  WalletPaymentMethodWidget(),
                if (controller.showOnlinePayment &&
                    controller.tabs[selectedTab].name == "onlinePayment")
                  OnlinePaymentMethodWidget(),
                if (controller.showOfflinePayment &&
                    controller.tabs[selectedTab].name == "offlinePayment")
                  OfflinePaymentMethod(),
              ],
            );
    });
  }

  Widget _buildTabs() {
    return tabBarWidget(
      controller.tabController,
      [],
      controller.currentTabIndex.value,
      newTab: true,
      icon: true,
      cats: controller.tabs,
    );
  }
}

Widget backButton() {
  return OutlinedButton(
    style: OutlinedButton.styleFrom(
      side: BorderSide(width: 2.w, color: AppColors.darkBrownColor),
      minimumSize: Size(Get.width, 45.h),
    ),
    onPressed: () {
      final controller = Get.find<PaymentMethodViewModel>();
      if (controller.isCart) {
        Get.find<CartViewModel>().currentStep.value = 1;
      }
      controller.currentTabIndex.value = 0;
      controller.offlinePayTabIndex.value = 0;
    },
    child: Text(
      "back".tr,
      maxLines: 1,
      style: AppTextStyle.primaryDarkBrown16spTextStyle1,
    ),
  );
}
