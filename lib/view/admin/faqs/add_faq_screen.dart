import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:zakat_fund/utils/constants/input_formatters.dart';
import 'package:zakat_fund/utils/enums/button_type.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/view_model/cms_faq_view_model.dart';
import 'package:zakat_fund/widgets/activity_log_btn.dart';
import 'package:zakat_fund/widgets/custom_button.dart';
import 'package:zakat_fund/widgets/label_drop_down.dart';
import 'package:zakat_fund/widgets/label_text_field.dart';
import 'package:zakat_fund/widgets/my_app_bar.dart';

class AddFaqScreen extends GetView<CMSFaqViewModel> {
  const AddFaqScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var data = Get.arguments;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: myAppBar(title: data ? "editFAQ" : "addNewFAQ"),
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
                activityLogBtn(model: controller.preFAQ,status: controller.preFAQ?.requestStatus,id:controller.preFAQ?.id,type: "FAQ"),
                LabelTextField(
                  controller: controller.titleInEnglishController,
                  label: "titleInEnglish",
                  checkValidation: true,
                  isRequired: true,
                  focusNode: controller.titleInEnglishNode,
                  isArabicDirection: Utils.isArabic,
                  inputFormatters: InputFormatters.englishNameFormatter,
                ),
                16.verticalSpace,
                LabelTextField(
                  controller: controller.titleInArabicController,
                  label: "titleInArabic",
                  checkValidation: true,
                  focusNode: controller.titleInArabicNode,
                  inputFormatters: InputFormatters.arabicNameFormatter,
                  isRequired: true,
                ),
                16.verticalSpace,
                Obx(() => LabelDropDown(
                      items: Utils.isArabic
                          ? controller.arabicCats
                          : controller.englishCats,
                      selectedValue: controller.selectedCategory.value,
                      isRequired: true,
                      hint: "chooseAnOption",
                      onChanged: (value) {
                        controller.selectedCategory.value = value;
                      },
                      label: 'category',
                    )),
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
                  controller: controller.answerInEnglishController,
                  label: "answer",
                  checkValidation: true,
                  isRequired: true,
                  maxLines: 5,
                  focusNode: controller.answerInEnglishNode,
                  inputFormatters: InputFormatters.englishAddressFormatter,
                ),
                16.verticalSpace,
                LabelTextField(
                  controller: controller.answerInArabicController,
                  label: "answerArabic",
                  focusNode: controller.answerInArabicNode,
                  checkValidation: true,
                  inputFormatters: InputFormatters.arabicAddressFormatter,
                  isRequired: true,
                  maxLines: 5,
                ),
                20.verticalSpace,
                CustomButton(
                  onPressed: () => controller.addFAQ(update: Get.arguments),
                  buttonType: ButtonType.submit,
                ),
                10.verticalSpace,
                CustomButton(
                    buttonType: ButtonType.preview,
                    onPressed: ()=>controller.showPreview()),
                10.verticalSpace,
                if (controller.preFAQ == null || controller.preFAQ?.requestStatus == 8)
                  Padding(
                    padding: EdgeInsets.only(bottom: 10.h),
                    child: CustomButton(
                      buttonType: ButtonType.draft,
                      onPressed: () => controller.addFAQ(update: Get.arguments,saveAsDraft: true),
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
      ),
    );
  }

}
