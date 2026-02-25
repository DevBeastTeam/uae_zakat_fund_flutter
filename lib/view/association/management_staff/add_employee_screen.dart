import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:zakat_fund/model/management_staff.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/utils/constants/input_formatters.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/utils/validator.dart';
import 'package:zakat_fund/view_model/add_emp_view_model.dart';
import 'package:zakat_fund/widgets/elevated_button.dart';
import 'package:zakat_fund/widgets/label_drop_down.dart';
import 'package:zakat_fund/widgets/label_drop_down2.dart';
import 'package:zakat_fund/widgets/label_text_field.dart';

class AddEmployeeScreen extends StatelessWidget {
  final ManagementStaff? emp;

  const AddEmployeeScreen(this.emp, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: _buildBody(context),
    );
  }

  KeyboardDismissOnTap _buildBody(BuildContext context) {
    final viewModel = Get.put(AddEmpViewModel(emp));
    return KeyboardDismissOnTap(
      child: KeyboardActions(
        config: Utils.buildConfig(context, viewModel.keyboardActionsItem),
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: Form(
              key: viewModel.formKey,
              child: Column(
                children: [
                  Utils.isArabic ? arabicName(viewModel) : englishName(viewModel),
                  16.verticalSpace,
                  Utils.isArabic ? englishName(viewModel) : arabicName(viewModel),
                  16.verticalSpace,
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          LabelTextField(
                            controller: viewModel.emailController,
                            label: 'email',
                            focusNode: viewModel.emailNode,
                            isRequired: true,
                            isArabicDirection: true,
                            checkValidation: true,
                            hint: "abc@xyz.com",
                            validator: (value) {
                              return Validator.validateEmailId(value: value!);
                            },
                            readOnly: emp != null && emp!.emailConfirmed,
                            inputFormatters: InputFormatters.denySpaces,
                          ),
                          if (emp != null && emp!.emailConfirmed)
                            4.verticalSpace,
                          if (emp != null && emp!.emailConfirmed)
                            Row(
                              children: [
                                const Icon(
                                  CupertinoIcons.check_mark_circled_solid,
                                  color: AppColors.greenColor,
                                ),
                                8.horizontalSpace,
                                Text(
                                  "emailVerified".tr,
                                  style: AppTextStyle.green14spTextStyle,
                                ),
                              ],
                            ),
                        ],
                      )),
                      16.horizontalSpace,
                      Expanded(
                        child: Column(
                          children: [
                            LabelTextField(
                                isRequired: true,
                                checkValidation: true,
                                isArabicDirection: true,
                                focusNode: viewModel.phoneNumberNode,
                                readOnly:
                                    emp != null && emp!.phoneNumberConfirmed,
                                hint: "+971xxxxxxxxx",
                                validator: (value) {
                                  return Validator.validatePhoneNumber(value!);
                                },
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  MaskTextInputFormatter(
                                    mask: "+971#########",
                                    initialText: "+971",
                                    filter: {"#": RegExp(r'[0-9]')},
                                  )
                                ],
                                controller: viewModel.phoneNumberController,
                                label: 'phoneNumber'),
                            if (emp != null && emp!.phoneNumberConfirmed)
                              4.verticalSpace,
                            if (emp != null && emp!.phoneNumberConfirmed)
                              Row(
                                children: [
                                  const Icon(
                                    CupertinoIcons.check_mark_circled_solid,
                                    color: AppColors.greenColor,
                                  ),
                                  8.horizontalSpace,
                                  Flexible(
                                    child: Text(
                                      "mobileVerified".tr,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: AppTextStyle.green14spTextStyle,
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  16.verticalSpace,
                  Obx(() => LabelDropDown2(
                        items: viewModel.staffViewModel.jobList.value,
                        isRequired: true,
                        showSearch: true,
                        selectedValue: viewModel.selectedJob.value,
                        onChanged: (value) {
                          viewModel.selectedJob.value = value;
                        },
                        hint: "chooseAnOption",
                        label: 'jobTitle',
                      )),
                  16.verticalSpace,
                  Obx(() => LabelDropDown2(
                    items: viewModel.staffViewModel.sahemRolesList.value,
                    isRequired: true,
                    selectedValue: viewModel.selectedRole.value,
                    onChanged: (value) {
                      viewModel.selectedRole.value = value;
                    },
                    hint: "chooseAnOption",
                    label: 'role',
                  )),
                  16.verticalSpace,
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(() => Expanded(
                            child: LabelDropDown(
                              items: viewModel.accountViewModel.nationalities,
                              isRequired: true,
                              showSearch: true,
                              selectedValue:
                                  viewModel.selectedNationality.value,
                              onChanged: (value) {
                                viewModel.selectedNationality.value = value;
                              },
                              hint: "chooseAnOption",
                              label: 'nationality',
                            ),
                          )),
                      16.horizontalSpace,
                      Expanded(
                        child: LabelTextField(
                          controller: viewModel.emirateIdController,
                          isRequired: true,
                          checkValidation: true,
                          label: 'emirateIdNumber',
                          focusNode: viewModel.emirateIdNode,
                          isArabicDirection: true,
                          keyboardType: TextInputType.number,
                          hint: "784-xxxx-xxxxxxx-x",
                          inputFormatters: [
                            MaskTextInputFormatter(
                                mask: '784-####-#######-#',
                                filter: {"#": RegExp(r'[0-9]')},
                                initialText: "784")
                          ],
                        ),
                      ),
                    ],
                  ),
                  20.verticalSpace,
                  elevatedButton(
                    text: emp != null ? "update" : "add",
                    onPressed: () => viewModel.addUpdateEmployee(emp),
                  ),
                  16.verticalSpace,
                  elevatedButton(
                      text: "cancel",
                      onPressed: () => Get.back(),
                      backgroundColor: AppColors.lightGreyColor)
                ],
              )),
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      scrolledUnderElevation: 0,
      elevation: 0,
      centerTitle: true,
      title: Text(
        emp != null ? "editEmployee".tr : "addEmployee".tr,
        style: AppTextStyle.secondaryPrimaryBlack20spTextStyle,
      ),
      actions: [
        GestureDetector(
            onTap: () => Get.back(),
            child: const Icon(
              Icons.highlight_remove_outlined,
              color: AppColors.secondaryPrimaryBlackColor,
            )),
        16.horizontalSpace,
      ],
      automaticallyImplyLeading: false,
    );
  }

  Column arabicName(AddEmpViewModel viewModel) {
    return Column(
      children: [
        LabelTextField(
          controller: viewModel.fNameArabicController,
          label: 'firstNameInArabic',
          isRequired: true,
          focusNode: viewModel.fNameArabicNode,
          checkValidation: true,
          inputFormatters: InputFormatters.arabicNameFormatter,
        ),
        16.verticalSpace,
        LabelTextField(
          isRequired: true,
          focusNode: viewModel.lNameArabicNode,
          checkValidation: true,
          controller: viewModel.lNameArabicController,
          inputFormatters: InputFormatters.arabicNameFormatter,
          label: 'lastNameInArabic',
        ),
      ],
    );
  }

  Column englishName(AddEmpViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LabelTextField(
          controller: viewModel.fNameController,
          label: 'firstNameInEnglish',
          focusNode: viewModel.fNameNode,
          inputFormatters: InputFormatters.englishNameFormatter,
          isRequired: true,
          checkValidation: true,
        ),
        16.verticalSpace,
        LabelTextField(
          controller: viewModel.lNameController,
          label: 'lastNameInEnglish',
          focusNode: viewModel.lNameNode,
          inputFormatters: InputFormatters.englishNameFormatter,
          isRequired: true,
          checkValidation: true,
        ),
      ],
    );
  }
}
