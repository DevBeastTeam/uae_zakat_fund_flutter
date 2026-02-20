import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/model/criteria.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_constant.dart';
import 'package:zakat_fund/utils/constants/app_resources.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/view_model/add_group_view_model.dart';
import 'package:zakat_fund/widgets/elevated_button.dart';
import 'package:zakat_fund/widgets/label_drop_down.dart';
import 'package:zakat_fund/widgets/label_text_field.dart';
import 'package:zakat_fund/widgets/my_app_bar.dart';

class AddGroupScreen extends GetView<AddGroupViewModel> {
  const AddGroupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: myAppBar(title: controller.getTitle()),
      body: _buildBody(),
    );
  }

  KeyboardDismissOnTap _buildBody() {
    return KeyboardDismissOnTap(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Form(
          key: controller.formKey,
          child: Column(
            children: [
              LabelTextField(
                controller: controller.groupName,
                label: "groupName",
                checkValidation: true,
                isRequired: true,
              ),
              16.verticalSpace,
              Obx(() => LabelDropDown(
                    items: controller.groupTypes,
                    selectedValue: controller.selectedGroupType.value,
                    hint: "chooseAnOption",
                    onChanged: (value)=>controller.onChangeGroupType(value!),
                isRequired: true,
                    label: 'groupType',
                  )),
              16.verticalSpace,
              buildCriteria(),
              ElevatedButton.icon(
                style: OutlinedButton.styleFrom(
                  backgroundColor: AppColors.mediumBackColor.withOpacity(0.10),
                  elevation: 0,
                  minimumSize: Size(Get.width, 45.h),
                ),
                onPressed: () => controller.addCriteria(),
                label: Text(
                  "addCriteria".tr,
                  maxLines: 1,
                  style: AppTextStyle.lightBrownColor16spTextStyle2,
                ),
                icon: SvgPicture.asset(
                  AppResources.addIcon,
                  color: AppColors.lightBrownColor2,
                ),
              ),
              _buildBottomActions()
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCriteria() {
    return Obx(() => Column(
          children: List.generate(controller.criteria.length, (index) {
            Criteria criteria = controller.criteria[index];
            return Column(
              children: [
                Obx(() => LabelDropDown(
                      items: AppConstant.recipientsUserTypes,
                      selectedValue: criteria.selectedUserType.value,
                      hint: "chooseAnOption",
                      onChanged: (value)=>controller.onChangeUserType(value!,criteria,index),
                      label: 'userType',
                    )),
                16.verticalSpace,
                Obx(() => LabelDropDown(
                      items: criteria.ranges.value,
                      selectedValue: criteria.selectedRange.value,
                      hint: "chooseAnOption",
                      onChanged: (value)=>controller.onChangeGroupRange(value!, criteria),
                      label: 'range',
                    )),
                16.verticalSpace,
                Obx(() => LabelDropDown(
                      items: AppConstant.operations,
                      selectedValue: criteria.selectedOperation.value,
                      hint: "chooseAnOption",
                      showSearch: true,
                      onChanged: (value) => criteria.selectedOperation.value = value!,
                      label: 'operation',
                    )),
                16.verticalSpace,
                Obx(() => criteria.selectedRange.value == null
                    ? SizedBox.shrink()
                    : controller.isDropDown(criteria)
                        ? LabelDropDown(
                            items: criteria.dropDownValues.value,
                            isRequired: true,
                            selectedValue: criteria.selectedDropDownValue.value,
                            hint: "chooseAnOption",
                            onChanged: (value) => criteria.selectedDropDownValue.value = value,
                            showLabel: false,
                            label: criteria.selectedRange.value.toString(),
                          )
                        : LabelTextField(
                            controller: criteria.controller,
                            label: "date",
                            isDate: true,
                            isRequired: true,
                            checkValidation: true,
                            showLabel: false,
                            readOnly: true,
                            onTap: () => controller
                                .datePickerDialog(criteria.controller),
                          )),
                16.verticalSpace,
                Obx(() => LabelDropDown(
                      items: AppConstant.logicalOperations,
                      selectedValue: criteria.selectedLogicalOperation.value,
                      hint: "chooseAnOption",
                      onChanged: (value) => criteria.selectedLogicalOperation.value = value!,
                      label: 'operation',
                      showLabel: false,
                    )),
                16.verticalSpace,
                if (controller.criteria.length != 1)
                  ElevatedButton.icon(
                    style: OutlinedButton.styleFrom(
                      backgroundColor:
                          AppColors.highBackColor.withOpacity(0.10),
                      elevation: 0,
                      minimumSize: Size(Get.width, 45.h),
                    ),
                    onPressed: () => controller.deleteCriteria(index),
                    label: Text(
                      "deleteCriteria".tr,
                      maxLines: 1,
                      style: AppTextStyle.highBack16spTextStyle1,
                    ),
                    icon: SvgPicture.asset(
                      AppResources.removeIcon,
                    ),
                  ),
                if (controller.criteria.length != 1) 13.verticalSpace,
              ],
            );
          }),
        ));
  }

  Widget _buildBottomActions() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          elevatedButton(
            text: controller.recipients!=null?"update":"createGroup",
            onPressed: () => controller.saveGroup(),
          ),
          8.verticalSpace,
          elevatedButton(
              text: "cancel",
              onPressed: () => Get.back(),
              backgroundColor: AppColors.lightGreyColor),
        ],
      ),
    );
  }

}
