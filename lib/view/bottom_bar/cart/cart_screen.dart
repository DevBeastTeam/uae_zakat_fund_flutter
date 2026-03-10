import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/model/cart.dart';
import 'package:zakat_fund/my_app/my_app.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_resources.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/view/bottom_bar/cart/payment/payment_method_widget.dart';
import 'package:zakat_fund/view_model/cart_view_model.dart';
import 'package:zakat_fund/view_model/payment_method_view_model.dart';
import 'package:zakat_fund/widgets/cache_image.dart';
import 'package:zakat_fund/widgets/edit_price_dialog.dart';
import 'package:zakat_fund/widgets/my_app_bar.dart';
import 'package:zakat_fund/widgets/secure_paymen_ttitle_widget.dart';

class CartScreen extends GetView<CartViewModel> {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),
      appBar: myAppBar(title: "cart"),
      body: Obx(
        () => controller.cart.isEmpty
            ? Center(
                child: Text("cartIsEmpty".tr,
                    style: AppTextStyle.secondaryBlack14spTextStyle),
              )
            : SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Show steps only for guest/unregistered users
                    if (userBox.isEmpty) ...[
                      _buildStepIndicatorRow(context),
                      20.verticalSpace
                    ],
                    controller.currentStep.value == 1
                        ? _buildCartList()
                        : const PaymentMethodWidget(),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildStepIndicatorRow(context) {
    final step = controller.currentStep.value;
    final steps = ['cartDetails'.tr, 'paymentDetails'.tr, 'confirmation'.tr];

    Widget buildCircle(int index) {
      final isActive = step >= index;
      if (isActive) {
        return Container(
          width: 40.r,
          height: 40.r,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: themeViewModel.color.withValues(alpha: 0.2),
          ),
          alignment: Alignment.center,
          child: Container(
            width: 28.r,
            height: 28.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: themeViewModel.color,
            ),
            alignment: Alignment.center,
            child: Text('$index',
                style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white)),
          ),
        );
      }
      return Container(
        width: 28.r,
        height: 28.r,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.transparent,
          border: Border.all(color: const Color(0xffD1D1D1), width: 1.5),
        ),
        alignment: Alignment.center,
        child: Text('$index',
            style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.primaryDarkGreyColor)),
      );
    }

    Widget buildLine(int afterIndex) => Container(
          height: 1.5,
          color: step > afterIndex
              ? themeViewModel.color
              : const Color(0xffD1D1D1),
        );

    TextStyle labelStyle(int index) => TextStyle(
          fontSize: 11.sp,
          fontWeight: step >= index ? FontWeight.w600 : FontWeight.w400,
          color: step >= index
              ? AppColors.primaryBlackColor
              : AppColors.primaryDarkGreyColor,
        );

    return Column(
      children: [
        // circles interleaved with connector lines in one flat Row
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(child: Center(child: buildCircle(1))),
            Expanded(flex: 2, child: buildLine(1)),
            Expanded(child: Center(child: buildCircle(2))),
            Expanded(flex: 2, child: buildLine(2)),
            Expanded(child: Center(child: buildCircle(3))),
          ],
        ),
        8.verticalSpace,
        // labels mirror the same flex pattern
        Row(
          children: [
            Expanded(
                child: Text(steps[0],
                    textAlign: TextAlign.center, style: labelStyle(1))),
            const Spacer(flex: 2),
            Expanded(
                child: Text(steps[1],
                    textAlign: TextAlign.center, style: labelStyle(2))),
            const Spacer(flex: 2),
            Expanded(
                child: Text(steps[2],
                    textAlign: TextAlign.center, style: labelStyle(3))),
          ],
        ),
      ],
    );
  }

  Widget _buildCartList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildCartContainer(),
        16.verticalSpace,
        _buildCartSummary(),
        24.verticalSpace,
      ],
    );
  }

  /// ── Cart items card ──────────────────────────────────────────────────────
  Widget _buildCartContainer() {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCartHeader(),
          12.verticalSpace,
          ...List.generate(controller.cart.length, (index) {
            return Column(
              children: [
                _buildCartItem(index),
                if (index != controller.cart.length - 1) ...[
                  14.verticalSpace,
                  Divider(color: AppColors.dividerDarkColor, height: 1.h),
                  14.verticalSpace,
                ],
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildCartHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "${"cart".tr} (${controller.cart.length})",
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.primaryBlackColor,
          ),
        ),
        GestureDetector(
          onTap: controller.deleteAllCart,
          child: Text(
            "deleteAll".tr,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.redColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCartItem(int index) {
    final cart = controller.cart[index];
    final isArabic = Utils.isArabic;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildCartImage(cart),
        12.horizontalSpace,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${cart.amount.round()} ${" currency".tr}",
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.darkBrownColor,
                ),
              ),
              6.verticalSpace,
              Text(
                isArabic ? cart.projectNameArabic : cart.projectName,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryBlackColor,
                ),
              ),
              4.verticalSpace,
              if ((isArabic
                      ? cart.associationNameArabic
                      : cart.associationName) !=
                  null)
                Text(
                  isArabic
                      ? (cart.associationNameArabic ?? "")
                      : (cart.associationName ?? ""),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.primaryDarkGreyColor,
                  ),
                ),
              10.verticalSpace,
              Row(
                children: [
                  _actionButton(
                    label: "edit".tr,
                    iconPath: AppResources.editIcon,
                    onPressed: () => editPriceDialog(cart: cart, index: index),
                    isDelete: false,
                  ),
                  20.horizontalSpace,
                  _actionButton(
                    label: "delete".tr,
                    iconPath: AppResources.deleteIcon,
                    onPressed: () => controller.deleteProduct(cart),
                    isDelete: true,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCartImage(Cart cart) {
    const double size = 90;
    final placeholder = Image.asset(
      AppResources.placeholder,
      width: size.w,
      height: size.h,
      fit: BoxFit.cover,
    );

    Widget imageWidget;
    if (cart.projectImage == null) {
      imageWidget = placeholder;
    } else if (Utils.isVideo(cart.projectImage!)) {
      imageWidget = FutureBuilder(
        future: Utils.urlThumbnail(cart.projectImage!),
        builder: (context, AsyncSnapshot snapshot) {
          final fileImage = snapshot.hasData
              ? Image.file(File(snapshot.data),
                  width: size.w, height: size.h, fit: BoxFit.cover)
              : placeholder;
          return fileImage;
        },
      );
    } else {
      imageWidget =
          CachedImage(image: cart.projectImage!, width: size.w, height: size.h);
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(12.r),
      child: SizedBox(width: size.w, height: size.h, child: imageWidget),
    );
  }

  Widget _actionButton({
    required String label,
    required String iconPath,
    required VoidCallback onPressed,
    required bool isDelete,
  }) {
    final color = isDelete ? AppColors.redColor : AppColors.lightBrownColor;
    return GestureDetector(
      onTap: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            iconPath,
            width: 16.w,
            height: 16.h,
            color: color,
          ),
          4.horizontalSpace,
          Text(
            label,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  /// ── Order Summary card ───────────────────────────────────────────────────
  Widget _buildCartSummary() {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "orderSummary".tr,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryBlackColor,
            ),
          ),
          20.verticalSpace,
          _summaryRow(
            label: "totalDonations".tr,
            amount: controller.totalAmount.value,
            bold: false,
          ),
          16.verticalSpace,
          Divider(color: AppColors.dividerDarkColor, height: 1.h),
          16.verticalSpace,
          _summaryRow(
            label: "total".tr,
            amount: controller.totalAmount.value,
            bold: true,
          ),
          20.verticalSpace,
          _payNowButton(),
          16.verticalSpace,
          // _securePaymentNote(),
          SecurePaymentTitleWidget(bgColor: AppColors.dividerColor),
        ],
      ),
    );
  }

  Widget _summaryRow(
      {required String label, required int amount, required bool bold}) {
    final labelStyle = bold
        ? TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.primaryBlackColor,
          )
        : TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.w400,
            color: AppColors.primaryDarkGreyColor,
          );

    final valueStyle = TextStyle(
      fontSize: 16.sp,
      fontWeight: FontWeight.w700,
      color: AppColors.primaryBlackColor,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: labelStyle),
        Text("$amount ${"currency".tr}", style: valueStyle),
      ],
    );
  }

  Widget _payNowButton() {
    return SizedBox(
      width: double.infinity,
      height: 50.h,
      child: ElevatedButton(
        onPressed: () async {
          await Get.delete<PaymentMethodViewModel>();
          Get.put(PaymentMethodViewModel(true));
          controller.completePayment();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xff5D3B26),
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.r),
          ),
        ),
        child: Text(
          "completePayment".tr,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _securePaymentNote() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: const Color(0xffF6F6F6),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.verified_user_rounded,
            color: themeViewModel.color,
            size: 20.r,
          ),
          10.horizontalSpace,
          Expanded(
            child: Text(
              "paymentSecureMessage".tr,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.primaryBlackColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      // color: Colors.white,
      borderRadius: BorderRadius.circular(16.r),
      border: Border.all(color: AppColors.dividerDarkColor),
      // boxShadow: [
      //   BoxShadow(
      //     color: Colors.black.withOpacity(0.06),
      //     offset: const Offset(0, 2),
      //     blurRadius: 12,
      //   ),
      // ],
    );
  }
}
