import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:zakat_fund/model/workflows.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_constant.dart';
import 'package:zakat_fund/utils/constants/app_resources.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/utils/constants/input_formatters.dart';
import 'package:zakat_fund/utils/enums/button_type.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/view_model/add_workflow_view_model.dart';
import 'package:zakat_fund/widgets/custom_button.dart';
import 'package:zakat_fund/widgets/elevated_button.dart';
import 'package:zakat_fund/widgets/label_drop_down.dart';
import 'package:zakat_fund/widgets/label_text_field.dart';
import 'package:zakat_fund/widgets/my_app_bar.dart';

class AddWorkflowScreen extends GetView<AddWorkflowViewModel> {
  const AddWorkflowScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: myAppBar(title: controller.isView?"details":"addNewWorkflow"),
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
              LabelTextField(
                controller: controller.nameInEnglishController,
                label: 'workflowNameInEnglish',
                isRequired: true,
                readOnly: controller.isView,
                checkValidation: true,
                inputFormatters: InputFormatters.englishNameFormatter,
              ),
              16.verticalSpace,
              LabelTextField(
                controller: controller.nameInArabicController,
                label: 'workflowNameInArabic',
                isRequired: true,
                readOnly: controller.isView,
                checkValidation: true,
                inputFormatters: InputFormatters.arabicNameFormatter,
              ),
              16.verticalSpace,
              Obx(() => IgnorePointer(
                ignoring: controller.isView,
                child: LabelDropDown(
                      items: AppConstant.workflowTypes,
                      selectedValue: controller.selectedType.value,
                      isRequired: true,
                      hint: "chooseAnOption",
                      onChanged: (value) => controller.selectedType.value = value,
                      label: 'requestType',
                    ),
              )),
              16.verticalSpace,
              LabelTextField(
                controller: controller.descriptionController,
                label: 'workflowDescription',
                isRequired: true,
                readOnly: controller.isView,
                focusNode: controller.descriptionNode,
                maxLines: 3,
                checkValidation: true,
              ),
              16.verticalSpace,
              Text(
                "approvalLevels".tr,
                style: AppTextStyle.secondaryBlack16spTextStyle3,
              ),
              buildLevelsItem(),
              if(!controller.isView)16.verticalSpace,
              if(!controller.isView)ElevatedButton.icon(
                style: OutlinedButton.styleFrom(
                  backgroundColor: AppColors.mediumBackColor.withOpacity(0.10),
                  elevation: 0,
                  minimumSize: Size(Get.width, 45.h),
                ),
                onPressed: () => controller.addNewLevel(),
                label: Text(
                  "addApprovalLevel".tr,
                  maxLines: 1,
                  style: AppTextStyle.lightBrownColor16spTextStyle2,
                ),
                icon: SvgPicture.asset(
                  AppResources.addIcon,
                  color: AppColors.lightBrownColor2,
                ),
              ),
              if(!controller.isView)16.verticalSpace,
              if(!controller.isView)elevatedButton(text: controller.workflow!=null?"update":"save", onPressed: ()=>controller.addWorkflow()),
              16.verticalSpace,
              CustomButton(
                  buttonType: ButtonType.cancel, onPressed: () => Get.back())
            ],
          ),
                  ),
                ),
        ));
  }

  Widget buildLevelsItem() {
    return Obx(() => Column(
            children: List.generate(controller.levels.length, (index) {
          NewWorkflowLevel level = controller.levels[index];
          return KeyboardActions(
            autoScroll: false,
            config: Utils.buildConfig(Get.context!, controller.isView?[]:level.subKeyboardActionsItem),
            child: Column(
              children: [
                16.verticalSpace,
                LabelTextField(
                  controller: level.levelNameInEnglishController,
                  label: '${"level".tr} ${index+1} ${"name".tr} (${"english".tr})',
                  isRequired: true,
                  checkValidation: true,
                  readOnly: controller.isView,
                  // inputFormatters: InputFormatters.englishNameFormatter,
                ),
                16.verticalSpace,
                LabelTextField(
                  controller: level.levelNameInArabicController,
                  label: '${"level".tr} ${index+1} ${"name".tr} (${"arabic".tr})',
                  isRequired: true,
                  readOnly: controller.isView,
                  checkValidation: true,
                  // inputFormatters: InputFormatters.arabicNameFormatter,
                ),
                16.verticalSpace,
                Obx(() => IgnorePointer(
                  ignoring: controller.isView,
                  child: LabelDropDown(
                        items: controller.allGroups.value,
                        selectedValue: level.selectedGroup.value,
                        hint: "chooseAnOption",
                    isRequired: true,
                        onChanged: (value)=>controller.onChangeApproverGroup(value!,level),
                        label: 'approverGroup',
                      ),
                )),
                16.verticalSpace,
                LabelTextField(
                  controller: level.levelDescriptionController,
                  label: '${"level".tr} ${index+1} ${"description".tr}',
                  isRequired: true,
                  focusNode: level.levelDescriptionNode,
                  maxLines: 3,
                  readOnly: controller.isView,
                  checkValidation: true,
                ),
                16.verticalSpace,
                LabelTextField(
                  controller: level.slaHoursController,
                  label: 'slaInHours',
                  readOnly: controller.isView,
                  focusNode: level.slaHoursNode,
                  isRequired: true,
                  keyboardType: TextInputType.number,
                  checkValidation: true,
                  inputFormatters: InputFormatters.amountFormatter,
                ),
                if (controller.levels.length != 1) 16.verticalSpace,
                if (controller.levels.length != 1)
                  ElevatedButton.icon(
                    style: OutlinedButton.styleFrom(
                      backgroundColor: AppColors.highBackColor.withOpacity(0.10),
                      elevation: 0,
                      minimumSize: Size(Get.width, 45.h),
                    ),
                    onPressed: () => controller.levels.removeAt(index),
                    label: Text(
                      "deleteCriteria".tr,
                      maxLines: 1,
                      style: AppTextStyle.highBack16spTextStyle1,
                    ),
                    icon: SvgPicture.asset(
                      AppResources.removeIcon,
                    ),
                  ),
              ],
            ),
          );
        })));
  }
}
