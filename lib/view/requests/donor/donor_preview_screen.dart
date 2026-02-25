import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zakat_fund/view_model/donor_preview_view_model.dart';
import 'package:zakat_fund/widgets/activity_log_btn.dart';
import 'package:zakat_fund/widgets/cache_image.dart';
import 'package:zakat_fund/widgets/expansion_tile_header.dart';
import 'package:zakat_fund/widgets/file_view_widget.dart';
import 'package:zakat_fund/widgets/label_text_field.dart';
import 'package:zakat_fund/widgets/my_app_bar.dart';

class DonorPreviewScreen extends GetView<DonorPreviewViewModel> {
  const DonorPreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(title: "donorInformation"),
      backgroundColor: Colors.white,
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Column(
        children: [
          activityLogBtn(
              model: controller.donor,
              status: 1,
              id: controller.donor.accountInfo?.userId,
              type: "User"),
          16.verticalSpace,
          donorInformation(),
          16.verticalSpace,
          contactInformation(),
          16.verticalSpace,
          metaDataInformation()
        ],
      ),
    );
  }

  Widget metaDataInformation() {
    return Obx(() => Column(
          children: [
            expansionTileHeader(
              title: "metaData",
              isExpanded: controller.showMetaDataInfo.value,
              onTap: () {
                controller.showMetaDataInfo.value =
                    !controller.showMetaDataInfo.value;
              },
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

  Widget contactInformation() {
    return Obx(() => Column(
          children: [
            expansionTileHeader(
              title: "contactInformation",
              isExpanded: controller.showContactInfo.value,
              onTap: () {
                controller.showContactInfo.value =
                    !controller.showContactInfo.value;
              },
            ),
            if (controller.showContactInfo.value)
              Column(
                children: [
                  16.verticalSpace,
                  LabelTextField(
                    controller: controller.mobileNumberPrimaryController,
                    readOnly: true,
                    label: "mobileNumberPrimary",
                  ),
                  10.verticalSpace,
                  LabelTextField(
                    controller: controller.mobileNumberSecondaryController,
                    readOnly: true,
                    label: "mobileNumberSecondary",
                  ),
                  10.verticalSpace,
                  LabelTextField(
                    controller: controller.countryController,
                    readOnly: true,
                    label: "country",
                  ),
                  10.verticalSpace,
                  LabelTextField(
                    controller: controller.emirateController,
                    readOnly: true,
                    label: "emirate",
                  ),
                  10.verticalSpace,
                  LabelTextField(
                    controller: controller.cityController,
                    readOnly: true,
                    label: "city",
                  ),
                  10.verticalSpace,
                  LabelTextField(
                    controller: controller.poBoxController,
                    readOnly: true,
                    label: "poBox",
                  ),
                ],
              )
          ],
        ));
  }

  Widget donorInformation() {
    return Obx(() => Column(
          children: [
            expansionTileHeader(
              title: "donorInformation",
              isExpanded: controller.showDonorInfo.value,
              onTap: () {
                controller.showDonorInfo.value =
                    !controller.showDonorInfo.value;
              },
            ),
            if (controller.showDonorInfo.value)
              Column(
                children: [
                  16.verticalSpace,
                  Center(
                    child: ClipOval(
                      child: CachedImage(
                        image: controller.donor.accountInfo!.photo ?? '',
                        width: 75.w,
                        height: 75.h,
                        profile: true,
                      ),
                    ),
                  ),
                  LabelTextField(
                    controller: controller.userNameController,
                    readOnly: true,
                    label: "userName",
                  ),
                  10.verticalSpace,
                  LabelTextField(
                    controller: controller.firstNameInEnglishController,
                    readOnly: true,
                    label: "firstNameInEnglish",
                  ),
                  10.verticalSpace,
                  LabelTextField(
                    controller: controller.lastNameInEnglishController,
                    readOnly: true,
                    label: "lastNameInEnglish",
                  ),
                  10.verticalSpace,
                  LabelTextField(
                    controller: controller.firstNameInArabicController,
                    readOnly: true,
                    label: "firstNameInArabic",
                  ),
                  10.verticalSpace,
                  LabelTextField(
                    controller: controller.lastNameInArabicController,
                    readOnly: true,
                    label: "lastNameInArabic",
                  ),
                  10.verticalSpace,
                  LabelTextField(
                    controller: controller.emailController,
                    readOnly: true,
                    label: "email",
                  ),
                  10.verticalSpace,
                  LabelTextField(
                    controller: controller.dobController,
                    readOnly: true,
                    label: "dob",
                  ),
                  10.verticalSpace,
                  LabelTextField(
                    controller: controller.uaeIdController,
                    readOnly: true,
                    label: "uaeId",
                  ),
                  10.verticalSpace,
                  LabelTextField(
                    controller: controller.nationalityController,
                    readOnly: true,
                    label: "nationality",
                  ),
                  if (controller.additionalDocuments.isNotEmpty)
                    16.verticalSpace,
                  if (controller.additionalDocuments.isNotEmpty)
                    expansionTileHeader(
                      title: "additionalDocuments",
                      isExpanded: controller.showAdditionalDocuments.value,
                      onTap: () {
                        controller.showAdditionalDocuments.value =
                            !controller.showAdditionalDocuments.value;
                      },
                    ),
                  if (controller.showAdditionalDocuments.value &&
                      controller.additionalDocuments.isNotEmpty)
                    ...List.generate(
                        controller.additionalDocuments.length,
                        (index) => additionalDocumentViewWidget(
                            controller.additionalDocuments[index])),
                ],
              )
          ],
        ));
  }
}
