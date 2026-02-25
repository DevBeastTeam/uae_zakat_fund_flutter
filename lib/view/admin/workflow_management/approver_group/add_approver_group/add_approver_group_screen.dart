import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/input_formatters.dart';
import 'package:zakat_fund/utils/enums/button_type.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/view_model/add_approver_group_view_model.dart';
import 'package:zakat_fund/widgets/custom_button.dart';
import 'package:zakat_fund/widgets/elevated_button.dart';
import 'package:zakat_fund/widgets/label_text_field.dart';
import 'package:zakat_fund/widgets/my_app_bar.dart';

class AddApproverGroupScreen extends GetView<AddApproverGroupViewModel> {
  const AddApproverGroupScreen({super.key});

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
              LabelTextField(
                controller: controller.nameInEnglishController,
                label: 'groupNameInEnglish',
                isRequired: true,
                checkValidation: true,
                inputFormatters: InputFormatters.englishNameFormatter,
              ),
              16.verticalSpace,
              LabelTextField(
                controller: controller.nameInArabicController,
                label: 'groupNameInArabic',
                isRequired: true,
                checkValidation: true,
                inputFormatters: InputFormatters.arabicNameFormatter,
              ),
              16.verticalSpace,
              LabelTextField(
                controller: controller.descriptionController,
                label: 'groupDescription',
                isRequired: true,
                focusNode: controller.descNode,
                maxLines: 4,
                checkValidation: true,
              ),
              _buildListView(),
              elevatedButton(
                text: controller.group != null ? "update" : "createGroup",
                onPressed: () => controller.addGroup(),
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
    ));
  }

  Container _buildListView() {
    return Container(
              height: 200.h,
              margin: EdgeInsets.symmetric(vertical: 20.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(
                  color: AppColors.secondaryLightGreyColor,
                  width: 1.w,
                ),
              ),
              child: Scrollbar(
                thumbVisibility: true,
                thickness: 10.0,
                controller: controller.scrollController,
                radius: Radius.circular(100.r),
                child: Obx(() => ListView.builder(
                      controller: controller.scrollController,
                      itemCount: controller.employees.length,
                      itemBuilder: (context, index) {
                        final employee = controller.employees[index];
                        String firstName = Utils.isArabic
                            ? employee.firstNameArabic
                            : employee.firstName;
                        String lastName = Utils.isArabic
                            ? employee.lastNameArabic
                            : employee.lastName;
                        return CheckboxListTile(
                          value: employee.selected,
                          controlAffinity: ListTileControlAffinity.leading,
                          onChanged: (_) =>
                              controller.toggleSelection(employee),
                          title: Text(
                            "$firstName $lastName",
                            style: TextStyle(color: Colors.black54),
                          ),
                          checkColor: Colors.white,
                          visualDensity: VisualDensity.compact,
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          side: BorderSide(color: AppColors.darkGreyColor),
                          activeColor: AppColors.lightBrownColor,
                          checkboxShape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.r)),
                        );
                      },
                    )),
              ),
            );
  }
}
