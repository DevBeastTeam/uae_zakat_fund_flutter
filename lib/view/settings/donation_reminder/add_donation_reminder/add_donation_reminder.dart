import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:zakat_fund/my_app/my_app.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_constant.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/utils/constants/input_formatters.dart';
import 'package:zakat_fund/utils/enums/button_type.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/view_model/add_donation_remioder_view_model.dart';
import 'package:zakat_fund/widgets/custom_button.dart';
import 'package:zakat_fund/widgets/elevated_button.dart';
import 'package:zakat_fund/widgets/label_drop_down.dart';
import 'package:zakat_fund/widgets/label_text_field.dart';
import 'package:zakat_fund/widgets/my_app_bar.dart';
import 'package:zakat_fund/widgets/text_field_label.dart';

class AddDonationReminderScreen extends GetView<AddDonationReminderViewModel> {
  const AddDonationReminderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: myAppBar(title: "addReminder"),
      body: _buildBody(),
    );
  }

  KeyboardDismissOnTap _buildBody() {
    return KeyboardDismissOnTap(
      child: KeyboardActions(
        config: Utils.buildConfig(Get.context!, controller.keyboardActionsItem),
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildReminderForm(),
                _buildReminderPreview(),
                elevatedButton(
                  text: controller.donationReminder != null ? "update" : "save",
                  onPressed: () => controller.saveReminder(),
                ),
                16.verticalSpace,
                CustomButton(
                  buttonType: ButtonType.cancel,
                  onPressed: () => Get.back(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildReminderPreview() {
    return Obx(() => controller.selectedProject.value != null &&
                controller.amount.value != "" &&
                controller.selectedMethods.isNotEmpty &&
                controller.selectedMonth.value != null &&
            controller.date.value != ""
        ? Container(
            margin: EdgeInsets.symmetric(vertical: 16.h),
            padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
            decoration: BoxDecoration(
              color: AppColors.mediumBackColor.withOpacity(0.10),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  "preview".tr,
                  style: AppTextStyle.btnBackground14spTextStyle,
                ),
                8.verticalSpace,
                RichText(
                  text: TextSpan(
                      text: 'remindedToDonate'.tr,
                      style: AppTextStyle.lightBlackColor12TextStyle,
                      children: <TextSpan>[
                        TextSpan(
                            text:
                                " ${controller.amount.value} ${"currency".tr}",
                            style: AppTextStyle.lightBlackColor12TextStyle1),
                        TextSpan(
                            text:
                                " ${"to".tr} ${controller.selectedProject.value != null ? ' "${controller.selectedProject.value.toString().trim()}" ' : ""}",
                            style: AppTextStyle.lightBlackColor12TextStyle),
                        TextSpan(
                            text:
                                "${"on".tr} ${controller.selectedMonth.value ?? ""}${controller.date.value} ${"via".tr} ${controller.selectedMethods.map((e) => e.tr).join(', ')}",
                            style: AppTextStyle.lightBlackColor12TextStyle)
                      ]),
                ),
              ],
            ),
          )
        : 16.verticalSpace);
  }

  Widget _buildReminderForm() {
    return Column(
      children: [
        Obx(() => LabelDropDown(
              items: AppConstant.yesNoList,
              isRequired: true,
              selectedValue: controller.selectedEnableReminder.value,
              hint: "chooseAnOption",
              onChanged: (value) => controller.onChangeEnableReminder(value!),
              label: 'enableDonationReminder',
            )),
        16.verticalSpace,
        LabelTextField(
          controller: controller.reminderNameController,
          isRequired: true,
          checkValidation: true,
          label: 'reminderName',
        ),
        16.verticalSpace,
        Obx(() => LabelDropDown(
              items: controller.projects.value,
              showSearch: true,
              isRequired: true,
              selectedValue: controller.selectedProject.value,
              hint: "chooseAnOption",
              onChanged: (value) => controller.onChangeProject(value!),
              label: 'project',
            )),
        16.verticalSpace,
        LabelTextField(
          controller: controller.donationAmountController,
          isRequired: true,
          amountOnly: true,
          focusNode: controller.amountNode,
          keyboardType: TextInputType.number,
          inputFormatters: InputFormatters.amountFormatter,
          checkValidation: true,
          onChanged: (val) => controller.onChangeDonationAmount(val),
          label: 'donationAmount',
        ),
        16.verticalSpace,
        Obx(() => LabelDropDown(
              items: AppConstant.reminderFrequencies,
              selectedValue: controller.selectedFrequency.value,
              hint: "chooseAnOption",
              isRequired: true,
              onChanged: (value)=>controller.onChangeReminderFrequency(value!),
              label: 'reminderFrequency',
            )),
        16.verticalSpace,
        Obx(() => controller.selectedFrequency.value == "monthly"
            ? Column(
                children: [
                  LabelDropDown(
                    items: controller.months,
                    isRequired: true,
                    showSearch: true,
                    selectedValue: controller.selectedMonth.value,
                    hint: "chooseAnOption",
                    onChanged: (value) => controller.onChangeMonth(value!),
                    label: 'selectMonth',
                  ),
                  16.verticalSpace,
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LabelTextField(
                    controller: controller.reminderDateController,
                    isRequired: true,
                    isDate: true,
                    onTap: () => controller.datePickerDialog(),
                    readOnly: true,
                    checkValidation: true,
                    label: 'selectDate',
                  ),
                  Obx(() => CheckboxListTile(
                        value: controller.isAgree.value,
                        contentPadding: EdgeInsets.zero,
                        checkboxShape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.r)),
                        onChanged: (value)=>controller.onChangeAgree(value!),
                        controlAffinity: ListTileControlAffinity.leading,
                        title: Text(
                          "annualReminder".tr,
                          style:
                              AppTextStyle.secondaryPrimaryBlack14spTextStyle,
                        ),
                      )),
                ],
              )),
        // 16.verticalSpace,
        textFieldLabel(label: "notificationMethods", isRequired: true),
        4.verticalSpace,
        Obx(() => Container(
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
                itemCount: controller.selectedMethods.length,
                separatorBuilder: (BuildContext context, int index) =>
                    8.horizontalSpace,
                itemBuilder: (BuildContext context, int index) {
                  return RawChip(
                    onDeleted: () => controller.removeCategory(index),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    label: Text(controller.selectedMethods[index].tr),
                    labelStyle: AppTextStyle.darkBrown14spTextStyle1,
                    deleteIconColor: AppColors.darkBrownColor,
                    side:
                        BorderSide(color: AppColors.darkBrownColor, width: 1.w),
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50.r)),
                  );
                },
              ),
            )),
        Obx(() =>
            controller.isClicked.value && controller.selectedMethods.isEmpty
                ? Padding(
                    padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 8.h),
                    child: Text(
                      "${"notificationMethods".tr} ${"isRequired".tr}",
                      style: TextStyle(
                          color: Get.theme.colorScheme.error, fontSize: 12),
                    ),
                  )
                : const SizedBox.shrink()),
        _categoryWrap(),
      ],
    );
  }

  Widget _categoryWrap() {
    return Obx(() => controller.notificationMethods.isNotEmpty
        ? SizedBox(
            height: 50.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: controller.notificationMethods.length,
              separatorBuilder: (_, int index) => 10.horizontalSpace,
              itemBuilder: (_, int index) {
                return RawChip(
                  onDeleted: () => controller.addCategory(index),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  label: Text(controller.notificationMethods[index].tr),
                  labelStyle: AppTextStyle.white14spTextStyle1,
                  deleteIcon: const Icon(CupertinoIcons.add_circled_solid),
                  deleteIconColor: Colors.white,
                  side: BorderSide(color: AppColors.darkBrownColor, width: 1.w),
                  backgroundColor: themeViewModel.color,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50.r)),
                );
              },
            ),
          )
        : SizedBox.shrink());
  }
}
