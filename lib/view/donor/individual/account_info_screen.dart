import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:zakat_fund/my_app/my_app.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/utils/constants/input_formatters.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/utils/validator.dart';
import 'package:zakat_fund/view_model/individual_view_model.dart';
import 'package:zakat_fund/widgets/additional_doc_widget.dart';
import 'package:zakat_fund/widgets/elevated_button.dart';
import 'package:zakat_fund/widgets/expansion_tile_header.dart';
import 'package:zakat_fund/widgets/label_drop_down2.dart';
import 'package:zakat_fund/widgets/label_text_field.dart';
import 'package:zakat_fund/widgets/picture_instruct_widget.dart';

class AccountInfoScreen extends GetView<IndividualViewModel> {
  const AccountInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: const Offset(0.0, 2.0),
            blurRadius: 100.0,
          ),
        ],
      ),
      child: Form(
        key: controller.accountFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Obx(() => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LabelTextField(
                      controller: controller.emailController,
                      label: 'email',
                      hint: "abc@xyz.com",
                      onChanged: controller.onChangeEmail,
                      isArabicDirection: true,
                      inputFormatters: InputFormatters.denySpaces,
                      readOnly: showChangePasswordBox.isEmpty,
                      showVerify: !controller.isEmailVerified.value,
                      onVerify: () {
                        String value = controller.emailController.text;
                        String? isValidate = Validator.validateEmailId(value: value);
                      },
                    ),
                    if (controller.isEmailVerified.value)...[
                        4.verticalSpace,
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
                      )],
                  ],
                )),
            16.verticalSpace,
            LabelTextField(
              controller: controller.userNameController,
              label: 'userName',
              focusNode: controller.userNameNode,
              isRequired: true,
              readOnly: true,
              checkValidation: true,
            ),
            16.verticalSpace,
            Utils.isArabic ? arabicTextFields() : englishTextFields(),
            16.verticalSpace,
            Utils.isArabic ? englishTextFields() : arabicTextFields(),
            16.verticalSpace,
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: LabelTextField(
                    controller: controller.dobController,
                    readOnly: true,
                    onTap: () => controller.dobPickerDialog(),
                    label: 'dob',
                    isDate: true,
                  ),
                ),
                16.horizontalSpace,
                Obx(() => Expanded(
                      child: IgnorePointer(
                        ignoring: controller.selectedGender.value != null &&
                            controller.user.uuid != null,
                        child: LabelDropDown2(
                          items: controller.genders,
                          focusNode: controller.genderNode,
                          selectedValue: controller.selectedGender.value,
                          isRequired: true,
                          hint: "chooseAnOption",
                          onChanged: (value) => controller.selectedGender.value = value,
                          label: 'gender',
                        ),
                      ),
                    )),
              ],
            ),
            16.verticalSpace,
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(() => Expanded(
                      child: IgnorePointer(
                        ignoring:
                            controller.selectedNationality.value != null &&
                                controller.user.uuid != null,
                        child: LabelDropDown2(
                          items: controller.nationalitiesList.value,
                          isRequired: true,
                          focusNode: controller.nationalityNode,
                          showSearch: true,
                          selectedValue: controller.selectedNationality.value,
                          onChanged: (value) => controller.selectedNationality.value = value,
                          hint: "chooseAnOption",
                          label: 'nationality',
                        ),
                      ),
                    )),
                16.horizontalSpace,
                Expanded(
                  child: LabelTextField(
                    controller: controller.uaeIDController,
                    label: 'uaeId',
                    focusNode: controller.emirateIdNode,
                    readOnly: controller.user.uuid != null,
                    keyboardType: TextInputType.number,
                    isArabicDirection: true,
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
            16.verticalSpace,
            LabelTextField(
              label: 'personalPicture',
              readOnly: true,
              onAddFile: () => controller.addFile(),
              controller: controller.profileImageController,
            ),
            6.verticalSpace,
            pictureInstructWidget(),
            additionalDocuments(),
            25.verticalSpace,
            elevatedButton(
              text: "next",
              onPressed: ()=>controller.navigateToContactInfo(),
            ),
          ],
        ),
      ),
    );
  }

  Row englishTextFields() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: LabelTextField(
            controller: controller.fNameController,
            label: 'firstNameInEnglish',
            focusNode: controller.fNameNode,
            readOnly: controller.user.uuid != null,
            inputFormatters: InputFormatters.englishNameFormatter,
            isRequired: true,
            checkValidation: true,
          ),
        ),
        16.horizontalSpace,
        Expanded(
          child: LabelTextField(
            controller: controller.lNameController,
            label: 'lastNameInEnglish',
            focusNode: controller.lNameNode,
            readOnly: controller.user.uuid != null,
            inputFormatters: InputFormatters.englishNameFormatter,
            isRequired: true,
            checkValidation: true,
          ),
        ),
      ],
    );
  }

  Row arabicTextFields() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: LabelTextField(
            controller: controller.fNameArabicController,
            label: 'firstNameInArabic',
            focusNode: controller.fNameArabicNode,
            isRequired: true,
            checkValidation: true,
            inputFormatters: InputFormatters.arabicNameFormatter,
          ),
        ),
        16.horizontalSpace,
        Expanded(
          child: LabelTextField(
            focusNode: controller.lNameArabicNode,
            controller: controller.lNameArabicController,
            inputFormatters: InputFormatters.arabicNameFormatter,
            label: 'lastNameInArabic',
          ),
        ),
      ],
    );
  }

  Widget additionalDocuments() {
    return Obx(() => controller.additionalDocuments.isNotEmpty?Column(
      children: [
        16.verticalSpace,
        expansionTileHeader(
          title: "additionalDocuments",
          isExpanded: controller.showAdditionalDocuments.value,
          onTap: () => controller.showAdditionalDocuments.toggle(),
        ),
        if (controller.showAdditionalDocuments.value)
          Column(
            children: List.generate(
                controller.additionalDocuments.length,
                    (index) => AdditionalDocWidget(
                  document: controller.additionalDocuments[index],
                )),
          )
      ],
    ):SizedBox.shrink());
  }

}
