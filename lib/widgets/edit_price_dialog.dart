import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:zakat_fund/model/cart.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/view_model/cart_view_model.dart';
import 'package:zakat_fund/widgets/bottom_sheet_header.dart';
import 'package:zakat_fund/widgets/elevated_button.dart';
import 'package:zakat_fund/widgets/text_field_widget.dart';

void editPriceDialog({required Cart cart, required int index}) {
  final viewModel = Get.find<CartViewModel>();
  viewModel.amount.text = cart.amount.round().toString();
  Get.dialog(
    Dialog(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: KeyboardActions(
          config:
              Utils.buildConfig(Get.context!, viewModel.keyboardActionsItems),
          autoScroll: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              8.verticalSpace,
              buildBottomSheetHeader(text: "modifyTheAmount"),
              16.verticalSpace,
              TextFieldWidget(
                hint: "totalAmount".tr,
                controller: viewModel.amount,
                focusNode: viewModel.amountNode,
                amount: true,
              ),
              16.verticalSpace,
              _buildDialogActions(cart, viewModel),
              16.verticalSpace,
            ],
          ),
        ),
      ),
    ),
    barrierDismissible: false,
  );
}

Widget _buildDialogActions(Cart cart, CartViewModel viewModel) {
  return Row(
    children: [
      Expanded(
        child: elevatedButton(
          text: "update",
          onPressed: () {
            final rawAmount = viewModel.amount.text.trim();
            final cleaned = rawAmount.replaceAll(RegExp(r'[^0-9.]'), '');
            final parsedAmount = double.tryParse(cleaned);
            if (parsedAmount == null || parsedAmount <= 0) {
              Utils.showGlobalSnackBar(message: "enterAmount".tr);
              return;
            }
            if (parsedAmount < cart.minimumAmount) {
              Utils.showGlobalSnackBar(
                  message: "${"minDonationAmount".tr} ${cart.minimumAmount}");
              return;
            }
            Get.back();
            viewModel.updateCartItem(
                amount: cleaned, cartItem: cart, isUpdate: true);
          },
        ),
      ),
      16.horizontalSpace,
      Expanded(
        child: elevatedButton(
          text: "cancel",
          onPressed: () => Get.back(),
          backgroundColor: AppColors.lightGreyColor,
        ),
      ),
    ],
  );
}
