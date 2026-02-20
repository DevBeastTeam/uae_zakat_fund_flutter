import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_constant.dart';
import 'package:zakat_fund/utils/constants/app_resources.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/utils/constants/input_formatters.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/utils/validator.dart';
import 'package:zakat_fund/view_model/add_feedback_view_model.dart';
import 'package:zakat_fund/widgets/elevated_button.dart';
import 'package:zakat_fund/widgets/label_drop_down.dart';
import 'package:zakat_fund/widgets/label_text_field.dart';
import 'package:zakat_fund/widgets/my_app_bar.dart';

class AddFeedbackScreen extends GetView<AddFeedbackViewModel> {
  const AddFeedbackScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: myAppBar(title: "addFeedback".tr),
      body: _buildBody(context),
    );
  }

  KeyboardDismissOnTap _buildBody(BuildContext context) {
    return KeyboardDismissOnTap(
      child: KeyboardActions(
        config: Utils.buildConfig(context, controller.keyboardActionsItem),
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [_buildTitle(), 16.verticalSpace, _buildFormContainer()],
          ),
        ),
      ),
    );
  }

  Widget _buildFormContainer() {
    return Form(
      key: controller.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LabelTextField(
            controller: controller.nameController,
            label: 'name',
            isBlack: true,
            hint: "name",
            feedback: true,
            isBackWhite: true,
            keyboardType: TextInputType.name,
            readOnly: controller.nameController.text.isNotEmpty,
            checkValidation: true,
            isRequired: true,
            prefixIcon: AppResources.personIcon1,
          ),
          16.verticalSpace,
          LabelTextField(
            controller: controller.emailController,
            label: 'email',
            keyboardType: TextInputType.emailAddress,
            readOnly: controller.emailController.text.isNotEmpty,
            feedback: true,
            hint: "emailAddress",
            validator: (value) => Validator.validateEmailId(value: value!),
            isBlack: true,
            inputFormatters: InputFormatters.denySpaces,
            checkValidation: true,
            isRequired: true,
            isBackWhite: true,
            prefixIcon: AppResources.emailUnFillIcon,
          ),
          16.verticalSpace,
          Obx(() =>
              LabelDropDown(
                items: AppConstant.feedbackTypes,
                selectedValue: controller.selectedType.value,
                hint: "chooseAnOption",
                isRequired: true,
                isBackWhite: true,
                onChanged: (value) => controller.onChangeFeedbackType(value!),
                label: 'feedbackType',
              )),
          16.verticalSpace,
          LabelTextField(
            controller: controller.detailsController,
            label: 'details',
            isBlack: true,
            maxLines: 4,
            focusNode: controller.detailsNode,
            feedback: true,
            checkValidation: true,
            isRequired: true,
            isBackWhite: true,
            hint: "enterDetails",
          ),
          16.verticalSpace,
          LabelTextField(
            label: 'attachment',
            readOnly: true,
            onAddFile: () => controller.addFile(),
            controller: controller.attachmentController,
          ),
          Obx(() =>
              CheckboxListTile(
                value: controller.isSelected.value,
                contentPadding: EdgeInsets.zero,
                onChanged: (val) {
                  controller.isSelected.value = val!;
                },
                controlAffinity: ListTileControlAffinity.leading,
                title: Text(
                  "acceptPrivacyPolicy".tr,
                  style: AppTextStyle.secondaryPrimaryBlack16spTextStyle3,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              )),
          16.verticalSpace,
          elevatedButton(
              text: "submitFeedBack".tr,
              onPressed: () => controller.submitFeedback()),
          16.verticalSpace,
        ],
      ),
    );
  }

  Text _buildTitle() {
    return Text(
      "fillFeedbackForm".tr,
      style: AppTextStyle.black24spTextStyle.copyWith(height: 0),
    );
  }

  Row _buildHeader() {
    return Row(
      children: [
        Container(
          color: AppColors.darkBrownColor,
          height: 2.h,
          width: 22.w,
        ),
        13.horizontalSpace,
      ],
    );
  }
}
