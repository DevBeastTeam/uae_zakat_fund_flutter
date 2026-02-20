import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:zakat_fund/my_app/my_app.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_resources.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/utils/validator.dart';
import 'package:zakat_fund/view_model/individual_view_model.dart';
import 'package:zakat_fund/widgets/elevated_button.dart';
import 'package:zakat_fund/widgets/label_drop_down2.dart';
import 'package:zakat_fund/widgets/label_text_field.dart';
import 'package:zakat_fund/widgets/text_field_label.dart';

class ContactInfoScreen extends GetView<IndividualViewModel> {
  const ContactInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: const Offset(0.0, 2.0),
            blurRadius: 100.0,
          ),
        ],
      ),
      child: Form(
        key: controller.contactFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Obx(() => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LabelTextField(
                        isRequired: true,
                        focusNode: controller.primaryPhoneNode,
                        checkValidation: true,
                        hint: "+971xxxxxxxxx",
                        validator: (val) => Validator.validateMobile(val!),
                        keyboardType: TextInputType.number,
                        isArabicDirection: true,
                        showVerify: !controller.isPhoneVerified.value,
                        onVerify: () => controller.sendOTP(controller.primaryMobileController.text),
                        inputFormatters: [
                          MaskTextInputFormatter(
                            mask: "+971#########",
                            initialText: "+971",
                            filter: {"#": RegExp(r'[0-9]')},
                          )
                        ],
                        readOnly: controller.isPhoneVerified.value ||
                            controller.user.uuid != null,
                        controller: controller.primaryMobileController,
                        label: 'mobileNumberPrimary'),
                    if (controller.isPhoneVerified.value) ...[
                      4.verticalSpace,
                      Row(
                        children: [
                          const Icon(
                            CupertinoIcons.check_mark_circled_solid,
                            color: AppColors.greenColor,
                          ),
                          8.horizontalSpace,
                          Text(
                            "mobileVerified".tr,
                            style: AppTextStyle.green14spTextStyle,
                          ),
                        ],
                      )
                    ],
                  ],
                )),
            // buildRadioButton(context, 1),
            16.verticalSpace,
            LabelTextField(
                hint: "+971xxxxxxxxx",
                keyboardType: TextInputType.number,
                isArabicDirection: true,
                focusNode: controller.secondaryPhoneNode,
                inputFormatters: [
                  MaskTextInputFormatter(
                    mask: "+971#########",
                    initialText: "+971",
                    filter: {"#": RegExp(r'[0-9]')},
                  )
                ],
                controller: controller.secondaryMobileController,
                label: 'mobileNumberSecondary'),
            // buildRadioButton(context, 2),
            16.verticalSpace,
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(() => Expanded(
                      child: LabelDropDown2(
                          focusNode: controller.countryNode,
                          showSearch: true,
                          items: controller.countriesList.value,
                          selectedValue: controller.selectedCountry.value,
                          onChanged: (value) =>
                              controller.onChangeCountry(value),
                          hint: "chooseAnOption",
                          label: 'country'),
                    )),
                16.horizontalSpace,
                Obx(() => controller.selectedCountry.value != null &&
                        controller.isUAE.value
                    ? Expanded(
                        child: LabelDropDown2(
                            focusNode: controller.emirateNode,
                            isRequired: true,
                            showSearch: true,
                            items: controller.emiratesList.value,
                            selectedValue: controller.selectedEmirate.value,
                            onChanged: (value) =>
                                controller.onChangeEmirate(value!),
                            hint: "chooseAnOption",
                            label: 'emirate'),
                      )
                    : const SizedBox.shrink()),
              ],
            ),
            16.verticalSpace,
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Obx(() => controller.selectedCountry.value != null &&
                          !controller.isUAE.value ||
                      controller.selectedCountry.value != null &&
                          controller.selectedEmirate.value != null &&
                          controller.isUAE.value
                  ? Expanded(
                      child: LabelDropDown2(
                          showSearch: true,
                          focusNode: controller.cityNode,
                          items: controller.citiesList.value,
                          selectedValue: controller.selectedCity.value,
                          onChanged: (value) =>
                              controller.selectedCity.value = value,
                          hint: "chooseAnOption",
                          label: 'city'),
                    )
                  : const SizedBox.shrink()),
              16.horizontalSpace,
              Expanded(
                child: LabelTextField(
                  controller: controller.poBoxController,
                  label: 'poBox',
                  isArabicDirection: true,
                ),
              ),
            ]),
            16.verticalSpace,
            textFieldLabel(label: "address".tr),
            16.verticalSpace,
            _buildAddressListView(),
            _buildAddNewAddress(),
            25.verticalSpace,
            elevatedButton(
              text: "save",
              onPressed: () => controller.saveContactInfo(),
            ),
          ],
        ),
      ),
    );
  }

  Obx _buildAddressListView() {
    return Obx(() => Column(
        children: List.generate(
            controller.addresses.value.length,
            (index) => Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
                  margin: EdgeInsets.only(bottom: 16.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(20.r)),
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
                        "${index == 0 ? "address1".tr : "address2".tr} ${controller.addresses[index].isDefault ? "primary".tr : ""}",
                        style: AppTextStyle.secondaryPrimaryBlack16spTextStyle,
                      ),
                      16.verticalSpace,
                      Text(controller.addresses[index].street,
                          maxLines: 1,
                          style:
                              AppTextStyle.secondaryPrimaryBlack14spTextStyle),
                      Text(controller.addresses[index].building,
                          maxLines: 1,
                          style:
                              AppTextStyle.secondaryPrimaryBlack14spTextStyle),
                      Text(controller.addresses[index].landmark,
                          maxLines: 1,
                          style:
                              AppTextStyle.secondaryPrimaryBlack14spTextStyle),
                      16.verticalSpace,
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: themeViewModel.color),
                        onPressed: () => controller.editAddress(index),
                        label: Text(
                          "edit".tr,
                          style: AppTextStyle.btnText14spTextStyle1,
                        ),
                        icon: Image.asset(
                          AppResources.editIcon,
                          width: 16.w,
                          height: 16.h,
                        ),
                      ),
                      if (!controller.addresses[index].isDefault) ...[
                        8.verticalSpace,
                        OutlinedButton.icon(
                          onPressed: () => controller.setAsDefaultAddress(index),
                          style: ElevatedButton.styleFrom(
                              side: BorderSide(
                                  width: 1.w, color: AppColors.darkBrownColor)),
                          icon: Image.asset(
                            AppResources.defaultIcon,
                            width: 16.w,
                            height: 16.h,
                          ),
                          label: Text(
                            "setAsPrimary".tr,
                            style: AppTextStyle.darkBrown14spTextStyle1,
                          ),
                        )
                      ],
                      8.verticalSpace,
                      ElevatedButton.icon(
                        style: const ButtonStyle(
                          backgroundColor:
                              WidgetStatePropertyAll(AppColors.lightRedColor),
                          elevation: WidgetStatePropertyAll(0),
                        ),
                        onPressed: () {
                          controller.addresses.removeAt(index);
                          controller.addresses.refresh();
                        },
                        label: Text(
                          "remove".tr,
                          maxLines: 1,
                          style: AppTextStyle.red14spTextStyle1,
                        ),
                        icon: Image.asset(
                          AppResources.deleteIcon,
                          width: 16.w,
                          height: 16.h,
                        ),
                      ),
                    ],
                  ),
                ))));
  }

  Obx _buildAddNewAddress() {
    return Obx(() => controller.addresses.length < 2
        ? Container(
            height: 270.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(20.r)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  offset: const Offset(0.0, 4.0),
                  blurRadius: 50.0,
                ),
              ],
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
                    style: AppTextStyle.primaryDarkGrey16spTextStyle)
              ],
            ),
          )
        : const SizedBox.shrink());
  }

  Theme buildRadioButton(BuildContext context, int value) {
    return Theme(
      data: Theme.of(context).copyWith(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        listTileTheme: const ListTileThemeData(
          horizontalTitleGap: 0,
          enableFeedback: false,
        ),
      ),
      child: Obx(() => RadioListTile(
            title: Text(
              'setAsDefault'.tr,
              style: controller.setAsDefault.value == value
                  ? AppTextStyle.secondaryBlack14spTextStyle1
                  : AppTextStyle.darkGreyColor14spTextStyle,
            ),
            activeColor: AppColors.blackColor,
            value: value,
            contentPadding: EdgeInsets.zero,
            visualDensity: const VisualDensity(vertical: -4),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            groupValue: controller.setAsDefault.value,
            onChanged: (int? value) {
              controller.setAsDefault.value = value!;
            },
          )),
    );
  }
}
