import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/flavor/flavor_config.dart';
import 'package:zakat_fund/utils/constants/app_resources.dart';
import 'package:zakat_fund/utils/constants/app_textstyle.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/view_model/association_preview_view_model.dart';
import 'package:zakat_fund/view_model/requests_view_model.dart';
import 'package:zakat_fund/widgets/accept_reject_bottom_bar.dart';
import 'package:zakat_fund/widgets/activity_log_btn.dart';
import 'package:zakat_fund/widgets/expansion_tile_header.dart';
import 'package:zakat_fund/widgets/file_view_widget.dart';
import 'package:zakat_fund/widgets/label_text_field.dart';
import 'package:zakat_fund/widgets/my_app_bar.dart';
import 'package:zakat_fund/widgets/text_field_label.dart';

class AssociationPreviewScreen extends GetView<AssociationPreviewViewModel> {
  const AssociationPreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(title: controller.getTitle()),
      backgroundColor: Colors.white,
      body: _buildBody(),
    );
  }

  SingleChildScrollView _buildBody() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Column(
        children: [
          if (controller.request == null) ...[
            Obx(() => activityLogBtn(
                model: 1,
                status: 1,
                id: controller.accountId.value,
                type: controller.isAssociation ? "Association" : "Company")),
            16.verticalSpace,
          ],
          controller.isAssociation
              ? _buildAssociationInformation()
              : _buildCompanyInformation(),
          16.verticalSpace,
          _buildContactInformation(),
          16.verticalSpace,
          _buildRepresentativeInformation(),
          16.verticalSpace,
          _buildBankInformation(),
          if (controller.request == null) ...[
            16.verticalSpace,
            _buildMetaDataInformation()
          ],
          20.verticalSpace,
          _buildBottomActions()
        ],
      ),
    );
  }

  Widget _buildBankInformation() {
    return Obx(() => Column(
          children: [
            expansionTileHeader(
              title: "bankInformation",
              isExpanded: controller.showBankInfo.value,
              onTap: () => controller.onBankInfoTap(),
            ),
            if (controller.showBankInfo.value)
              Column(
                children: [
                  16.verticalSpace,
                  LabelTextField(
                    controller: controller.bankName,
                    readOnly: true,
                    label: "bankName",
                  ),
                  10.verticalSpace,
                  LabelTextField(
                    controller: controller.swiftCode,
                    readOnly: true,
                    label: "swiftCode",
                  ),
                  10.verticalSpace,
                  LabelTextField(
                    controller: controller.ibanNumber,
                    readOnly: true,
                    label: "ibanNumber",
                  ),
                ],
              )
          ],
        ));
  }

  Widget _buildRepresentativeInformation() {
    return Obx(() => Column(
          children: [
            expansionTileHeader(
              title: "representativeInformation",
              isExpanded: controller.showRepresentativeInfo.value,
              onTap: () => controller.onRepresentativeInfoTap(),
            ),
            if (controller.showRepresentativeInfo.value)
              Column(
                children: [
                  16.verticalSpace,
                  LabelTextField(
                    controller: controller.representativeFNameArabic,
                    readOnly: true,
                    label: "firstNameInArabic",
                  ),
                  10.verticalSpace,
                  LabelTextField(
                    controller: controller.representativeLNameArabic,
                    readOnly: true,
                    label: "lastNameInArabic",
                  ),
                  10.verticalSpace,
                  LabelTextField(
                    controller: controller.representativeFNameEnglish,
                    readOnly: true,
                    label: "firstNameInEnglish",
                  ),
                  10.verticalSpace,
                  LabelTextField(
                    controller: controller.representativeLNameEnglish,
                    readOnly: true,
                    label: "lastNameInEnglish",
                  ),
                  10.verticalSpace,
                  LabelTextField(
                    controller: controller.representativeEmail,
                    readOnly: true,
                    label: "emailAddress",
                  ),
                  10.verticalSpace,
                  LabelTextField(
                    controller: controller.representativePhone,
                    readOnly: true,
                    label: "phoneNumber",
                    isArabicDirection: true,
                  ),
                  10.verticalSpace,
                  LabelTextField(
                    controller: controller.representativeJob,
                    readOnly: true,
                    label: "jobTitle",
                  ),
                  10.verticalSpace,
                  LabelTextField(
                    controller: controller.representativeNationality,
                    readOnly: true,
                    label: "nationality",
                  ),
                  10.verticalSpace,
                  LabelTextField(
                    controller: controller.representativeEmirateId,
                    readOnly: true,
                    label: "emirateIdNumber",
                  ),
                ],
              )
          ],
        ));
  }

  Widget _buildContactInformation() {
    return Obx(() {
      bool showForCompany = !controller.isAssociation &&
          controller.company.value != null &&
          controller.company.value?.accountContact?.stateId != null;
      bool showForAssociation = controller.isAssociation &&
          controller.association.value != null &&
          controller.association.value?.accountContact?.stateId != null;

      return Column(
        children: [
          expansionTileHeader(
            title: "contactInformation",
            isExpanded: controller.showContactInfo.value,
            onTap: () => controller.onContactInfoTap(),
          ),
          if (controller.showContactInfo.value)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                16.verticalSpace,
                LabelTextField(
                  controller: controller.contactEmail,
                  readOnly: true,
                  label: "emailAddress",
                ),
                10.verticalSpace,
                LabelTextField(
                  controller: controller.contactPhone,
                  readOnly: true,
                  isArabicDirection: true,
                  label: "phoneNumber",
                ),
                10.verticalSpace,
                LabelTextField(
                  isArabicDirection: true,
                  controller: controller.contactFax,
                  readOnly: true,
                  label: "fax",
                ),
                10.verticalSpace,
                LabelTextField(
                  controller: controller.contactWeb,
                  readOnly: true,
                  label: "websiteLink",
                ),
                10.verticalSpace,
                LabelTextField(
                  controller: controller.contactCountry,
                  readOnly: true,
                  label: "country",
                ),
                if (showForCompany || showForAssociation) ...[
                  10.verticalSpace,
                  LabelTextField(
                    controller: controller.contactEmirate,
                    readOnly: true,
                    label: "emirate",
                  )
                ],
                10.verticalSpace,
                LabelTextField(
                  controller: controller.contactCity,
                  readOnly: true,
                  label: "city",
                ),
                10.verticalSpace,
                LabelTextField(
                  controller: controller.contactPoBox,
                  readOnly: true,
                  label: "poBox",
                ),
                10.verticalSpace,
                if (controller.isAssociation) _buildAddressesTextField(),
                if (!controller.isAssociation)
                  Text(
                    "address".tr,
                    style: AppTextStyle.primaryDarkGrey14spTextStyle1,
                  ),
                if (!controller.isAssociation) ...[
                  10.verticalSpace,
                  _buildAddresses()
                ],
                textFieldLabel(label: "firstSupportDocument"),
                4.verticalSpace,
                Obx(() => fileViewWidget(
                    isImage: false, value: controller.fDocument.value)),
                10.verticalSpace,
                textFieldLabel(label: "secondSupportDocument"),
                4.verticalSpace,
                Obx(() => fileViewWidget(
                    isImage: false, value: controller.sDocument.value)),
                if (controller.isAssociation)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      10.verticalSpace,
                      textFieldLabel(label: "socialMediaLinks"),
                      8.verticalSpace,
                      LabelTextField(
                        controller: controller.contactInstagram,
                        label: 'instagram',
                        isBlack: true,
                        readOnly: true,
                        prefixIcon: AppResources.instagramIcon,
                      ),
                      10.verticalSpace,
                      LabelTextField(
                        controller: controller.contactTwitter,
                        label: 'twitter',
                        isBlack: true,
                        readOnly: true,
                        prefixIcon: AppResources.twitterIcon,
                      ),
                      10.verticalSpace,
                      LabelTextField(
                        controller: controller.contactFacebook,
                        label: 'facebook',
                        isBlack: true,
                        readOnly: true,
                        prefixIcon: AppResources.facebookIcon,
                      ),
                      10.verticalSpace,
                      LabelTextField(
                        controller: controller.contactLinkedIn,
                        label: 'linkedIn',
                        readOnly: true,
                        isBlack: true,
                        prefixIcon: AppResources.linkedinIcon,
                      ),
                    ],
                  )
              ],
            )
        ],
      );
    });
  }

  Column _buildAddresses() {
    return Column(
        children: List.generate(
            controller.addresses.length,
            (index) => Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
                  margin: EdgeInsets.only(bottom: 16.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(20.r)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        offset: const Offset(0.0, 4.0),
                        blurRadius: 50.0,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        "${index == 0 ? "address1".tr : "address2".tr} ${controller.addresses[index].isDefault ? "primary".tr : ""}",
                        style: AppTextStyle.secondaryPrimaryBlack16spTextStyle,
                      ),
                      8.verticalSpace,
                      Text(controller.addresses[index].street,
                          maxLines: 1,
                          style:
                              AppTextStyle.secondaryPrimaryBlack14spTextStyle),
                      Text(controller.addresses[index].building,
                          maxLines: 1,
                          style:
                              AppTextStyle.secondaryPrimaryBlack14spTextStyle),
                      Text(controller.addresses[index].landmark,
                          maxLines: 1,
                          style:
                              AppTextStyle.secondaryPrimaryBlack14spTextStyle),
                    ],
                  ),
                )));
  }

  Column _buildAddressesTextField() {
    return Column(
      children: [
        LabelTextField(
          controller: controller.contactAddressArabic,
          readOnly: true,
          label: "addressInArabic",
        ),
        10.verticalSpace,
        LabelTextField(
          controller: controller.contactAddressEnglish,
          readOnly: true,
          label: "addressInEnglish",
        ),
        10.verticalSpace,
      ],
    );
  }

  Widget _buildCompanyInformation() {
    return Obx(() => controller.company.value != null
        ? Column(
            children: [
              expansionTileHeader(
                title: "companyInformation",
                isExpanded: controller.showAssociationInfo.value,
                onTap: () => controller.onAssociationInfoTap(),
              ),
              if (controller.showAssociationInfo.value)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    16.verticalSpace,
                    textFieldLabel(label: "companyLogo"),
                    6.verticalSpace,
                    CachedNetworkImage(
                      imageUrl:
                          "${FlavorConfig.storageUrl}/${controller.company.value?.accountInfo?.accountLogo}",
                    ),
                    10.verticalSpace,
                    LabelTextField(
                      controller: controller.companyNameInEnglish,
                      readOnly: true,
                      label: "companyNameInEnglish",
                    ),
                    10.verticalSpace,
                    LabelTextField(
                      controller: controller.companyNameInArabic,
                      readOnly: true,
                      label: "companyNameInArabic",
                    ),
                    10.verticalSpace,
                    LabelTextField(
                      controller: controller.companyDateOfEstablishment,
                      readOnly: true,
                      label: "dateOfEstablishment",
                    ),
                    10.verticalSpace,
                    LabelTextField(
                      controller: controller.companyField,
                      readOnly: true,
                      label: "companyType",
                    ),
                    10.verticalSpace,
                    LabelTextField(
                      controller: controller.companyIssuingAuthority,
                      readOnly: true,
                      label: "issuingAuthority",
                    ),
                    10.verticalSpace,
                    LabelTextField(
                      controller: controller.companyIssuingDate,
                      readOnly: true,
                      isDate: true,
                      label: "licenseExpiryDate",
                    ),
                    10.verticalSpace,
                    textFieldLabel(label: "companyLicense"),
                    4.verticalSpace,
                    fileViewWidget(
                        isImage: true,
                        value:
                            "${controller.company.value?.accountInfo?.license}"),
                    if (controller.additionalDocuments.isNotEmpty) ...[
                      16.verticalSpace,
                      expansionTileHeader(
                        title: "additionalDocuments",
                        isExpanded: controller.showAdditionalDocuments.value,
                        onTap: () {
                          controller.showAdditionalDocuments.value =
                              !controller.showAdditionalDocuments.value;
                        },
                      )
                    ],
                    if (controller.showAdditionalDocuments.value &&
                        controller.additionalDocuments.isNotEmpty)
                      ...List.generate(
                          controller.additionalDocuments.length,
                          (index) => additionalDocumentViewWidget(
                              controller.additionalDocuments[index])),
                  ],
                )
            ],
          )
        : const SizedBox.shrink());
  }

  Widget _buildAssociationInformation() {
    return Obx(() => controller.association.value != null
        ? Column(
            children: [
              expansionTileHeader(
                title: "associationInformation",
                isExpanded: controller.showAssociationInfo.value,
                onTap: () => controller.onAssociationInfoTap(),
              ),
              if (controller.showAssociationInfo.value)
                Column(
                  children: [
                    16.verticalSpace,
                    textFieldLabel(label: "associationLogo"),
                    6.verticalSpace,
                    if (controller.association.value?.associationInfo != null)
                      CachedNetworkImage(
                        imageUrl:
                            "${FlavorConfig.storageUrl}/${controller.association.value?.associationInfo!.accountLogo}",
                        placeholder: (context, url) => Image.asset(
                          AppResources.placeholder,
                          fit: BoxFit.cover,
                        ),
                      ),
                    10.verticalSpace,
                    LabelTextField(
                      controller: controller.associationNameInEnglish,
                      readOnly: true,
                      label: "associationNameInEnglish",
                    ),
                    10.verticalSpace,
                    LabelTextField(
                      controller: controller.associationNameInArabic,
                      readOnly: true,
                      label: "associationNameInArabic",
                    ),
                    10.verticalSpace,
                    LabelTextField(
                      controller: controller.associationDescInEnglish,
                      readOnly: true,
                      maxLines: 4,
                      label: "associationDescInEnglish",
                    ),
                    10.verticalSpace,
                    LabelTextField(
                      controller: controller.associationDescInArabic,
                      readOnly: true,
                      maxLines: 4,
                      label: "associationDescInArabic",
                    ),
                    10.verticalSpace,
                    LabelTextField(
                      controller: controller.dateOfEstablishment,
                      readOnly: true,
                      isDate: true,
                      label: "dateOfEstablishment",
                    ),
                    10.verticalSpace,
                    LabelTextField(
                      controller: controller.associationType,
                      readOnly: true,
                      label: "associationType",
                    ),
                    10.verticalSpace,
                    LabelTextField(
                      controller: controller.licensingAuthority,
                      readOnly: true,
                      label: "licensingAuthority",
                    ),
                    10.verticalSpace,
                    LabelTextField(
                      controller: controller.licenseExpiryDate,
                      readOnly: true,
                      label: "licenseExpiryDate",
                      isDate: true,
                    ),
                    10.verticalSpace,
                    textFieldLabel(label: "associationCoverPhoto"),
                    4.verticalSpace,
                    if (controller.association.value!.associationInfo != null)
                      fileViewWidget(
                          isImage: true,
                          value: controller.association.value!.associationInfo!
                              .associationCoverPhoto!),
                    10.verticalSpace,
                    textFieldLabel(label: "associationLicense"),
                    4.verticalSpace,
                    if (controller.association.value!.associationInfo != null)
                      fileViewWidget(
                          isImage: false,
                          value: controller
                              .association.value!.associationInfo!.license!),
                    if (controller.additionalDocuments.isNotEmpty) ...[
                      16.verticalSpace,
                      expansionTileHeader(
                        title: "additionalDocuments",
                        isExpanded: controller.showAdditionalDocuments.value,
                        onTap: () {
                          controller.showAdditionalDocuments.value =
                              !controller.showAdditionalDocuments.value;
                        },
                      )
                    ],
                    if (controller.showAdditionalDocuments.value &&
                        controller.additionalDocuments.isNotEmpty)
                      ...List.generate(
                          controller.additionalDocuments.length,
                          (index) => additionalDocumentViewWidget(
                              controller.additionalDocuments[index])),
                  ],
                )
            ],
          )
        : const SizedBox.shrink());
  }

  Widget _buildMetaDataInformation() {
    return Obx(() => Column(
          children: [
            expansionTileHeader(
              title: "metaData",
              isExpanded: controller.showMetaDataInfo.value,
              onTap: () => controller.onMetaDataTap(),
            ),
            if (controller.showMetaDataInfo.value)
              Column(
                children: [
                  16.verticalSpace,
                  LabelTextField(
                    controller: controller.createdByController,
                    readOnly: true,
                    label: "createdBy",
                  ),
                  10.verticalSpace,
                  LabelTextField(
                    controller: controller.modifiedByController,
                    readOnly: true,
                    label: "modifiedBy",
                  ),
                  10.verticalSpace,
                  LabelTextField(
                    controller: controller.createdAtController,
                    readOnly: true,
                    label: "createdAt",
                  ),
                  10.verticalSpace,
                  LabelTextField(
                    controller: controller.modifiedAtController,
                    readOnly: true,
                    label: "modifiedAt",
                  ),
                ],
              )
          ],
        ));
  }

  Widget _buildBottomActions() {
    return Obx(() {
      if (controller.isAdmin.value && controller.request != null) {
        return acceptRejectBottomBar(
          onAccept: controller.showAccept
              ? () {
                  Utils.showLoadingDialog();
                  Get.find<RequestsViewModel>().approveRejectRequest(
                      accountId: controller.isAssociation
                          ? controller
                              .association.value?.associationInfo?.accountId
                          : controller.company.value?.accountInfo?.accountId,
                      request: controller.request!,
                      message: controller.isAssociation
                          ? "associationAccepted"
                          : "companyAccepted");
                }
              : null,
          onReturn: controller.showReturn
              ? () => Utils.openRejectionScreen(
                    title: controller.isAssociation
                        ? "associationReturn"
                        : "companyReturn",
                    request: controller.request!,
                  )
              : null,
          onReject: controller.showReject
              ? () => Utils.openRejectionScreen(
                  title: controller.isAssociation
                      ? "associationRejection"
                      : "companyRejection",
                  request: controller.request!,
                  isRejected: true)
              : null,
        );
      }
      return SizedBox.shrink();
    });
  }
}
