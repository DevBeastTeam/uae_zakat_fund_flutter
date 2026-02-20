import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:zakat_fund/utils/constants/app_colors.dart';
import 'package:zakat_fund/utils/constants/input_formatters.dart';
import 'package:zakat_fund/utils/enums/button_type.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/widgets/custom_button.dart';
import 'package:zakat_fund/widgets/elevated_icon_button.dart';
import 'package:zakat_fund/widgets/label_drop_down2.dart';
import 'package:zakat_fund/widgets/label_text_field.dart';

class CompanyRepresentativeScreen extends StatelessWidget {
  final dynamic controller;

  const CompanyRepresentativeScreen(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.representativeFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Utils.isArabic ? fNameArabic() : fNameEnglish(),
          16.verticalSpace,
          Utils.isArabic ? lNameArabic() : lNameEnglish(),
          16.verticalSpace,
          Utils.isArabic ? fNameEnglish() : fNameArabic(),
          16.verticalSpace,
          Utils.isArabic ? lNameEnglish() : lNameArabic(),
          16.verticalSpace,
          LabelTextField(
            controller: controller.representativeEmailController,
            label: 'email',
            focusNode: controller.representativeEmailNode,
            isRequired: true,
            hint: "abc@xyz.com",
            keyboardType: TextInputType.emailAddress,
            inputFormatters: InputFormatters.denySpaces,
            checkValidation: true,
          ),
          16.verticalSpace,
          LabelTextField(
            controller: controller.representativePhoneNumberController,
            label: 'phoneNumber',
            hint: "+971xxxxxxxxx",
            keyboardType: TextInputType.number,
            isArabicDirection: true,
            focusNode: controller.representativePhoneNumberNode,
            inputFormatters: [
              MaskTextInputFormatter(
                mask: "+971#########",
                initialText: "+971",
                filter: {"#": RegExp(r'[0-9]')},
              )
            ],
            isRequired: true,
            checkValidation: true,
          ),
          16.verticalSpace,
          Obx(() => LabelDropDown2(
            focusNode: controller.nationalityNode,
                items: controller.nationalitiesList.value,
                showSearch: true,
                selectedValue: controller.selectedNationality.value,
                onChanged: (value) => controller.selectedNationality.value = value,
                label: 'nationality',
                isRequired: true,
                hint: 'chooseAnOption',
              )),
          16.verticalSpace,
          Obx(() => LabelDropDown2(
                items: controller.jobList.value,
            focusNode: controller.jobTitleNode,
                showSearch: true,
                selectedValue: controller.selectedJob.value,
                onChanged: (value) => controller.selectedJob.value = value,
                label: 'jobTitle',
                isRequired: true,
                hint: 'chooseAnOption',
              )),
          16.verticalSpace,
          LabelTextField(
            controller: controller.emirateIdController,
            isRequired: true,
            checkValidation: true,
            label: 'emirateIdNumber',
            isArabicDirection: true,
            focusNode: controller.emirateIdNode,
            keyboardType: TextInputType.number,
            hint: "784-xxxx-xxxxxxx-x",
            inputFormatters: [
              MaskTextInputFormatter(
                  mask: '784-####-#######-#',
                  filter: {"#": RegExp(r'[0-9]')},
                  initialText: "784")
            ],
          ),
          20.verticalSpace,
          elevatedIconButton(
              text: "next",
              onPressed: () => controller.saveCompanyRepresentative()),
          16.verticalSpace,
          elevatedIconButton(
            text: "previous",
            backgroundColor: AppColors.lightGreyColor,
            next: false,
            onPressed: () {
              controller.currentSubTab.value = 1;
              controller.scrollToTop();
            },
          ),
          16.verticalSpace,
          if(controller.showSaveAsDraft)CustomButton(
            buttonType: ButtonType.draft,
            onPressed: () => controller.saveCompanyRepresentative(saveAsDraft:true),
          )
        ],
      ),
    );
  }

  LabelTextField lNameArabic() {
    return LabelTextField(
      controller: controller.lNameInArabicController,
      label: 'lastNameInArabic',
      focusNode: controller.lNameInArabicNode,
      inputFormatters: InputFormatters.arabicNameFormatter,
      isRequired: true,
      checkValidation: true,
    );
  }

  LabelTextField fNameArabic() {
    return LabelTextField(
      controller: controller.fNameInArabicController,
      label: 'firstNameInArabic',
      focusNode: controller.fNameInArabicNode,
      isRequired: true,
      inputFormatters: InputFormatters.arabicNameFormatter,
      checkValidation: true,
    );
  }

  LabelTextField lNameEnglish() {
    return LabelTextField(
      controller: controller.lNameInEnglishController,
      label: 'lastNameInEnglish',
      focusNode: controller.lNameInEnglishNode,
      inputFormatters: InputFormatters.englishNameFormatter,
      isRequired: true,
      checkValidation: true,
    );
  }

  LabelTextField fNameEnglish() {
    return LabelTextField(
      controller: controller.fNameInEnglishController,
      label: 'firstNameInEnglish',
      focusNode: controller.fNameInEnglishNode,
      isRequired: true,
      checkValidation: true,
      inputFormatters: InputFormatters.englishNameFormatter,
    );
  }
}
