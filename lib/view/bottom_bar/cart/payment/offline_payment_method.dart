import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:zakat_fund/model/categories.dart';
import 'package:zakat_fund/my_app/my_app.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_constant.dart';
import 'package:zakat_fund/utils/constants/app_resources.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/view/bottom_bar/cart/payment/payment_method_widget.dart';
import 'package:zakat_fund/view_model/payment_method_view_model.dart';
import 'package:zakat_fund/widgets/elevated_button.dart';
import 'package:zakat_fund/widgets/label_drop_down.dart';
import 'package:zakat_fund/widgets/label_drop_down2.dart';
import 'package:zakat_fund/widgets/label_text_field.dart';

class OfflinePaymentMethod extends GetView<PaymentMethodViewModel> {
  const OfflinePaymentMethod({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() =>
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            16.verticalSpace,
            _buildOfflinePaymentTabs(),
            _buildOfflinePaymentForm(),
            if (controller.isCart)...[16.verticalSpace, Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: backButton(),
            )
            ],
            130.verticalSpace,
          ],
        ));
  }

  Widget _buildOfflinePaymentTabs() {
    return SizedBox(
      height: 40.h,
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: controller.offlinePayTabs.length,
        separatorBuilder: (_, __) => 13.horizontalSpace,
        itemBuilder: (context, index) {
          final tab = controller.offlinePayTabs[index];
          return _buildTabItem(tab, index);
        },
      ),
    );
  }

  Widget _buildTabItem(Categories tab, int index) {
    final isSelected = controller.offlinePayTabIndex.value == index;
    return GestureDetector(
      onTap: () => controller.updateOfflinePaymentTabs(index),
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? themeViewModel.color : AppColors.lightGreyColor,
          borderRadius: BorderRadius.circular(50.r),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: index == 0 ? 16.w : 30.w,
          vertical: 10.h,
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              tab.icon ?? '',
              color: isSelected
                  ? AppColors.btnTextColor
                  : AppColors.newGreyColor,
              width: 16.w,
              height: 16.h,
            ),
            8.horizontalSpace,
            Text(
              tab.name.tr,
              style: isSelected
                  ? AppTextStyle.btnText12spTextStyle1
                  : AppTextStyle.newGreyColor12spTextStyle1,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOfflinePaymentForm() {
    switch (controller.offlinePayTabs[controller.offlinePayTabIndex.value]
        .name) {
      case "cash":
        return _buildCashTransfer();
      case "bankCheque":
        return _buildBankCheque();
      case "deposit":
      default:
        return _buildBankTransfer();
    }
  }

  Widget _buildBankCheque() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Form(
        key: controller.bankFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            16.verticalSpace,
            Obx(() =>
                LabelDropDown2(
                  items: controller.banksList,
                  selectedValue: controller.selectedBankCheck.value,
                  hint: "chooseAnOption",
                  isRequired: true,
                  onChanged: (value) => controller.onChangeDepositBank(value),
                  label: 'bankName',
                )),
            16.verticalSpace,
            LabelTextField(
              controller: controller.chequeNumberController,
              label: "chequeNumber",
              hint: "enterChequeNumber",
              checkValidation: true,
              isRequired: true,
            ),
            16.verticalSpace,
            LabelTextField(
              controller: controller.amountController,
              label: "amount",
              hint: "enterTopUpAmount",
              readOnly: true,
            ),
            16.verticalSpace,
            LabelTextField(
              controller: controller.chequeDateController,
              label: "chequeDate",
              checkValidation: true,
              isRequired: true,
              isDate: true,
              readOnly: true,
              onTap: () => controller.datePickerDialog(chequeDate: true),
            ),
            16.verticalSpace,
            LabelTextField(
              controller: controller.chequeCollectionDateController,
              label: "chequeCollectionDate",
              isRequired: true,
              checkValidation: true,
              isDate: true,
              readOnly: true,
              onTap: () => controller.datePickerDialog(collection: true),
            ),
            16.verticalSpace,
            Obx(() =>
                LabelDropDown(
                  items: AppConstant.collectionTimings,
                  selectedValue: controller.selectedChequeCollectionTiming.value,
                  hint: "chooseAnOption",
                  isArabicDirection: true,
                  isRequired: true,
                  onChanged: controller.onChangeChequeCollectionTiming,
                  label: 'chequeCollectionTiming',
                )),
            16.verticalSpace,
            LabelTextField(
              label: 'chequePhoto',
              checkValidation: true,
              readOnly: true,
              isRequired: true,
              onAddFile: () => controller.addFile(),
              controller: controller.chequePhotoController,
            ),
            16.verticalSpace,
            Obx(() =>
            controller.chequeFile.value != null
                ? ClipRRect(
              borderRadius: BorderRadius.circular(10.r),
              child: Image.file(
                controller.chequeFile.value!,
                width: 275.w,
                height: 158.h,
              ),
            )
                : const SizedBox.shrink()),
            16.verticalSpace,
            Obx(() =>
                Column(
                    children: List.generate(controller.addresses.value.length,
                            (index) => _buildAddressItem(index)))),
            Obx(() =>
            controller.addresses.length < 2
                ? _buildAddNewAddress()
                : const SizedBox.shrink()),
            16.verticalSpace,
            elevatedButton(
                text: "payNow".tr,
                onPressed: () => controller.openReceiptScreen()),

          ],
        ),
      ),
    );
  }

  Widget _buildBankTransfer() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Form(
        key: controller.depositFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            16.verticalSpace,
            Obx(() =>
                Column(
                  children: [
                    LabelDropDown(
                      items: controller.sahemBanks,
                      selectedValue: controller.selectedBankTransfer.value,
                      hint: "chooseAnOption",
                      isRequired: true,
                      onChanged: (value) => controller.onChangeChequeBank(value),
                      label: 'bankName',
                    ),
                    if(controller.selectedBankTransfer.value!=null)...[16.verticalSpace,
                      LabelTextField(
                        controller: controller.accountHolderController,
                        label: "accountHolderName",
                        readOnly: true,
                      ),
                      16.verticalSpace,
                      LabelTextField(
                        controller: controller.ibanNumberController,
                        label: "ibanNumber",
                        readOnly: true,
                      ),
                    ],
                  ],
                )),

            16.verticalSpace,
            LabelTextField(
              controller: controller.chequeNumberController,
              label: "receiptNumber",
              hint: "enterReceiptNumber",
              checkValidation: true,
              isRequired: true,
            ),
            16.verticalSpace,
            LabelTextField(
              controller: controller.transferAmountController,
              label: "paymentAmount",
              hint: "enterTopUpAmount",
              readOnly: true,
            ),
            16.verticalSpace,
            LabelTextField(
              controller: controller.transferDateController,
              label: "paymentDate",
              checkValidation: true,
              isRequired: true,
              isDate: true,
              readOnly: true,
              onTap: () => controller.dobPickerDialog(),
            ),
            16.verticalSpace,
            LabelTextField(
              controller: controller.transferEmailController,
              label: "email",
              hint: "enterEmail",
              isRequired: true,
              readOnly:
              controller.transferEmailController.text
                  .trim()
                  .isNotEmpty,
              checkValidation: true,
            ),
            16.verticalSpace,
            LabelTextField(
              controller: controller.transferPhoneController,
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
              readOnly:
              controller.transferPhoneController.text
                  .trim()
                  .isNotEmpty,
            ),
            16.verticalSpace,
            LabelTextField(
              controller: controller.transferPayerNameController,
              label: "payersName",
              isRequired: true,
              checkValidation: true,
              hint: "enterName",
              readOnly:
              controller.transferPayerNameController.text
                  .trim()
                  .isNotEmpty,
            ),
            16.verticalSpace,
            LabelTextField(
              label: 'uploadDepositReceipt',
              checkValidation: true,
              isRequired: true,
              readOnly: true,
              onAddFile: () => controller.addFile(bankReceipt: true),
              controller: controller.bankReceiptController,
            ),
            16.verticalSpace,
            Obx(() =>
            controller.depositFile.value != null
                ? ClipRRect(
              borderRadius: BorderRadius.circular(10.r),
              child: Image.file(
                controller.depositFile.value!,
                width: 275.w,
                height: 158.h,
              ),
            )
                : const SizedBox.shrink()),
            16.verticalSpace,
            elevatedButton(
                text: "payNow".tr,
                onPressed: () => controller.openReceiptScreen()),
          ],
        ),
      ),
    );
  }

  Widget _buildCashTransfer() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Form(
        key: controller.cashFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            16.verticalSpace,
            LabelTextField(
              controller: controller.cashAmountController,
              label: "paymentAmount",
              hint: "enterTopUpAmount",
              readOnly: true,
            ),
            16.verticalSpace,
            LabelTextField(
              controller: controller.cashCollectionDateController,
              label: "collectionDate",
              isDate: true,
              isRequired: true,
              readOnly: true,
              checkValidation: true,
              onTap: () => controller.datePickerDialog(cash: true),
            ),
            16.verticalSpace,
            Obx(() =>
                LabelDropDown(
                  items: AppConstant.collectionTimings,
                  selectedValue: controller.selectedCashCollectionTiming.value,
                  hint: "chooseAnOption",
                  isRequired: true,
                  isArabicDirection: true,
                  onChanged: controller.onChangeCashCollectionTiming,
                  label: 'collectionTiming',
                )),
            16.verticalSpace,
            Text(
              "collectionPoint".tr,
              style: AppTextStyle.secondaryPrimaryBlack20spTextStyle,
            ),
            16.verticalSpace,
            Obx(() =>
                Column(
                    children: List.generate(controller.addresses.value.length,
                            (index) => _buildAddressItem(index)))),
            Obx(() =>
            controller.addresses.length < 2
                ? _buildAddNewAddress()
                : const SizedBox.shrink()),
            16.verticalSpace,
            elevatedButton(
                text: "payNow".tr,
                onPressed: () => controller.openReceiptScreen()),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressItem(int index) {
    final address = controller.addresses[index];
    return GestureDetector(
      onTap: () => controller.onAddressSelection(index),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
        margin: EdgeInsets.only(bottom: 16.h),
        decoration: BoxDecoration(
          color: Colors.white,
          border: controller.selectedAddress.value == index ? Border.all(
              color: themeViewModel.color, width: 2.w) : null,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              offset: const Offset(0.0, 4.0),
              blurRadius: 50.0,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "${index == 0 ? "address1".tr : "address2".tr} ${address.isDefault
                  ? "primary".tr
                  : ""}",
              style: AppTextStyle.secondaryPrimaryBlack16spTextStyle,
            ),
            10.verticalSpace,
            ...[
              address.street,
              address.building,
              address.landmark,
            ].map(
                  (line) =>
                  Text(
                    line,
                    maxLines: 1,
                    style: AppTextStyle.secondaryPrimaryBlack14spTextStyle,
                  ),
            ),
            10.verticalSpace,
            Row(
              children: [
                _buildEditAddressButton(index, address),
                8.horizontalSpace,
                _buildRemoveAddressButton(index),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditAddressButton(int index, dynamic address) {
    return Expanded(
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(backgroundColor: themeViewModel.color,
          elevation: 0,),
        onPressed: () => controller.editAddress(index, address),
        label: Text("edit".tr, style: AppTextStyle.btnText14spTextStyle1),
        icon: Image.asset(AppResources.editIcon, width: 16.w, height: 16.h),
      ),
    );
  }

  Widget _buildRemoveAddressButton(int index) {
    return Expanded(
      child: ElevatedButton.icon(
        style: const ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(AppColors.lightRedColor),
          elevation: WidgetStatePropertyAll(0),
        ),
        onPressed: () => controller.removeAddress(index),
        label: Text("remove".tr, style: AppTextStyle.red14spTextStyle1),
        icon: Image.asset(AppResources.deleteIcon, width: 16.w, height: 16.h),
      ),
    );
  }


  Widget _buildAddNewAddress() {
    return Container(
      height: 270.h,
      width: Get.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.lightGrey),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () => controller.addNewAddress(),
            child: Image.asset(
              AppResources.addCircleIcon,
              width: 32.w,
              height: 32.h,
            ),
          ),
          16.verticalSpace,
          Text("addNewAddress".tr,
              style: AppTextStyle.primaryDarkGrey16spTextStyle),
        ],
      ),
    );
  }

}