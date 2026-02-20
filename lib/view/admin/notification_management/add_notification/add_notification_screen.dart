import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/utils/constants/input_formatters.dart';
import 'package:zakat_fund/utils/enums/button_type.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/view_model/add_notification_view_model.dart';
import 'package:zakat_fund/widgets/activity_log_btn.dart';
import 'package:zakat_fund/widgets/custom_button.dart';
import 'package:zakat_fund/widgets/icon_drop_down.dart';
import 'package:zakat_fund/widgets/label_text_field.dart';
import 'package:zakat_fund/widgets/my_app_bar.dart';
import 'package:zakat_fund/widgets/picture_instruct_widget.dart';

class AddNotificationScreen extends GetView<AddNotificationViewModel> {
  const AddNotificationScreen({super.key});

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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 16.h),
                  child: activityLogBtn(
                      model: controller.notification,
                      status: controller.notification?.requestStatus,
                      id: controller.notification?.id,
                      type: "CMSNotifications"),
                ),
                _buildRecipients(),
                16.verticalSpace,
                LabelTextField(
                  controller: controller.titleInEnglish,
                  label: 'titleInEnglish',
                  isRequired: true,
                  focusNode: controller.titleInEnglishNode,
                  checkValidation: true,
                  inputFormatters: InputFormatters.englishNameFormatter,
                ),
                16.verticalSpace,
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
                  label: 'image',
                  readOnly: true,
                  onAddFile: () => controller.addImage(),
                  controller: controller.imageController,
                ),
                4.verticalSpace,
                pictureInstructWidget(),
                16.verticalSpace,
                Obx(() => IconDropDown(
                      items: controller.icons,
                      isRequired: true,
                      selectedValue: controller.selectedIcon.value,
                      hint: "chooseAnOption",
                      onChanged: (value) => controller.onChangeIcon(value!),
                      label: 'icon',
                    )),
                16.verticalSpace,
                LabelTextField(
                  controller: controller.publishDateTime,
                  label: 'publishScheduleTime',
                  isRequired: true,
                  checkValidation: true,
                  isDate: true,
                  readOnly: true,
                  onTap: () => controller.dateTimePicker(),
                ),
                16.verticalSpace,
                LabelTextField(
                  controller: controller.descInEnglish,
                  label: 'descriptionInEnglish',
                  isRequired: true,
                  maxLines: 4,
                  focusNode: controller.descInEnglishNode,
                  checkValidation: true,
                  inputFormatters: InputFormatters.englishAddressFormatter,
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
                16.verticalSpace,
                CustomButton(
                  buttonType: ButtonType.submit,
                  onPressed: () => controller.saveNotification(),
                ),
                10.verticalSpace,
                CustomButton(
                  buttonType: ButtonType.preview,
                  onPressed: () => controller.saveNotification(isPreview: true),
                ),
                10.verticalSpace,
                if (controller.notification == null ||
                    controller.notification?.requestStatus == 8)
                  Padding(
                    padding: EdgeInsets.only(bottom: 10.h),
                    child: CustomButton(
                      buttonType: ButtonType.draft,
                      onPressed: () =>
                          controller.saveNotification(saveAsDraft: true),
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

  Column _buildRecipients() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
              border: Border.all(
                  width: 1.w, color: AppColors.secondaryLightGreyColor),
              borderRadius: BorderRadius.circular(8.r)),
          child: Obx(() => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                    child: Text(
                      "recipients".tr,
                      style: AppTextStyle.secondaryBlack16spTextStyle3,
                    ),
                  ),
                  ..._buildRecipientsList(),
                  10.verticalSpace,
                ],
              )),
        ),
        emptyError(),
      ],
    );
  }

  Iterable<Widget> _buildRecipientsList() {
    return controller.recipients.map((data) => CheckboxListTile(
          value: data.isOpen,
          checkboxShape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.r)),
          contentPadding: EdgeInsets.only(
            left: Utils.isArabic ? 16.w : 8.w,
            right: Utils.isArabic ? 8.w : 16.w,
          ),
          onChanged: (val) => controller.onChangeRecipients(val!, data),
          controlAffinity: ListTileControlAffinity.leading,
          title: Container(
            decoration: BoxDecoration(
                color: AppColors.grayColor,
                border: Border.all(
                    width: 1.w, color: AppColors.secondaryLightGreyColor),
                borderRadius: BorderRadius.circular(10.r)),
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
            child: Row(
              children: [
                SvgPicture.asset(data.icon!),
                10.horizontalSpace,
                Text(
                  data.name.tr,
                  style: AppTextStyle.secondaryPrimaryBlack14spTextStyle,
                ),
              ],
            ),
          ),
        ));
  }

  Widget emptyError() {
    return Obx(() => controller.selectedRecipients.isEmpty
        ? Padding(
            padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 4.h),
            child: Text(
              "${"pleaseSelect".tr} ${"recipients".tr}",
              style: TextStyle(
                color: Get.theme.colorScheme.error,
                fontSize: 12.0,
              ),
            ),
          )
        : SizedBox.shrink());
  }
}
