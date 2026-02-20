import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:zakat_fund/my_app/my_app.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_constant.dart';
import 'package:zakat_fund/utils/constants/app_resources.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/utils/constants/input_formatters.dart';
import 'package:zakat_fund/utils/enums/button_type.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/view_model/project_view_model.dart';
import 'package:zakat_fund/widgets/additional_doc_widget.dart';
import 'package:zakat_fund/widgets/cache_image.dart';
import 'package:zakat_fund/widgets/custom_button.dart';
import 'package:zakat_fund/widgets/elevated_button.dart';
import 'package:zakat_fund/widgets/expansion_tile_header.dart';
import 'package:zakat_fund/widgets/label_drop_down.dart';
import 'package:zakat_fund/widgets/label_drop_down2.dart';
import 'package:zakat_fund/widgets/label_text_field.dart';
import 'package:zakat_fund/widgets/my_app_bar.dart';
import 'package:zakat_fund/widgets/picture_instruct_widget.dart';
import 'package:zakat_fund/widgets/radio_list_tile.dart';
import 'package:zakat_fund/widgets/text_field_label.dart';

class CreateProjectScreen extends GetView<ProjectViewModel> {
  const CreateProjectScreen({super.key});

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
          controller: controller.scrollController,
          padding: EdgeInsets.symmetric(vertical: 16.h),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildUploadPhotoOrVideo(),
                16.verticalSpace,
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Utils.isArabic ? nameInArabic() : nameInEnglish(),
                      16.verticalSpace,
                      Utils.isArabic ? nameInEnglish() : nameInArabic(),
                      16.verticalSpace,
                      LabelTextField(
                        controller: controller.startDateController,
                        label: 'startDate',
                        readOnly: true,
                        focusNode: controller.startDateNode,
                        isRequired: true,
                        checkValidation: true,
                        isDate: true,
                        onTap: () =>
                            controller.datePickerDialog(startDate: true),
                      ),
                      16.verticalSpace,
                      LabelTextField(
                        controller: controller.endDateController,
                        label: 'endDate',
                        focusNode: controller.endDateNode,
                        readOnly: true,
                        isDate: true,
                        validator: (txt) => controller.validateEndDate(txt),
                        onTap: () => controller.datePickerDialog(endDate: true),
                        isRequired: true,
                        checkValidation: true,
                      ),
                      16.verticalSpace,
                      Obx(() => LabelDropDown2(
                            items: controller.beneficiariesList.value,
                            selectedValue: controller.selectedBeneficiary.value,
                            onChanged: (value) =>
                                controller.selectedBeneficiary.value = value,
                            isRequired: true,
                            focusNode: controller.beneficiariesOfProjectNode,
                            label: 'beneficiariesOfTheProject',
                          )),
                      16.verticalSpace,
                      LabelTextField(
                        controller: controller.noOfBeneficiariesController,
                        label: 'noOfBeneficiaries',
                        focusNode: controller.noOfBeneficiariesNode,
                        isRequired: true,
                        checkValidation: true,
                        keyboardType: TextInputType.number,
                        inputFormatters: InputFormatters.amountFormatter,
                      ),
                      16.verticalSpace,
                      LabelTextField(
                        controller: controller.projectGoalController,
                        label: 'projectGoal',
                        amountOnly: true,
                        checkValidation: true,
                        focusNode: controller.projectGoalNode,
                        keyboardType: TextInputType.number,
                        isRequired: true,
                        inputFormatters: InputFormatters.amountFormatter,
                      ),
                      16.verticalSpace,
                      Utils.isArabic ? briefDescArabic() : briefDescEnglish(),
                      16.verticalSpace,
                      Utils.isArabic ? briefDescEnglish() : briefDescArabic(),
                      16.verticalSpace,
                      LabelTextField(
                        label: 'projectLicense',
                        isRequired: true,
                        readOnly: true,
                        focusNode: controller.projectLicenseNode,
                        checkValidation: true,
                        onAddFile: () => controller.addFile(),
                        controller: controller.projectLicenseController,
                      ),
                      6.verticalSpace,
                      pictureInstructWidget(),
                      16.verticalSpace,
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: LabelTextField(
                              controller: controller.licenseStartDateController,
                              label: 'licenseStartDate',
                              readOnly: true,
                              focusNode: controller.licenseStartDateNode,
                              isRequired: true,
                              checkValidation: true,
                              isDate: true,
                              onTap: () => controller.datePickerDialog(
                                  licenseStart: true),
                            ),
                          ),
                          8.horizontalSpace,
                          Expanded(
                            child: LabelTextField(
                              controller: controller.licenseEndDateController,
                              label: 'licenseEndDate',
                              readOnly: true,
                              focusNode: controller.licenseEndDateNode,
                              isDate: true,
                              isRequired: true,
                              checkValidation: true,
                              onTap: () =>
                                  controller.datePickerDialog(licenseEnd: true),
                            ),
                          ),
                        ],
                      ),
                      16.verticalSpace,
                      Utils.isArabic ? longDescArabic() : logDescEnglish(),
                      16.verticalSpace,
                      Utils.isArabic ? logDescEnglish() : longDescArabic(),
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
                      ),
                      16.verticalSpace,
                      LabelTextField(
                        controller: controller.twitterController,
                        label: 'twitter',
                        hint: "https://www.twitter.com/",
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
                      16.verticalSpace,
                      LabelTextField(
                        controller: controller.websiteController,
                        label: 'otherLink',
                        isBlack: true,
                        prefixIcon: AppResources.websiteIcon,
                      ),
                      16.verticalSpace,
                      LabelTextField(
                        controller: controller.quickAmountController,
                        label: 'addQuickAmounts',
                        focusNode: controller.quickAmountNode,
                        amountOnly: true,
                        addAmount: true,
                        keyboardType: TextInputType.number,
                        inputFormatters: InputFormatters.amountFormatter,
                        onAdd: () => controller.addQuickAmounts(),
                      ),
                      _amountWrap(),
                      16.verticalSpace,
                      textFieldLabel(label: "category", isRequired: true),
                      4.verticalSpace,
                      _buildSelectedCategories(),
                      _buildCategoryErrorMessage(),
                      8.verticalSpace,
                      _categoryWrap(),
                      _buildAddQuantities(),
                      16.verticalSpace,
                      textFieldLabel(label: "urgentProject"),
                      8.verticalSpace,
                      Obx(() => Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: List.generate(
                                controller.urgentProject.value.choices.length,
                                (index) => radioListTile(
                                        0,
                                        index,
                                        controller
                                            .urgentProject.value.choices[index],
                                        controller
                                            .urgentProject.value.selectedChoice,
                                        onChanged: (index) {
                                      controller.urgentProject.value
                                          .selectedChoice = index!;
                                      controller.urgentProject.refresh();
                                    })).toList(),
                          )),
                      16.verticalSpace,
                      LabelTextField(
                        controller: controller.minimumAmountController,
                        label: 'addMinimumAmount',
                        amountOnly: true,
                        focusNode: controller.minimumAmountNode,
                        isRequired: true,
                        keyboardType: TextInputType.number,
                        checkValidation: true,
                        inputFormatters: InputFormatters.amountFormatter,
                      ),
                      6.verticalSpace,
                      Text(
                        "minimumDonationHint".tr,
                        style: AppTextStyle.primaryDarkGrey12spTextStyle1,
                      ),
                      16.verticalSpace,
                      featuredContainer(),
                      additionalDocuments(),
                      25.verticalSpace,
                      CustomButton(
                        buttonType: ButtonType.submit,
                        onPressed: () => controller.submitProject(),
                      ),
                      10.verticalSpace,
                      CustomButton(
                        buttonType: ButtonType.preview,
                        onPressed: () =>
                            controller.submitProject(showPreview: true),
                      ),
                      10.verticalSpace,
                      if (controller.project == null ||
                          controller.project?.requestStatus == 8)
                        Padding(
                          padding: EdgeInsets.only(bottom: 10.h),
                          child: CustomButton(
                            buttonType: ButtonType.draft,
                            onPressed: () =>
                                controller.submitProject(saveAsDraft: true),
                          ),
                        ),
                      CustomButton(
                        buttonType: ButtonType.cancel,
                        onPressed: () => Get.back(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Obx _buildAddQuantities() {
    return Obx(() => controller.amounts.value.isNotEmpty
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              16.verticalSpace,
              textFieldLabel(label: "addQuantities"),
              8.verticalSpace,
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: List.generate(
                    controller.addQuantities.value.choices.length,
                    (index) => radioListTile(
                            0,
                            index,
                            controller.addQuantities.value.choices[index],
                            controller.addQuantities.value.selectedChoice,
                            onChanged: (index) {
                          controller.addQuantities.value.selectedChoice =
                              index!;
                          controller.addQuantities.refresh();
                        })).toList(),
              ),
            ],
          )
        : const SizedBox.shrink());
  }

  Obx _buildCategoryErrorMessage() {
    return Obx(() => controller.isClicked.value &&
            controller.selectedCategories.isEmpty
        ? Padding(
            padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 8.h),
            child: Text(
              "${"category".tr} ${"isRequired".tr}",
              style:
                  TextStyle(color: Get.theme.colorScheme.error, fontSize: 12),
            ),
          )
        : const SizedBox.shrink());
  }

  Obx _buildSelectedCategories() {
    return Obx(() => Focus(
          focusNode: controller.categoriesNode,
          child: Container(
            height: 50,
            alignment:
                Utils.isArabic ? Alignment.centerRight : Alignment.centerLeft,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            decoration: BoxDecoration(
                color: AppColors.lightGreyColor,
                borderRadius: BorderRadius.circular(100.r),
                border: Border.all(
                    width: 1.w, color: AppColors.secondaryLightGreyColor)),
            child: ListView.separated(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: controller.selectedCategories.length,
              separatorBuilder: (BuildContext context, int index) =>
                  8.horizontalSpace,
              itemBuilder: (BuildContext context, int index) {
                return RawChip(
                  onDeleted: () => controller.removeCategory(index),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  label: Text(Utils.isArabic
                      ? controller.selectedCategories[index].nameAr
                          .toString()
                          .tr
                      : controller.selectedCategories[index].name
                          .toString()
                          .tr),
                  labelStyle: AppTextStyle.darkBrown14spTextStyle1,
                  deleteIconColor: AppColors.darkBrownColor,
                  side: BorderSide(color: AppColors.darkBrownColor, width: 1.w),
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50.r)),
                );
              },
            ),
          ),
        ));
  }

  Column _buildUploadPhotoOrVideo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Text(
            "addPhotoOrVideo".tr,
            style: AppTextStyle.secondaryPrimaryBlack16spTextStyle,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Text(
            "max10Photos".tr,
            style: AppTextStyle.darkGrey14spTextStyle,
          ),
        ),
        16.verticalSpace,
        _buildUploadPhoto(),
        Obx(() => controller.isClicked.value && controller.imagesList.isEmpty
            ? Padding(
                padding: EdgeInsets.only(left: 32.w, right: 32.w, top: 8.h),
                child: Text(
                  "add1Image".tr,
                  style: TextStyle(
                      color: Get.theme.colorScheme.error, fontSize: 12),
                ),
              )
            : const SizedBox.shrink()),
        _buildImageListView(),
      ],
    );
  }

  Container featuredContainer() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          color: Colors.white,
          border: Border.all(color: const Color(0xffD1D0D1), width: 1.w)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Obx(() => LabelDropDown(
          //       items: controller.featuredProject,
          //       selectedValue: controller.selectedFeaturedForAssociation.value,
          //       onChanged: (value) {
          //         controller.selectedFeaturedForAssociation.value = value!;
          //       },
          //       label: 'featuredForAssociation',
          //     )),
          // 16.verticalSpace,
          Obx(() => LabelDropDown(
                items: AppConstant.popUpCloseButtons,
                selectedValue: controller.selectedFeaturedForWebAp.value,
                onChanged: (value) {
                  controller.selectedFeaturedForWebAp.value = value!;
                },
                label: 'featuredForAppWeb',
              )),
          Obx(() => controller.selectedFeaturedForAssociation.value == "yes" ||
                  controller.selectedFeaturedForWebAp.value == "yes"
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    16.verticalSpace,
                    LabelTextField(
                      controller: controller.titleInEnglishController,
                      label: 'titleInEnglish',
                      isRequired: true,
                      focusNode: controller.titleInEnglishNode,
                      checkValidation: true,
                      inputFormatters: InputFormatters.englishAddressFormatter,
                    ),
                    16.verticalSpace,
                    LabelTextField(
                      controller: controller.titleInArabicController,
                      label: 'titleInArabic',
                      focusNode: controller.titleInArabicNode,
                      isRequired: true,
                      checkValidation: true,
                      inputFormatters: InputFormatters.arabicAddressFormatter,
                    ),
                    16.verticalSpace,
                    LabelTextField(
                      controller: controller.static1EnglishController,
                      label: 'static1English',
                      focusNode: controller.static1EnglishNode,
                      isRequired: true,
                      checkValidation: true,
                      inputFormatters: InputFormatters.englishAddressFormatter,
                    ),
                    16.verticalSpace,
                    LabelTextField(
                      controller: controller.static1ArabicController,
                      label: 'static1Arabic',
                      focusNode: controller.static1ArabicNode,
                      isRequired: true,
                      checkValidation: true,
                      inputFormatters: InputFormatters.arabicAddressFormatter,
                    ),
                    16.verticalSpace,
                    LabelTextField(
                      controller: controller.static1DescEnglishController,
                      label: 'static1DescEnglish',
                      focusNode: controller.static1DescEnglishNode,
                      isRequired: true,
                      checkValidation: true,
                      maxLines: 3,
                      inputFormatters: InputFormatters.englishAddressFormatter,
                    ),
                    16.verticalSpace,
                    LabelTextField(
                      controller: controller.static1DescArabicController,
                      label: 'static1DescArabic',
                      focusNode: controller.static1DescArabicNode,
                      isRequired: true,
                      checkValidation: true,
                      maxLines: 3,
                      inputFormatters: InputFormatters.arabicAddressFormatter,
                    ),
                    16.verticalSpace,
                    LabelTextField(
                      controller: controller.static2EnglishController,
                      label: 'static2English',
                      isRequired: true,
                      checkValidation: true,
                      focusNode: controller.static2EnglishNode,
                      inputFormatters: InputFormatters.englishAddressFormatter,
                    ),
                    16.verticalSpace,
                    LabelTextField(
                      controller: controller.static2ArabicController,
                      label: 'static2Arabic',
                      focusNode: controller.static2ArabicNode,
                      isRequired: true,
                      checkValidation: true,
                      inputFormatters: InputFormatters.arabicAddressFormatter,
                    ),
                    16.verticalSpace,
                    LabelTextField(
                      controller: controller.static2DescEnglishController,
                      label: 'static2DescEnglish',
                      isRequired: true,
                      focusNode: controller.static2DescEnglishNode,
                      checkValidation: true,
                      maxLines: 3,
                      inputFormatters: InputFormatters.englishAddressFormatter,
                    ),
                    16.verticalSpace,
                    LabelTextField(
                      controller: controller.static2DescArabicController,
                      label: 'static2DescArabic',
                      isRequired: true,
                      focusNode: controller.static2DescArabicNode,
                      checkValidation: true,
                      maxLines: 3,
                      inputFormatters: InputFormatters.arabicAddressFormatter,
                    ),
                    16.verticalSpace,
                    LabelTextField(
                      label: 'projectCoverForApp',
                      controller: controller.projectCoverForAppController,
                      isRequired: true,
                      readOnly: true,
                      checkValidation: true,
                      onAddFile: () => controller.addCover(isApp: true),
                    ),
                    6.verticalSpace,
                    pictureInstructWidget(),
                    16.verticalSpace,
                    LabelTextField(
                      label: 'projectCoverForWeb',
                      controller: controller.projectCoverForWebController,
                      isRequired: true,
                      readOnly: true,
                      checkValidation: true,
                      onAddFile: () => controller.addCover(),
                    ),
                    6.verticalSpace,
                    pictureInstructWidget(),
                  ],
                )
              : const SizedBox.shrink()),
        ],
      ),
    );
  }

  LabelTextField longDescArabic() {
    return LabelTextField(
      controller: controller.longDescriptionInArabicController,
      label: 'longDescriptionInArabic',
      focusNode: controller.longDescriptionInArabicNode,
      inputFormatters: InputFormatters.arabicAddressFormatter,
      checkValidation: true,
      isRequired: true,
      maxLines: 4,
    );
  }

  LabelTextField logDescEnglish() {
    return LabelTextField(
      controller: controller.longDescriptionInEnglishController,
      label: 'longDescriptionInEnglish',
      checkValidation: true,
      isRequired: true,
      focusNode: controller.longDescriptionInEnglishNode,
      inputFormatters: InputFormatters.englishAddressFormatter,
      maxLines: 4,
    );
  }

  LabelTextField briefDescArabic() {
    return LabelTextField(
      controller: controller.briefDescriptionInArabicController,
      label: 'briefDescriptionInArabic',
      isRequired: true,
      maxLength: 300,
      focusNode: controller.briefDescriptionInArabicNode,
      checkValidation: true,
      maxLines: 3,
      inputFormatters: InputFormatters.arabicAddressFormatter,
    );
  }

  LabelTextField briefDescEnglish() {
    return LabelTextField(
      controller: controller.briefDescriptionInEnglishController,
      label: 'briefDescriptionInEnglish',
      focusNode: controller.briefDescriptionInEnglishNode,
      inputFormatters: InputFormatters.englishAddressFormatter,
      isRequired: true,
      maxLength: 300,
      maxLines: 3,
      checkValidation: true,
    );
  }

  LabelTextField nameInArabic() {
    return LabelTextField(
      controller: controller.projectNameInArabicController,
      label: 'projectNameInArabic',
      isRequired: true,
      maxLength: 75,
      checkValidation: true,
      focusNode: controller.projectNameInArabicNode,
      maxLines: 3,
      inputFormatters: InputFormatters.arabicAddressFormatter,
    );
  }

  LabelTextField nameInEnglish() {
    return LabelTextField(
      controller: controller.projectNameInEnglishController,
      label: 'projectNameInEnglish',
      isRequired: true,
      maxLength: 75,
      focusNode: controller.projectNameInEnglishNode,
      maxLines: 3,
      checkValidation: true,
      inputFormatters: InputFormatters.englishAddressFormatter,
    );
  }

  Widget _buildImageListView() {
    return Obx(() => controller.imagesList.isNotEmpty
        ? SizedBox(
            height: 132.h,
            child: ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              itemCount: controller.imagesList.length,
              scrollDirection: Axis.horizontal,
              separatorBuilder: (BuildContext context, int index) =>
                  8.horizontalSpace,
              itemBuilder: (BuildContext context, int index) => Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.r),
                    child: controller.imagesList[index].mediaType == 1
                        ? FutureBuilder(
                            future: controller.imagesList[index].urlImage
                                ? Utils.urlThumbnail(
                                    controller.imagesList[index].image)
                                : Utils.fileThumbnail(
                                    controller.imagesList[index].image),
                            builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
                              if (snapshot.hasData) {
                                return controller.imagesList[index].urlImage
                                    ? Image.file(
                                        File(snapshot.data),
                                        fit: BoxFit.cover,
                                        width: 150.w,
                                        height: 100.h,
                                      )
                                    : Image.memory(
                                        snapshot.data,
                                        fit: BoxFit.cover,
                                        width: 150.w,
                                        height: 100.h,
                                      );
                              } else if (snapshot.hasError) {
                                return Image.asset(
                                  AppResources.placeholder,
                                  fit: BoxFit.cover,
                                  width: 150.w,
                                  height: 100.h,
                                );
                              } else {
                                return Image.asset(
                                  AppResources.placeholder,
                                  fit: BoxFit.cover,
                                  width: 150.w,
                                  height: 100.h,
                                );
                              }
                            },
                          )
                        : controller.imagesList[index].urlImage
                            ? CachedImage(
                                image: controller.imagesList[index].image,
                                width: 150.w,
                                height: 100.h)
                            : Image.file(
                                File(controller.imagesList[index].image),
                                width: 150.w,
                                height: 100.h,
                                fit: BoxFit.cover,
                              ),
                  ),
                  IconButton(
                      onPressed: () {
                        controller.imagesList.removeAt(index);
                        controller.imagesList.refresh();
                      },
                      visualDensity: VisualDensity.compact,
                      icon: SvgPicture.asset(
                        AppResources.closeCircleIcon,
                      )),
                  if (controller.imagesList[index].mediaType == 1)
                    Positioned(
                      right: 0,
                      left: 0,
                      top: 0,
                      bottom: 0,
                      child: Center(
                        child: SvgPicture.asset(
                          AppResources.playIcon,
                          width: 33.w,
                          height: 33.h,
                        ),
                      ),
                    )
                ],
              ),
            ),
          )
        : const SizedBox.shrink());
  }

  Padding _buildUploadPhoto() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: GestureDetector(
        onTap: () {
          mediaDialog();
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.r),
          child: Container(
            height: 140.h,
            color: AppColors.warningBackColor,
            child: DottedBorder(
              options: RoundedRectDottedBorderOptions(
                color: AppColors.darkBrownColor,
                strokeWidth: 4.w,
                // borderType: BorderType.RRect,
                radius: Radius.circular(20.r),
                dashPattern: const [16],
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      AppResources.uploadIcon,
                      width: 40.w,
                      height: 40.h,
                    ),
                    8.verticalSpace,
                    Text(
                      "uploadPhotoOrVideo".tr,
                      style: AppTextStyle.darkBrown16spTextStyle,
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _categoryWrap() {
    return Obx(() => Wrap(
        runSpacing: 8.h,
        spacing: 8.w,
        alignment: WrapAlignment.start,
        children: List.generate(
            controller.categoriesList.value.length,
            (index) => RawChip(
                  onDeleted: () => controller.addCategory(index),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  label: Text(Utils.isArabic
                      ? controller.categoriesList.value[index].nameAr
                          .toString()
                          .tr
                      : controller.categoriesList.value[index].name
                          .toString()
                          .tr),
                  labelStyle: AppTextStyle.btnText14spTextStyle1,
                  deleteIcon: const Icon(CupertinoIcons.add_circled_solid),
                  deleteIconColor: AppColors.btnTextColor,
                  side: BorderSide(color: AppColors.darkBrownColor, width: 1.w),
                  backgroundColor: themeViewModel.color,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50.r)),
                )).toList()));
  }

  Widget _amountWrap() {
    return Obx(() => controller.amounts.value.isNotEmpty
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              16.verticalSpace,
              Wrap(
                  runSpacing: 8.h,
                  spacing: 8.w,
                  alignment: WrapAlignment.start,
                  children: List.generate(
                      controller.amounts.length,
                      (index) => RawChip(
                            onDeleted: () =>
                                controller.deleteQuickAmount(index),
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            label: Text(
                                "${controller.amounts[index]} ${"currency".tr}"),
                            labelStyle: AppTextStyle.darkBrown14spTextStyle1,
                            deleteIconColor: AppColors.darkBrownColor,
                            side: BorderSide(
                                color: AppColors.darkBrownColor, width: 1.w),
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50.r)),
                          )).toList()),
            ],
          )
        : const SizedBox.shrink());
  }

  mediaDialog() {
    Get.dialog(Dialog(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(8)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "addPhotoOrVideo1".tr,
                  maxLines: 1,
                  style: AppTextStyle.secondaryPrimaryBlack16spTextStyle,
                ),
                GestureDetector(
                    onTap: () => Get.back(),
                    child: const Icon(
                      Icons.highlight_remove_outlined,
                      color: AppColors.secondaryPrimaryBlackColor,
                    ))
              ],
            ),
            16.verticalSpace,
            ListTile(
                leading: SvgPicture.asset(AppResources.galleryIcon),
                title: Text(
                  "image".tr,
                  style: AppTextStyle.secondaryDarkGrey16spTextStyle1,
                ),
                onTap: () {
                  Get.back();
                  controller.addImages();
                },
                contentPadding: EdgeInsets.zero,
                visualDensity: const VisualDensity(vertical: -4)),
            ListTile(
              leading: SvgPicture.asset(AppResources.videosIcon),
              title: Text("video".tr,
                  style: AppTextStyle.secondaryDarkGrey16spTextStyle1),
              onTap: () {
                Get.back();
                controller.addVideos();
              },
              contentPadding: EdgeInsets.zero,
              visualDensity: const VisualDensity(vertical: -4),
            ),
            16.verticalSpace,
            elevatedButton(text: "cancel", onPressed: () => Get.back())
          ],
        ),
      ),
    ));
  }

  Widget additionalDocuments() {
    return Obx(() => controller.additionalDocuments.isNotEmpty
        ? Column(
            children: [
              16.verticalSpace,
              expansionTileHeader(
                title: "additionalDocuments",
                isExpanded: controller.showAdditionalDocuments.value,
                onTap: () {
                  controller.showAdditionalDocuments.value =
                      !controller.showAdditionalDocuments.value;
                },
              ),
              if (controller.showAdditionalDocuments.value)
                Column(
                  children: List.generate(
                      controller.additionalDocuments.length,
                      (index) => AdditionalDocWidget(
                            document: controller.additionalDocuments[index],
                          )),
                )
            ],
          )
        : SizedBox.shrink());
  }
}
