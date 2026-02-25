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
import 'package:zakat_fund/widgets/elevated_button.dart';
import 'package:zakat_fund/widgets/my_app_bar.dart';

class CartScreen extends GetView<CartViewModel> {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: myAppBar(title: "cart"),
      body: Obx(
        () => controller.cart.isEmpty
            ? Center(
                child: Text("cartIsEmpty".tr,
                    style: AppTextStyle.secondaryBlack14spTextStyle),
              )
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildStepIndicator(),
                    4.verticalSpace,
                    _buildStepTitle(),
                    controller.currentStep.value == 1
                        ? _buildCartList()
                        : const PaymentMethodWidget(),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildStepIndicator() {
    return Container(
      width: 50.w,
      height: 50.h,
      margin: EdgeInsets.only(top: 16.h),
      decoration: BoxDecoration(
        color: themeViewModel.color,
        shape: BoxShape.circle,
        border:
            Border.all(color: AppColors.lightBtnBackgroundColor, width: 6.w),
      ),
      alignment: Alignment.center,
      child: Text(
        "${controller.currentStep.value}",
        style: AppTextStyle.white16spTextStyle,
      ),
    );
  }

  Widget _buildStepTitle() {
    final title = controller.currentStep.value == 1
        ? "cartDetails".tr
        : "paymentDetails".tr;
    return Center(
      child: Text(title, style: AppTextStyle.primaryBlack14spTextStyle),
    );
  }

  Widget _buildCartList() {
    return Column(
      children: [
        _buildCartContainer(),
        _buildCartSummary(),
        120.verticalSpace,
      ],
    );
  }

  Widget _buildCartContainer() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 13.h),
      decoration: _containerDecoration(),
      child: Column(
        children: [
          _buildCartHeader(),
          10.verticalSpace,
          ...List.generate(
              controller.cart.length, (index) => _buildCartItem(index)),
          3.verticalSpace,
        ],
      ),
    );
  }

  Widget _buildCartHeader() {
    return Row(
      children: [
        Text("cart".tr, style: AppTextStyle.secondaryBlack18spTextStyle1),
        Text(" (${controller.cart.length})",
            style: AppTextStyle.primaryDarkGrey18spTextStyle),
        const Spacer(),
        TextButton(
          onPressed: controller.deleteAllCart,
          style: TextButton.styleFrom(
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              padding: EdgeInsets.zero),
          child: Text("deleteAll".tr, style: AppTextStyle.red14spTextStyle2),
        )
      ],
    );
  }

  Widget _buildCartItem(int index) {
    final cart = controller.cart[index];
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCartImage(cart),
            10.horizontalSpace,
            _buildCartDetails(cart, index),
          ],
        ),
        if (index != controller.cart.length - 1) ...[
          16.verticalSpace,
          Divider(color: AppColors.dividerColor, height: 1.h),
          16.verticalSpace,
        ],
      ],
    );
  }

  Widget _buildCartImage(Cart cart) {
    final placeholder = Image.asset(
      AppResources.placeholder,
      width: 140.w,
      height: 120.h,
      fit: BoxFit.cover,
    );

    if (cart.projectImage == null) {
      return ClipRRect(
          borderRadius: BorderRadius.circular(15.r), child: placeholder);
    }

    if (Utils.isVideo(cart.projectImage!)) {
      return FutureBuilder(
        future: Utils.urlThumbnail(cart.projectImage!),
        builder: (context, AsyncSnapshot snapshot) {
          final fileImage = snapshot.hasData
              ? Image.file(File(snapshot.data),
                  width: 140.w, height: 120.h, fit: BoxFit.cover)
              : placeholder;
          return ClipRRect(
              borderRadius: BorderRadius.circular(15.r), child: fileImage);
        },
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(15.r),
      child:
          CachedImage(image: cart.projectImage!, width: 140.w, height: 120.h),
    );
  }

  Widget _buildCartDetails(Cart cart, int index) {
    final isArabic = Utils.isArabic;
    return Expanded(
      child: ConstrainedBox(
        constraints: BoxConstraints(minWidth: Get.width, minHeight: 120.h),
        child: IntrinsicHeight(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("${cart.amount.round()} ${"currency".tr}",
                  style: AppTextStyle.darkBrown18spTextStyle1),
              const Spacer(),
              Text(
                isArabic ? cart.projectNameArabic : cart.projectName,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyle.secondaryBlack14spTextStyle3,
              ),
              Text(
                isArabic ? cart.associationNameArabic : cart.associationName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyle.primaryDarkGrey12spTextStyle,
              ),
              const Spacer(),
              Row(
                children: [
                  Flexible(
                      child: _actionButton("edit", AppResources.editIcon,
                          () => editPriceDialog(cart: cart, index: index))),
                  8.horizontalSpace,
                  Flexible(
                      child: _actionButton("delete", AppResources.deleteIcon,
                          () => controller.deleteProduct(cart),
                          isDelete: true)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _actionButton(String label, String iconPath, VoidCallback onPressed,
      {bool isDelete = false}) {
    return TextButton.icon(
      onPressed: onPressed,
      style: TextButton.styleFrom(
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          padding: EdgeInsets.zero),
      label: Text(label.tr,
          style: isDelete
              ? AppTextStyle.red14spTextStyle2
              : AppTextStyle.lightBrown14spTextStyle),
      icon: Image.asset(iconPath,
          width: 16.w,
          height: 16.h,
          color: isDelete ? null : AppColors.lightBrownColor),
    );
  }

  Widget _buildCartSummary() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 20.h),
      decoration: _containerDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("orderSummary".tr,
              style: AppTextStyle.secondaryPrimaryBlack24spTextStyle),
          16.verticalSpace,
          _summaryRow("totalDonations".tr, controller.totalAmount.value),
          16.verticalSpace,
          Divider(color: AppColors.dividerColor, height: 1.h),
          16.verticalSpace,
          _summaryRow("total".tr, controller.totalAmount.value),
          16.verticalSpace,
          elevatedButton(
            text: "completePayment",
            onPressed: () async {
              await Get.delete<PaymentMethodViewModel>();
              Get.put(PaymentMethodViewModel(true));
              return controller.completePayment();
            },
          ),
          16.verticalSpace,
          _securePaymentNote(),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, int amount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTextStyle.primaryDarkGrey16spTextStyle1),
        Text("$amount ${"currency".tr}"),
      ],
    );
  }

  Widget _securePaymentNote() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: AppColors.grayColor,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Icon(Icons.verified_user_rounded,
              color: AppColors.lightBrownColor),
          4.verticalSpace,
          Text(
            "paymentSecureMessage".tr,
            textAlign: TextAlign.center,
            style: AppTextStyle.primaryDarkBlack14spTextStyle,
          ),
        ],
      ),
    );
  }

  BoxDecoration _containerDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20.r),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          offset: const Offset(0, 4),
          blurRadius: 50.0,
        ),
      ],
    );
  }
}
