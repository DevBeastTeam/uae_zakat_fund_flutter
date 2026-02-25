import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:zakat_fund/my_app/my_app.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_resources.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/utils/constants/input_formatters.dart';
import 'package:zakat_fund/utils/enums/button_type.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/utils/validator.dart';
import 'package:zakat_fund/view/donor/individual/add_address_screen.dart';
import 'package:zakat_fund/view_model/address_view_model.dart';
import 'package:zakat_fund/widgets/custom_button.dart';
import 'package:zakat_fund/widgets/elevated_icon_button.dart';
import 'package:zakat_fund/widgets/label_drop_down2.dart';
import 'package:zakat_fund/widgets/label_text_field.dart';
import 'package:zakat_fund/widgets/picture_instruct_widget.dart';
import 'package:zakat_fund/widgets/text_field_label.dart';

class ContactInfoScreen extends StatelessWidget {
  final dynamic controller;
  final bool isAssociation;

  const ContactInfoScreen(this.controller,
      {super.key, required this.isAssociation});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.contactInfoFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Obx(() => Column(
                children: [
                  LabelTextField(
                    controller: controller.emailController,
                    focusNode: controller.emailNode,
                    label: 'email',
                    isRequired: true,
                    isArabicDirection: true,
                    keyboardType: TextInputType.emailAddress,
                    hint: "abc@xyz.com",
                    checkValidation: true,
                    readOnly: showChangePasswordBox.isEmpty,
                    showVerify: !controller.isEmailVerified.value,
                    onChanged: controller.onChangeEmail,
                    onVerify: () {
                      String value = controller.emailController.text;
                      String? isValidate = Validator.validateEmailId(value: value);
                    },
                    validator: (value) => Validator.validateEmailId(value: value!),
                    inputFormatters: InputFormatters.denySpaces,
                  ),
                  if (controller.isEmailVerified.value)
                    _buildVerifyLabel("emailVerified"),
                ],
              )),
          16.verticalSpace,
          Obx(() => Column(
                children: [
                  LabelTextField(
                    controller: controller.phoneNumberController,
                    label: 'phoneNumber',
                    isRequired: true,
                    focusNode: controller.phoneNumberNode,
                    hint: "+971xxxxxxxxx",
                    keyboardType: TextInputType.number,
                    isArabicDirection: true,
                    readOnly: controller.isPhoneVerified.value,
                    showVerify: !controller.isPhoneVerified.value,
                    onVerify: () => controller
                        .sendOTP(controller.phoneNumberController.text),
                    inputFormatters: [
                      MaskTextInputFormatter(
                        mask: "+971#########",
                        initialText: "+971",
                        filter: {"#": RegExp(r'[0-9]')},
                      )
                    ],
                    checkValidation: true,
                  ),
                  if (controller.isPhoneVerified.value)
                    _buildVerifyLabel("mobileVerified"),
                ],
              )),
          16.verticalSpace,
          LabelTextField(
            controller: controller.faxController,
            label: 'fax',
            hint: "+971xxxxxxxxx",
            focusNode: controller.faxNode,
            keyboardType: TextInputType.number,
            isArabicDirection: true,
            inputFormatters: [
              MaskTextInputFormatter(
                mask: "+971#########",
                initialText: "+971",
                filter: {"#": RegExp(r'[0-9]')},
              )
            ],
          ),
          16.verticalSpace,
          LabelTextField(
            controller: controller.websiteController,
            label: 'website',
            focusNode: controller.websiteNode,
            isRequired: true,
            checkValidation: true,
            hint: "www.abc.xyz",
            inputFormatters: InputFormatters.denySpaces,
          ),
          16.verticalSpace,
          Obx(() => LabelDropDown2(
              isRequired: true,
              showSearch: true,
              focusNode: controller.countryNode,
              items: controller.countriesList.value,
              selectedValue: controller.selectedCountry.value,
              onChanged: (value) {
                if (controller.selectedCountry.value == value) {
                  return;
                }
                controller.selectedCountry.value = value;
                controller.checkUAE();
                controller.fetchEmirates();
              },
              hint: 'chooseAnOption',
              label: 'country')),
          16.verticalSpace,
          Obx(() =>
              controller.selectedCountry.value != null && controller.isUAE.value
                  ? Column(
                      children: [
                        LabelDropDown2(
                            isRequired: true,
                            showSearch: true,
                            focusNode: controller.emirateNode,
                            items: controller.emiratesList.value,
                            selectedValue: controller.selectedEmirate.value,
                            onChanged: (value) {
                              if (controller.selectedEmirate.value == value) {
                                return;
                              }
                              controller.selectedEmirate.value = value;
                              controller.fetchCities();
                            },
                            hint: 'chooseAnOption',
                            label: 'emirate'),
                        16.verticalSpace,
                      ],
                    )
                  : const SizedBox.shrink()),
          Obx(() => controller.selectedCountry.value != null &&
                      !controller.isUAE.value ||
                  controller.selectedCountry.value != null &&
                      controller.selectedEmirate.value != null &&
                      controller.isUAE.value
              ? Column(
                  children: [
                    LabelDropDown2(
                        isRequired: true,
                        showSearch: true,
                        focusNode: controller.cityNode,
                        items: controller.citiesList.value,
                        selectedValue: controller.selectedCity.value,
                        onChanged: (value) =>
                            controller.selectedCity.value = value,
                        hint: 'chooseAnOption',
                        label: 'city'),
                    16.verticalSpace,
                  ],
                )
              : const SizedBox.shrink()),
          LabelTextField(
            controller: controller.poBoxController,
            label: 'poBox',
            isArabicDirection: true,
          ),
          if (isAssociation) ...[
            16.verticalSpace,
            Utils.isArabic ? addressInArabic() : addressInEnglish(),
            16.verticalSpace,
            Utils.isArabic ? addressInEnglish() : addressInArabic()
          ],
          16.verticalSpace,
          LabelTextField(
            readOnly: true,
            label: 'firstSupportDocument',
            onAddFile: () => controller.addFile(fDocument: true),
            controller: controller.fDocumentController,
          ),
          6.verticalSpace,
          fileInstructWidget(),
          16.verticalSpace,
          LabelTextField(
            readOnly: true,
            label: 'secondSupportDocument',
            onAddFile: () => controller.addFile(sDocument: true),
            controller: controller.sDocumentController,
          ),
          6.verticalSpace,
          fileInstructWidget(),
          if (isAssociation) _buildSocialMediaInputs(),
          if (!isAssociation) _buildAddress(),
          16.verticalSpace,
          elevatedIconButton(
            text: "next",
            onPressed: () => controller.saveContactInfo(),
          ),
          16.verticalSpace,
          elevatedIconButton(
            text: "previous",
            backgroundColor: AppColors.lightGreyColor,
            next: false,
            onPressed: () {
              controller.currentSubTab.value = 0;
              controller.scrollToTop();
            },
          ),
          16.verticalSpace,
          if (controller.showSaveAsDraft)
            CustomButton(
              buttonType: ButtonType.draft,
              onPressed: () => controller.saveContactInfo(saveAsDraft: true),
            )
        ],
      ),
    );
  }

  Widget _buildAddress() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        textFieldLabel(label: "address".tr),
        16.verticalSpace,
        _buildAddressListView(),
        _buildAddNewAddress()
      ],
    );
  }

  Obx _buildAddNewAddress() {
    return Obx(() => controller.addresses.length < 2
        ? Container(
            height: 270.h,
            width: Get.width,
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
                  onTap: () async {
                    Get.delete<AddressViewModel>();
                    Get.put(AddressViewModel());
                    final result = await Navigator.push(
                      Get.context!,
                      MaterialPageRoute(
                        builder: (context) => const AddAddressScreen(),
                        fullscreenDialog: true,
                      ),
                    );
                    if (result != null) {
                      controller.addresses.add(result);
                    }
                  },
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
                        onPressed: () async {
                          Get.delete<AddressViewModel>();
                          Get.put(AddressViewModel());
                          final result = await Navigator.push(
                            Get.context!,
                            MaterialPageRoute(
                              builder: (context) => AddAddressScreen(
                                  address: controller.addresses[index]),
                              fullscreenDialog: true,
                            ),
                          );
                          if (result != null) {
                            controller.addresses[index] = result;
                            controller.addresses.refresh();
                          }
                        },
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
                          onPressed: () =>
                              controller.setAsDefaultAddress(index),
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

  Column _buildSocialMediaInputs() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        16.verticalSpace,
        textFieldLabel(label: "socialMediaLinks".tr),
        4.verticalSpace,
        LabelTextField(
          controller: controller.instagramController,
          label: 'instagram',
          hint: "https://www.instagram.com/",
          isBlack: true,
          inputFormatters: [
            MaskTextInputFormatter(
              mask:
                  "https://www.instagram.com/##############################################################",
              filter: {"#": RegExp(r'[0-9A-Za-z-@.]')},
            )
          ],
          prefixIcon: AppResources.instagramIcon,
          isRequired: true,
          checkValidation: true,
        ),
        16.verticalSpace,
        LabelTextField(
          controller: controller.twitterController,
          label: 'twitter',
          hint: "https://www.twitter.com/",
          isRequired: true,
          checkValidation: true,
          isBlack: true,
          inputFormatters: [
            MaskTextInputFormatter(
              mask:
                  "https://www.twitter.com/##############################################################",
              filter: {"#": RegExp(r'[0-9A-Za-z-@.]')},
            )
          ],
          prefixIcon: AppResources.twitterIcon,
        ),
        16.verticalSpace,
        LabelTextField(
          controller: controller.facebookController,
          label: 'facebook',
          isBlack: true,
          hint: "https://www.facebook.com/",
          isRequired: true,
          checkValidation: true,
          inputFormatters: [
            MaskTextInputFormatter(
              mask:
                  "https://www.facebook.com/##############################################################",
              filter: {"#": RegExp(r'[0-9A-Za-z-@.]')},
            )
          ],
          prefixIcon: AppResources.facebookIcon,
        ),
        16.verticalSpace,
        LabelTextField(
          controller: controller.linkedInController,
          label: 'linkedIn',
          hint: 'https://www.linkedin.com/in/',
          isRequired: true,
          checkValidation: true,
          inputFormatters: [
            MaskTextInputFormatter(
              mask:
                  "https://www.linkedin.com/in/##############################################################",
              filter: {"#": RegExp(r'[0-9A-Za-z-@.]')},
            )
          ],
          isBlack: true,
          prefixIcon: AppResources.linkedinIcon,
        ),
      ],
    );
  }

  LabelTextField addressInArabic() {
    return LabelTextField(
      controller: controller.addressInArabicController,
      label: 'addressInArabic',
      focusNode: controller.addressInArabicNode,
      inputFormatters: InputFormatters.arabicAddressFormatter,
      isRequired: true,
      checkValidation: true,
    );
  }

  LabelTextField addressInEnglish() {
    return LabelTextField(
      controller: controller.addressInEnglishController,
      label: 'addressInEnglish',
      focusNode: controller.addressInEnglishNode,
      inputFormatters: InputFormatters.englishAddressFormatter,
      isRequired: true,
      checkValidation: true,
    );
  }

  Widget _buildVerifyLabel(String label) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      4.verticalSpace,
      Row(
        children: [
          const Icon(
            CupertinoIcons.check_mark_circled_solid,
            color: AppColors.greenColor,
          ),
          8.horizontalSpace,
          Text(
            label.tr,
            style: AppTextStyle.green14spTextStyle,
          ),
        ],
      ),
    ]);
  }
}
