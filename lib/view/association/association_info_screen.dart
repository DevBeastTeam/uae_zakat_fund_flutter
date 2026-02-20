import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/utils/constants/input_formatters.dart';
import 'package:zakat_fund/utils/enums/button_type.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/view_model/association_view_model.dart';
import 'package:zakat_fund/widgets/additional_doc_widget.dart';
import 'package:zakat_fund/widgets/custom_button.dart';
import 'package:zakat_fund/widgets/elevated_icon_button.dart';
import 'package:zakat_fund/widgets/expansion_tile_header.dart';
import 'package:zakat_fund/widgets/label_drop_down2.dart';
import 'package:zakat_fund/widgets/label_text_field.dart';
import 'package:zakat_fund/widgets/picture_instruct_widget.dart';

class AssociationInfoScreen extends GetView<AssociationViewModel> {
  const AssociationInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.associationInfoFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LabelTextField(
            label: 'associationLogo',
            isRequired: true,
            readOnly: true,
            focusNode: controller.associationLogoNode,
            checkValidation: true,
            onAddFile: () => controller.addImage(logo: true),
            controller: controller.associationLogoController,
          ),
          6.verticalSpace,
          pictureInstructWidget(),
          16.verticalSpace,
          LabelTextField(
            label: 'associationCoverPhoto',
            isRequired: true,
            focusNode: controller.associationCoverNode,
            checkValidation: true,
            onAddFile: () => controller.addImage(),
            controller: controller.associationCoverController,
          ),
          6.verticalSpace,
          pictureInstructWidget(),
          16.verticalSpace,
          Utils.isArabic ? associationNameArabic() : associationNameEnglish(),
          16.verticalSpace,
          Utils.isArabic ? associationNameEnglish() : associationNameArabic(),
          16.verticalSpace,
          Utils.isArabic ? associationDescArabic() : associationDescEnglish(),
          16.verticalSpace,
          Utils.isArabic ? associationDescEnglish() : associationDescArabic(),
          16.verticalSpace,
          Obx(() => LabelDropDown2(
                showSearch: true,
                items: controller.associationTypeList.value,
                selectedValue: controller.selectedAssociationType.value,
                onChanged: (value) => controller.selectedAssociationType.value = value!,
                isRequired: true,
            focusNode: controller.associationTypeNode,
                label: 'associationType',
                hint: "selectAssociationType",
              )),
          16.verticalSpace,
          LabelTextField(
            controller: controller.dateOfEstablishmentController,
            readOnly: true,
            focusNode: controller.dateOfEstablishmentNode,
            isRequired: true,
            checkValidation: true,
            onTap: () => controller.datePickerDialog(),
            label: 'dateOfEstablishment',
            isDate: true,
          ),
          16.verticalSpace,
          LabelTextField(
            label: 'associationLicense',
            isRequired: true,
            checkValidation: true,
            focusNode: controller.associationLicenseNode,
            readOnly: true,
            onAddFile: () => controller.addFile(license: true),
            controller: controller.associationLicenseController,
          ),
          6.verticalSpace,
          fileInstructWidget(),
          16.verticalSpace,
          LabelTextField(
            controller: controller.dateOfExpiryController,
            readOnly: true,
            focusNode: controller.dateOfExpiryNode,
            isRequired: true,
            checkValidation: true,
            onTap: () => controller.datePickerDialog(isExpiry: true),
            label: 'licenseExpiryDate',
            isDate: true,
          ),
          16.verticalSpace,
          Obx(() => LabelDropDown2(
                items: controller.licensingAuthorityList.value,
                selectedValue: controller.selectedLicensingAuthority.value,
                onChanged: (value) => controller.selectedLicensingAuthority.value = value!,
                isRequired: true,
            focusNode: controller.licensingAuthorityNode,
                hint: "selectLicensingAuthority",
                label: 'licensingAuthority',
              )),
          additionalDocuments(),
          20.verticalSpace,
          elevatedIconButton(
            text: "next",
            onPressed: () => controller.saveAssociationInfo(saveAsDraft: false),
          ),
          16.verticalSpace,
          if (controller.showSaveAsDraft)
            CustomButton(
                buttonType: ButtonType.draft,
                onPressed: () =>
                    controller.saveAssociationInfo(saveAsDraft: true))
        ],
      ),
    );
  }

  LabelTextField associationNameArabic() {
    return LabelTextField(
      controller: controller.associationNameArabicController,
      label: 'associationNameInArabic',
      focusNode: controller.associationNameArabicNode,
      isRequired: true,
      inputFormatters: InputFormatters.arabicNameFormatter,
      checkValidation: true,
    );
  }

  LabelTextField associationNameEnglish() {
    return LabelTextField(
      controller: controller.associationNameEnglishController,
      label: 'associationNameInEnglish',
      isRequired: true,
      focusNode: controller.associationNameEnglishNode,
      checkValidation: true,
      inputFormatters: InputFormatters.englishNameFormatter,
    );
  }

  LabelTextField associationDescArabic() {
    return LabelTextField(
      controller: controller.associationDescArabicController,
      label: 'associationDescInArabic',
      isRequired: true,
      maxLength: 300,
      focusNode: controller.associationDescArabicNode,
      maxLines: 4,
      inputFormatters: InputFormatters.arabicAddressFormatter,
      checkValidation: true,
    );
  }

  LabelTextField associationDescEnglish() {
    return LabelTextField(
      controller: controller.associationDescEnglishController,
      label: 'associationDescInEnglish',
      maxLines: 4,
      maxLength: 300,
      focusNode: controller.associationDescEnglishNode,
      isRequired: true,
      checkValidation: true,
      inputFormatters: InputFormatters.englishAddressFormatter,
    );
  }

  Widget additionalDocuments() {
    return Obx(() => controller.additionalDocuments.isNotEmpty
        ? Column(
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
          )
        : SizedBox.shrink());
  }
}
