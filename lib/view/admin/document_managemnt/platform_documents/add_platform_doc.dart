import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_constant.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/utils/constants/input_formatters.dart';
import 'package:zakat_fund/view_model/platform_doc_view_model.dart';
import 'package:zakat_fund/widgets/elevated_button.dart';
import 'package:zakat_fund/widgets/label_drop_down.dart';
import 'package:zakat_fund/widgets/label_text_field.dart';
import 'package:zakat_fund/widgets/my_app_bar.dart';
import 'package:zakat_fund/widgets/radio_list_tile.dart';
import 'package:zakat_fund/widgets/text_field_label.dart';

class AddPlatformDoc extends GetView<PlatformDocViewModel> {
  const AddPlatformDoc({super.key});

  @override
  Widget build(BuildContext context) {
    return KeyboardDismissOnTap(
      child: Scaffold(
        appBar: myAppBar(title: "addNewDocument"),
        backgroundColor: Colors.white,
        body: _buildBody(),
      ),
    );
  }

  KeyboardDismissOnTap _buildBody() {
    return KeyboardDismissOnTap(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                LabelTextField(
                  controller: controller.docNameEnglishController,
                  label: "documentNameEnglish",
                  isRequired: true,
                  checkValidation: true,
                  hint: "enterDocumentName",
                ),
                16.verticalSpace,
                LabelTextField(
                  controller: controller.docNameArabicController,
                  label: "documentNameArabic",
                  isRequired: true,
                  checkValidation: true,
                  inputFormatters: InputFormatters.arabicNameFormatter,
                  hint: "enterDocumentName",
                ),
                16.verticalSpace,
                Obx(() => LabelDropDown(
                      items: AppConstant.associatedUserTypes,
                      selectedValue: controller.selectedAssociatedType.value,
                      isRequired: true,
                      hint: "chooseAnOption",
                      onChanged: (value) => controller.selectedAssociatedType.value = value,
                      label: 'associatedForm',
                    )),
                16.verticalSpace,
                ..._buildRequiredFields(),
                Obx(() => controller.requireFields[1].selectedChoice == 0
                    ? Padding(
                        padding: EdgeInsets.only(top: 16.h),
                        child: Column(
                          children: [
                            LabelTextField(
                              controller: controller.startDateEnglishController,
                              label: "dateFieldNameEnglish",
                              isRequired: true,
                              checkValidation: true,
                            ),
                            16.verticalSpace,
                            LabelTextField(
                              controller: controller.startDateArabicController,
                              label: "dateFieldNameArabic",
                              isRequired: true,
                              checkValidation: true,
                              inputFormatters: InputFormatters.arabicNameFormatter,

                            ),
                          ],
                        ),
                      )
                    : SizedBox.shrink()),
                Obx(() => controller.requireFields[2].selectedChoice == 1&&controller.requireFields[1].selectedChoice == 0
                    ? Padding(
                        padding: EdgeInsets.only(top: 16.h),
                        child: Column(
                          children: [
                            LabelTextField(
                              controller: controller.endDateEnglishController,
                              label: "dateFieldNameEnglish",
                              isRequired: true,
                              checkValidation: true,
                            ),
                            16.verticalSpace,
                            LabelTextField(
                              controller: controller.endDateArabicController,
                              label: "dateFieldNameArabic",
                              inputFormatters: InputFormatters.arabicNameFormatter,
                              isRequired: true,
                              checkValidation: true,
                            ),
                          ],
                        ),
                      )
                    : SizedBox.shrink()),
                16.verticalSpace,
                Obx(() => LabelDropDown(
                      items: AppConstant.fileTypes,
                      selectedValue: controller.selectedFileType.value,
                      isRequired: true,
                      hint: "chooseAnOption",
                      onChanged: (value) {
                        if (!controller.selectedTypes.contains(value)) {
                          controller.selectedFileType.value = value;
                          controller.selectedTypes.add(value!);
                        }
                      },
                      label: 'allowFileTypes',
                    )),
                _buildWrap(),
                elevatedButton(
                    text: Get.arguments?"update":"save",
                    onPressed: () => controller.savePlatformDocument(update: Get.arguments)),
                8.verticalSpace,
                elevatedButton(
                  text: "cancel",
                  onPressed: () {
                    Get.back();
                  },
                  backgroundColor: AppColors.lightGreyColor,
                ),
                16.verticalSpace,
              ],
            ),
          ),
        ),
      );
  }

  Obx _buildWrap() {
    return Obx(() => Padding(
                    padding: EdgeInsets.symmetric(vertical: 13.h),
                    child: Wrap(
                        runSpacing: 8.h,
                        spacing: 8.w,
                        alignment: WrapAlignment.start,
                        children: List.generate(controller.selectedTypes.length,
                            (index) {
                          return Chip(
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            label: Text(controller.selectedTypes[index]),
                            labelStyle: AppTextStyle.darkBrown12spTextStyle2,
                            deleteIcon:
                                const Icon(Icons.highlight_remove_outlined),
                            deleteIconColor: AppColors.darkBrownColor,
                            onDeleted: () {
                              controller.selectedTypes.removeAt(index);
                            },
                            side: BorderSide(
                                color: AppColors.darkBrownColor, width: 1.w),
                            backgroundColor: AppColors.chipBackgroundColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.r)),
                          );
                        }).toList()),
                  ));
  }

  List<Widget> _buildRequiredFields() {
    return List.generate(
                  controller.requireFields.length,
                  (index) => Obx(() => controller.requireFields[index].show
                      ? Row(
                          children: [
                            Expanded(
                                child: textFieldLabel(
                                    label: controller
                                        .requireFields[index].name.tr)),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: List.generate(
                                  controller
                                      .requireFields[index].choices.length,
                                  (innerIndex) => radioListTile(
                                          index,
                                          innerIndex,
                                          controller.requireFields[index]
                                              .choices[innerIndex],
                                          controller.requireFields[index]
                                              .selectedChoice,
                                          onChanged: (onIndex) {
                                        controller.requireFields[index]
                                            .selectedChoice = innerIndex;
                                        if (controller.requireFields[1]
                                                .selectedChoice ==
                                            0) {
                                          controller.requireFields[2].show =
                                              true;
                                        } else {
                                          controller.requireFields[2].show =
                                              false;
                                          controller.requireFields[2]
                                              .selectedChoice = 0;
                                        }
                                        controller.requireFields.refresh();
                                      })).toList(),
                            )
                          ],
                        )
                      : SizedBox.shrink()));
  }
}
