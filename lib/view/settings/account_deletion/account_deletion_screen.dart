import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_constant.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/view_model/account_deletion_view_model.dart';
import 'package:zakat_fund/widgets/elevated_button.dart';
import 'package:zakat_fund/widgets/label_drop_down.dart';
import 'package:zakat_fund/widgets/label_text_field.dart';
import 'package:zakat_fund/widgets/my_app_bar.dart';

class AccountDeletionScreen extends GetView<AccountDeletionViewModel> {
  const AccountDeletionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(title: "accountDeletionRequest"),
      backgroundColor: Colors.white,
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return KeyboardDismissOnTap(
      child: KeyboardActions(
        config: Utils.buildConfig(context, controller.keyboardActionsItem),
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: Form(
            key: controller.formKey,
            child: Column(
              children: [
                Text(
                  "accountDeletionMessage".tr,
                  textAlign: TextAlign.center,
                  style: AppTextStyle.primaryDarkGrey16spTextStyle1,
                ),
                16.verticalSpace,
                Obx(() => LabelDropDown(
                      items: AppConstant.accountDeletionReasons,
                      selectedValue: controller.selectedReason.value,
                      isRequired: true,
                      isBackWhite: true,
                      hint: "chooseAnOption",
                      onChanged: (value) => controller.selectedReason.value = value,
                      label: 'reasonForDeletion',
                    )),
                16.verticalSpace,
                Obx(() => LabelTextField(
                      controller: controller.details,
                      label: 'writeDetailedReason',
                      hint: 'writeDetailedReasonHint',
                      isBackWhite: true,
                      focusNode: controller.detailsNode,
                      isBlack: true,
                      maxLines: 4,
                      checkValidation:
                          controller.selectedReason.value == "other",
                      isRequired: controller.selectedReason.value == "other",
                    )),
                16.verticalSpace,
                Obx(() => CheckboxListTile(
                      value: controller.isAgree.value,
                      contentPadding: EdgeInsets.zero,
                      checkboxShape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.r)),
                      onChanged: (val) => controller.isAgree.value = val!,
                      controlAffinity: ListTileControlAffinity.leading,
                      isThreeLine: true,
                      subtitle: Text(""),
                      title: Text(
                        "agreeToDeleteAccount".tr,
                        style: AppTextStyle.secondaryPrimaryBlack14spTextStyle,
                      ),
                    )),
                elevatedButton(
                  text: "requestAccountDelete",
                  onPressed: () => controller.confirmationDialog(),
                ),
                16.verticalSpace,
                elevatedButton(
                  text: "cancel",
                  backgroundColor: AppColors.lightGreyColor,
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
