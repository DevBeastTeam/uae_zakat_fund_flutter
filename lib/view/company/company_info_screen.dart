import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/utils/constants/input_formatters.dart';
import 'package:zakat_fund/utils/enums/button_type.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/view_model/company_view_model.dart';
import 'package:zakat_fund/widgets/additional_doc_widget.dart';
import 'package:zakat_fund/widgets/custom_button.dart';
import 'package:zakat_fund/widgets/elevated_icon_button.dart';
import 'package:zakat_fund/widgets/expansion_tile_header.dart';
import 'package:zakat_fund/widgets/label_drop_down2.dart';
import 'package:zakat_fund/widgets/label_text_field.dart';
import 'package:zakat_fund/widgets/picture_instruct_widget.dart';

class CompanyInfoScreen extends GetView<CompanyViewModel> {
  const CompanyInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.companyInfoFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Utils.isArabic ? nameInArabic() : nameInEnglish(),
          16.verticalSpace,
          Utils.isArabic ? nameInEnglish() : nameInArabic(),
          16.verticalSpace,
          Obx(() => LabelDropDown2(
                focusNode: controller.companyFieldNode,
                items: controller.companyFieldList.value,
                selectedValue: controller.selectedCompanyField.value,
                isRequired: true,
                onChanged: (value) => controller.selectedCompanyField.value = value,
                label: 'companyType',
                hint: 'chooseAnOption',
              )),
          16.verticalSpace,
          LabelTextField(
            focusNode: controller.dateOfEstablishmentNode,
            controller: controller.dateOfEstablishmentController,
            readOnly: true,
            isRequired: true,
            checkValidation: true,
            onTap: () => controller.datePickerDialog(),
            label: 'dateOfEstablishment',
            isDate: true,
          ),
          16.verticalSpace,
          LabelTextField(
            label: 'companyLogo',
            focusNode: controller.companyLogoNode,
            isRequired: true,
            checkValidation: true,
            readOnly: true,
            onAddFile: () => controller.addLogo(),
            controller: controller.companyLogoController,
          ),
          6.verticalSpace,
          pictureInstructWidget(),
          16.verticalSpace,
          LabelTextField(
            label: 'companyLicense',
            isRequired: true,
            focusNode: controller.companyLicenseNode,
            checkValidation: true,
            readOnly: true,
            onAddFile: () => controller.addFile(license: true),
            controller: controller.companyLicenseController,
          ),
          6.verticalSpace,
          fileInstructWidget(),
          16.verticalSpace,
          Obx(() => LabelDropDown2(
                items: controller.issuingAuthorityList.value,
            focusNode: controller.companyIssuingAuthorityNode,
                selectedValue: controller.selectedIssuingAuthority.value,
                onChanged: (value) => controller.selectedIssuingAuthority.value = value!,
                isRequired: true,
                hint: "selectAuthority",
                label: 'issuingAuthority',
              )),
          16.verticalSpace,
          LabelTextField(
            controller: controller.licenseExpiryDateController,
            readOnly: true,
            focusNode: controller.licenseDateNode,
            checkValidation: true,
            onTap: () => controller.datePickerDialog(isExpiry: true),
            isRequired: true,
            label: 'licenseExpiryDate',
            isDate: true,
          ),
          additionalDocuments(),
          20.verticalSpace,
          elevatedIconButton(
            text: "next",
            onPressed: () => controller.saveCompanyInfo(),
          ),
          16.verticalSpace,
          if (controller.showSaveAsDraft)
            CustomButton(
                buttonType: ButtonType.draft,
                onPressed: () =>
                    controller.saveCompanyInfo(saveAsDraft: true))
        ],
      ),
    );
  }

  LabelTextField nameInEnglish() {
    return LabelTextField(
      controller: controller.companyNameEnglishController,
      label: 'companyNameInEnglish',
      focusNode: controller.companyNameEnglishNode,
      isRequired: true,
      inputFormatters: InputFormatters.companyEnglishNameFormatter,
      checkValidation: true,
    );
  }

  LabelTextField nameInArabic() {
    return LabelTextField(
      controller: controller.companyNameArabicController,
      label: 'companyNameInArabic',
      focusNode: controller.companyNameArabicNode,
      isRequired: true,
      checkValidation: true,
      inputFormatters: InputFormatters.companyArabicNameFormatter,
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
