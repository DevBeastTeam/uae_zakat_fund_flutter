import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_constant.dart';
import 'package:zakat_fund/utils/constants/app_resources.dart';
import 'package:zakat_fund/utils/constants/input_formatters.dart';
import 'package:zakat_fund/utils/enums/button_type.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/view_model/add_ads_view_model.dart';
import 'package:zakat_fund/widgets/activity_log_btn.dart';
import 'package:zakat_fund/widgets/custom_button.dart';
import 'package:zakat_fund/widgets/label_drop_down.dart';
import 'package:zakat_fund/widgets/label_text_field.dart';
import 'package:zakat_fund/widgets/my_app_bar.dart';
import 'package:zakat_fund/widgets/picture_instruct_widget.dart';
import 'package:zakat_fund/widgets/text_field_label.dart';

class AddAdsScreen extends GetView<AddAdsViewModel> {
  const AddAdsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: myAppBar(title: controller.getTitle()),
      body: _buildBody(context),
    );
  }

  KeyboardDismissOnTap _buildBody(BuildContext context) {
    return KeyboardDismissOnTap(
        child: KeyboardActions(
      config: Utils.buildConfig(context, controller.keyboardActionsItem),
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Form(
          key: controller.formKey,
          child: Column(
            children: [
              activityLogBtn(model: controller.ads,status: controller.ads?.requestStatus,id:controller.ads?.id,type: "Ads"),
              Obx(() => LabelDropDown(
                    items: AppConstant.adsTypes,
                    selectedValue: controller.selectedType.value,
                    hint: "chooseAnOption",
                    onChanged: (value)=>controller.onChangeType(value!),
                    label: 'adType',
                  )),
              16.verticalSpace,
              Obx(() => LabelDropDown(
                    items: AppConstant.languages,
                    selectedValue: controller.selectedLanguage.value,
                    hint: "chooseAnOption",
                    onChanged: (value)=>controller.onChangeLanguage(value!),
                    label: 'language',
                  )),
              16.verticalSpace,
              Obx(() => controller.selectedLanguage.value == "english"
                    ? _buildEnglishContent()
                    : _buildArabicContent(),
              ),
              16.verticalSpace,
              LabelTextField(
                controller: controller.publishDateTime,
                label: 'publishScheduleTime',
                isRequired: true,
                isDate: true,
                checkValidation: true,
                readOnly: true,
                onTap: () => controller.dateTimePicker(),
              ),
              16.verticalSpace,
              LabelTextField(
                controller: controller.expiryDateTime,
                label: 'expiryDate',
                isRequired: true,
                isDate: true,
                checkValidation: true,
                readOnly: true,
                onTap: () => controller.dateTimePicker(expiry: true),
              ),
              16.verticalSpace,
              Obx(() => controller.selectedType.value == "banner"
                  ? _buildBannerContent()
                  : _buildPopUpContent()),
              16.verticalSpace,
              CustomButton(
                buttonType: ButtonType.submit,
                onPressed: () => controller.saveAds(),
              ),
              10.verticalSpace,
              CustomButton(
                buttonType: ButtonType.preview,
                onPressed: () => controller.saveAds(isPreview: true),
              ),
              10.verticalSpace,
              if (controller.ads == null || controller.ads?.requestStatus == 8)
                Padding(
                  padding: EdgeInsets.only(bottom: 10.h),
                  child: CustomButton(
                    buttonType: ButtonType.draft,
                    onPressed: () => controller.saveAds(saveAsDraft: true),
                  ),
                ),
              CustomButton(
                buttonType: ButtonType.cancel,
                onPressed: () => Get.back(),
              ),
            ],
          ),
        ),
      ),
    ));
  }

  Widget _buildBannerContent() {
    return Column(
      children: [
        textFieldLabel(label: "bannerTextColor", isRequired: true),
        4.verticalSpace,
        Container(
            width: Get.width,
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
            decoration: BoxDecoration(
                color: AppColors.lightGreyColor,
                borderRadius: BorderRadius.circular(50.r),
                border: Border.all(
                    width: 1.w, color: AppColors.secondaryLightGreyColor)),
            child: Row(
              children: [
                Obx(() => controller.selectedBannerTextColor.value != null
                    ? CircleAvatar(
                        radius: 10.r,
                        backgroundColor: Utils.hexToColor(
                            controller.selectedBannerTextColor.value),
                      )
                    : SizedBox.shrink()),
                Spacer(),
                GestureDetector(
                  onTap: () async {
                    Color? selectedColor = await Utils.colorPickerDialog();
                    if (selectedColor != null) {
                      controller.selectedBannerTextColor.value =
                          Utils.hexFromColor(selectedColor);
                    }
                  },
                  child: SvgPicture.asset(AppResources.paintBrushIcon),
                ),
              ],
            )),
      ],
    );
  }

  Widget _buildPopUpContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LabelTextField(
          controller: controller.duration,
          label: 'displayDurationInSeconds',
          isRequired: true,
          checkValidation: true,
          focusNode: controller.durationNode,
          inputFormatters: InputFormatters.amountFormatter,
          keyboardType: TextInputType.number,
        ),
        16.verticalSpace,
        Obx(() => LabelDropDown(
              items: AppConstant.popUpCloseButtons,
              selectedValue: controller.selectedCloseButton.value,
              isRequired: true,
              hint: "chooseAnOption",
              onChanged: (value) {
                controller.selectedCloseButton.value = value;
              },
              label: 'popUpCloseButton',
            )),
        16.verticalSpace,
        Obx(() => LabelDropDown(
              items: AppConstant.popUpPositions,
              selectedValue: controller.selectedPosition.value,
              isRequired: true,
              hint: "chooseAnOption",
              onChanged: (value) {
                controller.selectedPosition.value = value;
              },
              label: 'popUpPosition',
            )),
        16.verticalSpace,
        LabelTextField(
          label: 'icon',
          checkValidation: true,
          isRequired: true,
          readOnly: true,
          onAddFile: () => controller.addImage(icon: true),
          controller: controller.iconController,
        ),
        4.verticalSpace,
        pictureInstructWidget(),
        16.verticalSpace,
        LabelTextField(
          label: 'adImage',
          readOnly: true,
          onAddFile: () => controller.addImage(),
          controller: controller.imageController,
        ),
        4.verticalSpace,
        pictureInstructWidget(),
      ],
    );
  }

  Widget _buildEnglishContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LabelTextField(
          controller: controller.titleInEnglish,
          label: 'titleInEnglish',
          isRequired: true,
          checkValidation: true,
          focusNode: controller.titleInEnglishNode,
          inputFormatters: InputFormatters.englishNameFormatter,
        ),
        16.verticalSpace,
        LabelTextField(
          controller: controller.descInEnglish,
          label: 'descriptionInEnglish',
          focusNode: controller.descInEnglishNode,
          isRequired: true,
          maxLines: 4,
          checkValidation: true,
          inputFormatters: InputFormatters.englishAddressFormatter,
        ),
      ],
    );
  }

  Widget _buildArabicContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LabelTextField(
          controller: controller.titleInArabic,
          label: 'titleInArabic',
          isRequired: true,
          focusNode: controller.titleInArabicNode,
          checkValidation: true,
          inputFormatters: InputFormatters.arabicNameFormatter,
        ),
        16.verticalSpace,
        LabelTextField(
          controller: controller.descInArabic,
          label: 'descriptionInArabic',
          isRequired: true,
          focusNode: controller.descInArabicNode,
          maxLines: 4,
          checkValidation: true,
          inputFormatters: InputFormatters.arabicAddressFormatter,
        ),
      ],
    );
  }
}
